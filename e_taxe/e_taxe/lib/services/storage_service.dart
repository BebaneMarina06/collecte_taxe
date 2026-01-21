import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserNom = 'user_nom';
  static const String _keyUserPrenom = 'user_prenom';
  static const String _keyCollecteurId = 'collecteur_id';
  static const String _keyDeviceId = 'device_id';
  static const String _keyDeviceRegistered = 'device_registered';

  // Sauvegarder le token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  // Récupérer le token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // Supprimer le token
  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
  }

  // Sauvegarder les infos utilisateur
  static Future<void> saveUserInfo({
    required int userId,
    required String email,
    required String nom,
    required String prenom,
    int? collecteurId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, userId);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserNom, nom);
    await prefs.setString(_keyUserPrenom, prenom);
    if (collecteurId != null) {
      await prefs.setInt(_keyCollecteurId, collecteurId);
    }
  }

  // Récupérer l'ID du collecteur
  static Future<int?> getCollecteurId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCollecteurId);
  }

  // Récupérer l'ID utilisateur
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  // Récupérer l'email
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  // Récupérer le nom complet
  static Future<String?> getUserFullName() async {
    final prefs = await SharedPreferences.getInstance();
    final prenom = prefs.getString(_keyUserPrenom) ?? '';
    final nom = prefs.getString(_keyUserNom) ?? '';
    return '$prenom $nom'.trim();
  }

  // Vérifier si l'utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Sauvegarder l'ID de l'appareil
  static Future<void> saveDeviceId(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDeviceId, deviceId);
  }

  // Récupérer l'ID de l'appareil
  static Future<String?> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDeviceId);
  }

  // Sauvegarder le statut d'enregistrement de l'appareil
  static Future<void> saveDeviceRegistered(bool registered) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDeviceRegistered, registered);
  }

  // Vérifier si l'appareil est enregistré
  static Future<bool> isDeviceRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDeviceRegistered) ?? false;
  }

  // Déconnexion - supprimer toutes les données
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserNom);
    await prefs.remove(_keyUserPrenom);
    await prefs.remove(_keyCollecteurId);
    // Ne pas supprimer l'ID de l'appareil et le statut d'enregistrement
    // pour permettre la réutilisation lors de la prochaine connexion
  }
}

