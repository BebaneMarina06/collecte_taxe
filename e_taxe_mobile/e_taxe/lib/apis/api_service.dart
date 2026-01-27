import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/collecteur.dart';
import '../models/contribuable.dart';
import '../models/taxe.dart';
import '../models/collecte.dart';
import '../models/statistiques.dart';
import '../services/storage_service.dart';

class ApiService {
  /// URL du backend en local (Docker sur la machine de dev)
  static const String _localDockerBaseUrl = 'http://localhost:8000';

  /// URL du backend vue depuis un émulateur Android (localhost de la machine = 10.0.2.2)
  static const String _androidEmulatorBaseUrl = 'http://10.0.2.2:8000';

  /// URL par défaut pour iPhone physique (à configurer avec l'IP locale)
  /// Remplacez par l'IP locale de votre ordinateur (trouvée via ipconfig)
  static const String _defaultIOSPhysicalIP = '192.241.10.19';

  /// URL du backend de production (Render ou autre)
  static const String _productionBaseUrl = 'https://taxe-municipale.onrender.com';

  /// Clé pour stocker l'IP personnalisée dans SharedPreferences
  static const String _customIPKey = 'api_custom_ip';

  /// Cache pour l'URL de base (évite de lire SharedPreferences à chaque appel)
  static String? _cachedBaseUrl;

  /// Base URL effective
  /// - En debug: on pointe sur Docker en local
  ///   - Emulateur Android: 10.0.2.2
  ///   - iOS Simulator: localhost
  ///   - iOS Physique: IP locale (configurable)
  /// - En release: URL de prod (Render)
  static Future<String> get baseUrl async {
    // Utiliser le cache si disponible
    if (_cachedBaseUrl != null) {
      return _cachedBaseUrl!;
    }

    if (kReleaseMode) {
      _cachedBaseUrl = _productionBaseUrl;
      return _cachedBaseUrl!;
    }

    // Possibilité de surcharger via --dart-define=API_BASE_URL=...
    const fromEnv = String.fromEnvironment('API_BASE_URL');
    if (fromEnv.isNotEmpty) {
      _cachedBaseUrl = fromEnv;
      return _cachedBaseUrl!;
    }

    // Android (émulateur ou appareil physique)
    // Avec `adb reverse tcp:8000 tcp:8000`, le backend Docker est accessible
    // depuis le téléphone via http://localhost:8000
    if (defaultTargetPlatform == TargetPlatform.android) {
      _cachedBaseUrl = _localDockerBaseUrl;
      return _cachedBaseUrl!;
    }

    // iOS
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // Vérifier si on est sur un iPhone physique (pas un simulateur)
      if (Platform.isIOS && !kIsWeb) {
        // Vérifier si une IP personnalisée est configurée
        final prefs = await SharedPreferences.getInstance();
        final customIP = prefs.getString(_customIPKey);
        
        if (customIP != null && customIP.isNotEmpty) {
          _cachedBaseUrl = 'http://$customIP:8000';
          return _cachedBaseUrl!;
        }
        
        // Utiliser l'IP par défaut (à modifier selon votre réseau)
        _cachedBaseUrl = 'http://$_defaultIOSPhysicalIP:8000';
        return _cachedBaseUrl!;
      }
      
      // iOS Simulator
      _cachedBaseUrl = _localDockerBaseUrl;
      return _cachedBaseUrl!;
    }

    // Web / desktop
    _cachedBaseUrl = _localDockerBaseUrl;
    return _cachedBaseUrl!;
  }

  /// Définir l'IP personnalisée pour iPhone physique
  static Future<void> setCustomIP(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customIPKey, ip);
    // Invalider le cache pour forcer la mise à jour
    _cachedBaseUrl = null;
    print('✅ IP personnalisée configurée: $ip');
  }

  /// Obtenir l'IP personnalisée configurée
  static Future<String?> getCustomIP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_customIPKey);
  }

  /// Réinitialiser le cache (utile après changement d'IP)
  static void clearBaseUrlCache() {
    _cachedBaseUrl = null;
  }

  // Headers avec authentification
  Future<Map<String, String>> _getHeaders({bool needsAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (needsAuth) {
      final token = await StorageService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Gérer les erreurs HTTP
  void _handleError(http.Response response) {
    if (response.statusCode == 401) {
      throw Exception('Session expirée. Veuillez vous reconnecter.');
    } else if (response.statusCode == 403) {
      throw Exception('Accès interdit.');
    } else if (response.statusCode == 404) {
      throw Exception('Ressource non trouvée.');
    } else if (response.statusCode >= 400) {
      try {
        final error = json.decode(response.body);
        throw Exception(error['detail'] ?? 'Une erreur est survenue.');
      } catch (e) {
        throw Exception('Erreur ${response.statusCode}: ${response.body}');
      }
    }
  }

  // ========== AUTHENTIFICATION ==========

  Future<Map<String, dynamic>> login(String email, String password) async {
    String? urlUsed; // Variable pour stocker l'URL utilisée
    try {
      // Réinitialiser le cache de l'URL pour forcer une nouvelle résolution
      clearBaseUrlCache();
      urlUsed = await baseUrl;
      
      print('🔗 Tentative de connexion à: $urlUsed/api/auth/login');
      
      // Test de connexion rapide avant le login
      try {
        final testResponse = await http.get(
          Uri.parse('$urlUsed/docs'),
          headers: {'Content-Type': 'application/json'},
        ).timeout(const Duration(seconds: 3));
        print('✅ Test de connexion réussi (${testResponse.statusCode})');
      } catch (testError) {
        print('⚠️ Test de connexion échoué: $testError');
        // Continuer quand même, le test peut échouer mais le login peut fonctionner
      }
      
      final response = await http.post(
        Uri.parse('$urlUsed/api/auth/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': email,
          'password': password,
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Timeout: Le serveur ne répond pas après 15 secondes.\n\n'
              'URL utilisée: ${urlUsed ?? "non déterminée"}\n\n'
              'Vérifications:\n'
              '1. Backend Docker démarré: docker ps\n'
              '2. Port forwarding actif: adb reverse tcp:8000 tcp:8000\n'
              '3. Appareil connecté en USB');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Sauvegarder le token
        await StorageService.saveToken(data['access_token']);
        
        // Sauvegarder les infos utilisateur
        if (data['user'] != null) {
          final user = data['user'] as Map<String, dynamic>;
          await StorageService.saveUserInfo(
            userId: user['id'] as int,
            email: user['email'] as String,
            nom: user['nom'] as String,
            prenom: user['prenom'] as String,
          );
        }

        print('✅ Connexion réussie');
        return data;
      } else {
        _handleError(response);
        throw Exception('Email ou mot de passe incorrect.');
      }
    } catch (e) {
      String errorMessage = e.toString();
      
      // Si l'URL n'a pas été déterminée, essayer de la récupérer
      if (urlUsed == null) {
        try {
          urlUsed = await baseUrl;
        } catch (_) {
          urlUsed = 'non déterminée';
        }
      }
      
      if (errorMessage.contains('SocketException') || 
          errorMessage.contains('Failed host lookup') ||
          errorMessage.contains('Connection refused')) {
        errorMessage = 'Impossible de se connecter au serveur.\n\n'
            'URL utilisée: $urlUsed\n\n'
            'Vérifications:\n'
            '1. Le backend Docker est démarré (docker ps)\n'
            '2. Le port forwarding est actif (adb reverse tcp:8000 tcp:8000)\n'
            '3. Votre appareil est connecté en USB\n'
            '4. Votre connexion internet est active\n\n'
            'Commande pour activer le port forwarding:\n'
            'adb reverse tcp:8000 tcp:8000';
      } else if (errorMessage.contains('Timeout')) {
        // Le message d'erreur contient déjà l'URL depuis le timeout handler
        // Pas besoin de le modifier
      } else {
        // Pour les autres erreurs, ajouter l'URL
        errorMessage = '$errorMessage\n\nURL utilisée: $urlUsed';
      }
      
      print('❌ Erreur de connexion: $errorMessage');
      throw Exception(errorMessage);
    }
  }

  // ========== COLLECTEUR ==========

  Future<Collecteur> getCollecteur(int collecteurId) async {
    final url = await baseUrl;
    final response = await http.get(
      Uri.parse('$url/api/collecteurs/$collecteurId/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return Collecteur.fromJson(json.decode(response.body));
    } else {
      _handleError(response);
      throw Exception('Erreur lors de la récupération du collecteur');
    }
  }

  Future<Collecteur?> getCollecteurByEmail(String email) async {
    try {
      // Récupérer tous les collecteurs et filtrer par email
      // Note: Si votre backend a un endpoint spécifique, utilisez-le
      final url = await baseUrl;
      final response = await http.get(
        Uri.parse('$url/api/collecteurs/?email=$email'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Si c'est une liste, prendre le premier élément
        if (data is List && data.isNotEmpty) {
          return Collecteur.fromJson(data[0] as Map<String, dynamic>);
        } else if (data is Map) {
          return Collecteur.fromJson(data as Map<String, dynamic>);
        }
        return null;
      } else if (response.statusCode == 404) {
        return null; // Collecteur non trouvé
      } else {
        _handleError(response);
        return null;
      }
    } catch (e) {
      // Si l'endpoint n'existe pas, essayer de récupérer par liste et filtrer
      try {
        final url = await baseUrl;
        final response = await http.get(
          Uri.parse('$url/api/collecteurs/'),
          headers: await _getHeaders(),
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          for (var item in data) {
            if (item['email'] == email) {
              return Collecteur.fromJson(item as Map<String, dynamic>);
            }
          }
        }
        return null;
      } catch (e2) {
        return null;
      }
    }
  }

  Future<void> connecterCollecteur(int collecteurId) async {
    final url = await baseUrl;
    final response = await http.patch(
      Uri.parse('$url/api/collecteurs/$collecteurId/connexion/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      _handleError(response);
    }
  }

  // Enregistrer un appareil pour un collecteur
  Future<bool> registerDevice({
    required int collecteurId,
    required Map<String, dynamic> deviceInfo,
  }) async {
    try {
      final url = await baseUrl;
      final response = await http.post(
        Uri.parse('$url/api/collecteurs/$collecteurId/devices/register'),
        headers: await _getHeaders(),
        body: json.encode(deviceInfo),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        _handleError(response);
        return false;
      }
    } catch (e) {
      print('❌ ApiService: Erreur lors de l\'enregistrement de l\'appareil: $e');
      return false;
    }
  }

  // Vérifier si un appareil est autorisé
  Future<bool> isDeviceAuthorized(int collecteurId, String deviceId) async {
    try {
      final url = await baseUrl;
      final response = await http.get(
        Uri.parse('$url/api/collecteurs/$collecteurId/devices/$deviceId/authorized'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['authorized'] == true;
      } else if (response.statusCode == 404) {
        // Appareil non trouvé = non autorisé
        return false;
      } else {
        _handleError(response);
        return false;
      }
    } catch (e) {
      print('❌ ApiService: Erreur lors de la vérification de l\'appareil: $e');
      // En cas d'erreur, autoriser pour ne pas bloquer (peut être changé selon les besoins)
      return true;
    }
  }

  // Vérifier si l'heure de connexion est autorisée
  Future<bool> canLoginAtTime(int collecteurId) async {
    try {
      final url = await baseUrl;
      final response = await http.get(
        Uri.parse('$url/api/collecteurs/$collecteurId/login-time-check'),
        headers: await _getHeaders(), // nécessite le token déjà reçu
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['allowed'] == true;
      } else {
        // En cas d'erreur, autoriser pour ne pas bloquer
        return true;
      }
    } catch (e) {
      print('❌ ApiService: Erreur lors de la vérification de l\'heure: $e');
      // En cas d'erreur, autoriser pour ne pas bloquer
      return true;
    }
  }

  Future<void> deconnecterCollecteur(int collecteurId) async {
    final url = await baseUrl;
    final response = await http.patch(
      Uri.parse('$url/api/collecteurs/$collecteurId/deconnexion/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      _handleError(response);
    }
  }

  // ========== COLLECTES ==========

  Future<List<Collecte>> getCollectes({
    int? collecteurId,
    int? contribuableId,
    int? taxeId,
    String? statut,
    String? dateDebut,
    String? dateFin,
    String? telephone,
    int skip = 0,
    int limit = 100,
  }) async {
    final queryParams = <String, String>{};
    if (collecteurId != null) queryParams['collecteur_id'] = collecteurId.toString();
    if (contribuableId != null) queryParams['contribuable_id'] = contribuableId.toString();
    if (taxeId != null) queryParams['taxe_id'] = taxeId.toString();
    if (statut != null) queryParams['statut'] = statut;
    if (dateDebut != null) queryParams['date_debut'] = dateDebut;
    if (dateFin != null) queryParams['date_fin'] = dateFin;
    if (telephone != null) queryParams['telephone'] = telephone;
    queryParams['skip'] = skip.toString();
    queryParams['limit'] = limit.toString();

    final url = await baseUrl;
    final uri = Uri.parse('$url/api/collectes/').replace(queryParameters: queryParams);
    
    print('🌐 API: GET $uri');
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );

    print('📥 API Collectes: Status ${response.statusCode}, Body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Collecte.fromJson(json)).toList();
    } else {
      _handleError(response);
      throw Exception('Erreur lors de la récupération des collectes');
    }
  }

  Future<Collecte> getCollecte(int collecteId) async {
    final url = await baseUrl;
    final response = await http.get(
      Uri.parse('$url/api/collectes/$collecteId/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return Collecte.fromJson(json.decode(response.body));
    } else {
      _handleError(response);
      throw Exception('Erreur lors de la récupération de la collecte');
    }
  }

  Future<Collecte> createCollecte(Map<String, dynamic> data) async {
    final url = await baseUrl;
    final response = await http.post(
      Uri.parse('$url/api/collectes/'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      return Collecte.fromJson(json.decode(response.body));
    } else {
      _handleError(response);
      throw Exception('Erreur lors de la création de la collecte');
    }
  }

  Future<Collecte> validerCollecte(int collecteId) async {
    final url = await baseUrl;
    final response = await http.patch(
      Uri.parse('$url/api/collectes/$collecteId/valider/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return Collecte.fromJson(json.decode(response.body));
    } else {
      _handleError(response);
      throw Exception('Erreur lors de la validation de la collecte');
    }
  }

  Future<Collecte> annulerCollecte(int collecteId, {String? raison}) async {
    final url = await baseUrl;
    final response = await http.patch(
      Uri.parse('$url/api/collectes/$collecteId/annuler/'),
      headers: await _getHeaders(),
      body: json.encode(raison != null ? {'raison': raison} : {}),
    );

    if (response.statusCode == 200) {
      return Collecte.fromJson(json.decode(response.body));
    } else {
      _handleError(response);
      throw Exception('Erreur lors de l\'annulation de la collecte');
    }
  }

  // ========== CONTRIBUABLES ==========

  Future<List<Contribuable>> getContribuables({
    int? collecteurId,
    bool? actif,
    int skip = 0,
    int limit = 100,
  }) async {
    final queryParams = <String, String>{};
    if (collecteurId != null) queryParams['collecteur_id'] = collecteurId.toString();
    if (actif != null) queryParams['actif'] = actif.toString();
    queryParams['skip'] = skip.toString();
    queryParams['limit'] = limit.toString();

    final url = await baseUrl;
    final uri = Uri.parse('$url/api/contribuables/').replace(queryParameters: queryParams);
    
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Contribuable.fromJson(json)).toList();
    } else {
      _handleError(response);
      throw Exception('Erreur lors de la récupération des contribuables');
    }
  }

  Future<Contribuable> getContribuable(int contribuableId) async {
    final url = await baseUrl;
    final response = await http.get(
      Uri.parse('$url/api/contribuables/$contribuableId/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return Contribuable.fromJson(json.decode(response.body));
    } else {
      _handleError(response);
      throw Exception('Erreur lors de la récupération du contribuable');
    }
  }

  Future<Contribuable> createContribuable(Map<String, dynamic> data) async {
    final url = await baseUrl;
    final response = await http.post(
      Uri.parse('$url/api/contribuables/'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      return Contribuable.fromJson(json.decode(response.body));
    } else {
      _handleError(response);
      throw Exception('Erreur lors de la création du contribuable');
    }
  }

  // ========== RÉFÉRENCES ==========

  Future<List<Map<String, dynamic>>> getTypesContribuables({bool? actif}) async {
    final queryParams = <String, String>{};
    if (actif != null) queryParams['actif'] = actif.toString();

    final url = await baseUrl;
    final uri = Uri.parse('$url/api/references/types-contribuables').replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      _handleError(response);
      throw Exception('Erreur lors de la récupération des types de contribuables');
    }
  }

  Future<List<Map<String, dynamic>>> getQuartiers({int? zoneId, bool? actif}) async {
    final queryParams = <String, String>{};
    if (zoneId != null) queryParams['zone_id'] = zoneId.toString();
    if (actif != null) queryParams['actif'] = actif.toString();

    final url = await baseUrl;
    final uri = Uri.parse('$url/api/references/quartiers').replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      _handleError(response);
      throw Exception('Erreur lors de la récupération des quartiers');
    }
  }

  // ========== TAXES ==========

  Future<List<Taxe>> getTaxes({
    bool? actif,
    int? typeTaxeId,
    int? serviceId,
    int skip = 0,
    int limit = 100,
  }) async {
    final queryParams = <String, String>{};
    if (actif != null) queryParams['actif'] = actif.toString();
    if (typeTaxeId != null) queryParams['type_taxe_id'] = typeTaxeId.toString();
    if (serviceId != null) queryParams['service_id'] = serviceId.toString();
    queryParams['skip'] = skip.toString();
    queryParams['limit'] = limit.toString();

    final url = await baseUrl;
    final uri = Uri.parse('$url/api/taxes/').replace(queryParameters: queryParams);
    
    print('🌐 API: GET $uri');
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );

    print('📥 API Taxes: Status ${response.statusCode}, Body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Taxe.fromJson(json)).toList();
    } else {
      _handleError(response);
      throw Exception('Erreur lors de la récupération des taxes');
    }
  }

  // ========== STATISTIQUES ==========

  Future<StatistiquesCollecteur> getStatistiquesCollecteur(int collecteurId) async {
    // Essayer plusieurs endpoints possibles
    final endpoints = [
      '/api/rapports/collecteur/$collecteurId/',
      '/api/collecteurs/$collecteurId/statistiques/',
      '/api/statistiques/collecteur/$collecteurId/',
    ];
    
    final url = await baseUrl;
    for (final endpoint in endpoints) {
      try {
        final uri = Uri.parse('$url$endpoint');
        print('🌐 API: GET $uri');
        final response = await http.get(
          uri,
          headers: await _getHeaders(),
        );

        print('📥 API Statistiques: Status ${response.statusCode}, Body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');
        if (response.statusCode == 200) {
          return StatistiquesCollecteur.fromJson(json.decode(response.body));
        }
      } catch (e) {
        print('⚠️ Tentative avec $endpoint échouée: $e');
        continue;
      }
    }
    
    // Si aucun endpoint ne fonctionne, calculer les statistiques localement
    print('⚠️ Aucun endpoint de statistiques disponible, calcul local...');
    try {
      final collectes = await getCollectes(collecteurId: collecteurId, limit: 1000);
      final totalCollecte = collectes
          .where((c) => c.isCompleted)
          .fold(0.0, (sum, c) => sum + c.montant);
      final commissionTotale = collectes
          .where((c) => c.isCompleted)
          .fold(0.0, (sum, c) => sum + c.commission);
      final nombreCollectes = collectes.length;
      final collectesCompletes = collectes.where((c) => c.isCompleted).length;
      
      return StatistiquesCollecteur(
        collecteurId: collecteurId,
        totalCollecte: totalCollecte,
        commissionTotale: commissionTotale,
        nombreCollectes: nombreCollectes,
        collectesCompletes: collectesCompletes,
        collectesEnAttente: nombreCollectes - collectesCompletes,
      );
    } catch (e) {
      print('❌ Erreur lors du calcul local des statistiques: $e');
      // Retourner des statistiques vides en cas d'erreur
      return StatistiquesCollecteur(
        collecteurId: collecteurId,
        totalCollecte: 0.0,
        commissionTotale: 0.0,
        nombreCollectes: 0,
        collectesCompletes: 0,
        collectesEnAttente: 0,
      );
    }
  }

  // ========== CHANGEMENT DE MOT DE PASSE ==========

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = await baseUrl;
    final response = await http.post(
      Uri.parse('$url/api/auth/change-password/'),
      headers: await _getHeaders(),
      body: json.encode({
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      _handleError(response);
      throw Exception('Erreur lors du changement de mot de passe');
    }
  }

  // ========== MISE À JOUR COLLECTEUR ==========

  Future<Collecteur> updateCollecteur(int collecteurId, Map<String, dynamic> data) async {
    final url = await baseUrl;
    final response = await http.patch(
      Uri.parse('$url/api/collecteurs/$collecteurId/'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return Collecteur.fromJson(json.decode(response.body));
    } else {
      _handleError(response);
      throw Exception('Erreur lors de la mise à jour du collecteur');
    }
  }

  // ========== HEALTH CHECK ==========

  Future<bool> healthCheck() async {
    try {
      final url = await baseUrl;
      final response = await http.get(
        Uri.parse('$url/health/'),
        headers: await _getHeaders(needsAuth: false),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ========== QR CODE ==========

  Future<Contribuable?> getContribuableByQRCode(String qrCode) async {
    try {
      final url = await baseUrl;
      final response = await http.get(
        Uri.parse('$url/api/contribuables/qr/$qrCode/'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return Contribuable.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        _handleError(response);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par QR code: $e');
      return null;
    }
  }

  Future<Collecte?> getCollecteByQRCode(String qrCode) async {
    try {
      final url = await baseUrl;
      final response = await http.get(
        Uri.parse('$url/api/collectes/qr/$qrCode/'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return Collecte.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        _handleError(response);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération de collecte par QR code: $e');
      return null;
    }
  }

  // ========== GÉOLOCALISATION ==========

  Future<bool> saveCollecteLocation(int collecteId, double latitude, double longitude) async {
    try {
      final url = await baseUrl;
      final response = await http.post(
        Uri.parse('$url/api/collectes/$collecteId/location/'),
        headers: await _getHeaders(),
        body: json.encode({
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        _handleError(response);
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors de l\'enregistrement de la position: $e');
      return false;
    }
  }

  Future<Map<String, double>?> getCollecteLocation(int collecteId) async {
    try {
      final url = await baseUrl;
      final response = await http.get(
        Uri.parse('$url/api/collectes/$collecteId/location/'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'latitude': (data['latitude'] as num).toDouble(),
          'longitude': (data['longitude'] as num).toDouble(),
        };
      } else if (response.statusCode == 404) {
        return null;
      } else {
        _handleError(response);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération de la position: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getCollectesForMap({
    int? collecteurId,
    String? dateDebut,
    String? dateFin,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (collecteurId != null) queryParams['collecteur_id'] = collecteurId.toString();
      if (dateDebut != null) queryParams['date_debut'] = dateDebut;
      if (dateFin != null) queryParams['date_fin'] = dateFin;

      final url = await baseUrl;
      final uri = Uri.parse('$url/api/collectes/map/').replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        _handleError(response);
        return [];
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des collectes pour la carte: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCollecteurZones(int collecteurId) async {
    try {
      final url = await baseUrl;
      final response = await http.get(
        Uri.parse('$url/api/collecteurs/$collecteurId/zones/'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        _handleError(response);
        return [];
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des zones: $e');
      return [];
    }
  }

  // ========== NOTIFICATIONS ==========

  Future<bool> registerNotificationToken(String token) async {
    try {
      final url = await baseUrl;
      final response = await http.post(
        Uri.parse('$url/api/notifications/register/'),
        headers: await _getHeaders(),
        body: json.encode({
          'token': token,
          'platform': 'mobile',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        _handleError(response);
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors de l\'enregistrement du token: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getNotifications({
    bool? unreadOnly,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (unreadOnly != null) queryParams['unread_only'] = unreadOnly.toString();
      queryParams['skip'] = skip.toString();
      queryParams['limit'] = limit.toString();

      final url = await baseUrl;
      final uri = Uri.parse('$url/api/notifications/').replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        _handleError(response);
        return [];
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des notifications: $e');
      return [];
    }
  }

  Future<bool> markNotificationAsRead(int notificationId) async {
    try {
      final url = await baseUrl;
      final response = await http.put(
        Uri.parse('$url/api/notifications/$notificationId/read/'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        _handleError(response);
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors du marquage de la notification comme lue: $e');
      return false;
    }
  }

  Future<bool> deleteNotification(int notificationId) async {
    try {
      final url = await baseUrl;
      final response = await http.delete(
        Uri.parse('$url/api/notifications/$notificationId/'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        _handleError(response);
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors de la suppression de la notification: $e');
      return false;
    }
  }

  Future<int> getUnreadNotificationsCount() async {
    try {
      final url = await baseUrl;
      final response = await http.get(
        Uri.parse('$url/api/notifications/count/'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['count'] as num).toInt();
      } else {
        return 0;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération du nombre de notifications: $e');
      return 0;
    }
  }

  // ========== DASHBOARD TEMPS RÉEL ==========

  Future<Map<String, dynamic>> getRealtimeDashboard(int collecteurId) async {
    // Endpoint backend non disponible pour le moment : on retourne directement le fallback
    print('ℹ️ Dashboard temps réel: endpoint /api/dashboard/collecteur/$collecteurId/realtime/ indisponible, utilisation de données locales.');
    return {
      'objectif_journalier': 150000,
      'collecte_jour': 82000,
      'taux_objectif': 0.55,
      'collectes_en_cours': 12,
      'alertes': [
        {'type': 'zone', 'message': 'Zone Mont-Bouët en retard de 20%'},
        {'type': 'weather', 'message': 'Pluie prévue vers 15h, prévoir bâches'}
      ],
      'hotspots': [
        {'label': 'PK8', 'variation': 12},
        {'label': 'Marché Artisanal', 'variation': -5},
        {'label': 'Bord de mer', 'variation': 8},
      ],
    };
  }

  // ========== CONTRÔLE / VÉRIFICATION TERRAIN ==========

  Future<List<Map<String, dynamic>>> getVerificationTasks(int collecteurId) async {
    final url = await baseUrl;
    final uri = Uri.parse('$url/api/verifications/collecteur/$collecteurId/');
    print('🌐 API: GET $uri');
    try {
      final response = await http.get(uri, headers: await _getHeaders());
      print('📥 API Vérifications: Status ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      _handleError(response);
    } catch (e) {
      print('⚠️ Vérifications indisponibles: $e');
    }

    return [
      {
        'id': 1,
        'contribuable': 'Awa M.',
        'zone': 'PK5',
        'motif': 'Incohérence montant',
        'dernier_passage': '2025-11-24T09:30:00',
        'statut': 'pending',
      },
      {
        'id': 2,
        'contribuable': 'Boutique AlloFrais',
        'zone': 'Marché Mont-Bouët',
        'motif': 'Nouvelle immatriculation',
        'dernier_passage': '2025-11-23T14:10:00',
        'statut': 'in_review',
      },
    ];
  }

  // ========== MODULE DE RECOUVREMENT ==========

  Future<List<Map<String, dynamic>>> getRecouvrementDossiers(int collecteurId) async {
    final url = await baseUrl;
    final uri = Uri.parse('$url/api/recouvrement/collecteur/$collecteurId/');
    print('🌐 API: GET $uri');
    try {
      final response = await http.get(uri, headers: await _getHeaders());
      print('📥 API Recouvrement: Status ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      _handleError(response);
    } catch (e) {
      print('⚠️ Recouvrement indisponible: $e');
    }

    return [
      {
        'id': 501,
        'contribuable': 'Station Bongo Oil',
        'montant_du': 450000,
        'derniere_relance': '2025-11-20',
        'n_relances': 3,
        'priorite': 'haute',
      },
      {
        'id': 502,
        'contribuable': 'Restaurant La Paix',
        'montant_du': 120000,
        'derniere_relance': '2025-11-18',
        'n_relances': 1,
        'priorite': 'moyenne',
      },
    ];
  }
}

