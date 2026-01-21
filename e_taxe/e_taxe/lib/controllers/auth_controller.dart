import 'package:get/get.dart';
import '../apis/api_service.dart';
import '../services/storage_service.dart';
import '../services/closing_time_service.dart';
import '../services/device_service.dart';
import '../models/user.dart';
import '../models/collecteur.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  final ClosingTimeService _closingTimeService = ClosingTimeService();
  
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<Collecteur?> currentCollecteur = Rx<Collecteur?>(null);
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  // Vérifier si l'utilisateur est déjà connecté
  Future<void> checkAuthStatus() async {
    try {
      final loggedIn = await StorageService.isLoggedIn();
      isLoggedIn.value = loggedIn;
      
      if (loggedIn) {
        final collecteurId = await StorageService.getCollecteurId();
        if (collecteurId != null) {
          await loadCollecteurInfo(collecteurId);
        }
      }
    } catch (e) {
      print('Erreur lors de la vérification de l\'authentification: $e');
    }
  }

  // Connexion
  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Étape 1: Authentification
      final response = await _apiService.login(email, password);
      
      if (response['user'] == null) {
        errorMessage.value = 'Réponse invalide du serveur';
        isLoading.value = false;
        return false;
      }

      final userData = response['user'] as Map<String, dynamic>;
      currentUser.value = User.fromJson(userData);
      
      final userId = userData['id'] as int;
      final userEmail = userData['email'] as String;
      final userRole = userData['role'] as String? ?? '';
      
      // Si l'utilisateur est un collecteur, effectuer les vérifications
      if (userRole.toLowerCase() == 'collecteur') {
        try {
          // Récupérer le collecteur par email
          final collecteur = await _apiService.getCollecteurByEmail(userEmail);
          
          if (collecteur == null) {
            errorMessage.value = 'Collecteur non trouvé pour cet email';
            isLoading.value = false;
            return false;
          }

          // Étape 2: Vérifier l'heure de connexion (restriction horaire)
          final canLogin = await _apiService.canLoginAtTime(collecteur.id);
          if (!canLogin) {
            errorMessage.value = 'Connexion impossible. Vous êtes hors des heures autorisées.';
            isLoading.value = false;
            return false;
          }

          // Étape 3: Vérifier et enregistrer l'appareil
          final deviceId = await DeviceService.getDeviceId();
          if (deviceId != null) {
            // Vérifier si l'appareil est déjà autorisé
            final isAuthorized = await DeviceService.isDeviceAuthorized(collecteur.id);
            
            if (!isAuthorized) {
              // Enregistrer l'appareil (nécessite validation par l'admin)
              final registered = await DeviceService.registerDevice(collecteur.id);
              if (!registered) {
                errorMessage.value = 'Échec de l\'enregistrement de l\'appareil. Veuillez contacter l\'administrateur.';
                isLoading.value = false;
                return false;
              }
              
              // Vérifier à nouveau après enregistrement
              final stillNotAuthorized = !await DeviceService.isDeviceAuthorized(collecteur.id);
              if (stillNotAuthorized) {
                errorMessage.value = 'Appareil en attente de validation par l\'administrateur.';
                isLoading.value = false;
                return false;
              }
            }
          }

          currentCollecteur.value = collecteur;
          
          // Sauvegarder l'ID du collecteur
          await StorageService.saveUserInfo(
            userId: userId,
            email: userEmail,
            nom: userData['nom'] as String,
            prenom: userData['prenom'] as String,
            collecteurId: collecteur.id,
          );
          
          // Marquer le collecteur comme connecté
          await _apiService.connecterCollecteur(collecteur.id);
          
          // Démarrer la vérification de l'heure de clôture
          _closingTimeService.startChecking();
        } catch (e) {
          print('Erreur lors du chargement du collecteur: $e');
          errorMessage.value = e.toString().replaceAll('Exception: ', '');
          isLoading.value = false;
          return false;
        }
      }
      
      isLoggedIn.value = true;
      isLoading.value = false;
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      isLoading.value = false;
      return false;
    }
  }

  // Charger les infos du collecteur
  Future<void> loadCollecteurInfo(int collecteurId) async {
    try {
      final collecteur = await _apiService.getCollecteur(collecteurId);
      currentCollecteur.value = collecteur;
    } catch (e) {
      print('Erreur lors du chargement du collecteur: $e');
    }
  }

  // Déconnexion
  Future<void> logout() async {
    try {
      isLoading.value = true;
      
      // Déconnecter le collecteur si connecté
      if (currentCollecteur.value != null) {
        try {
          await _apiService.deconnecterCollecteur(currentCollecteur.value!.id);
        } catch (e) {
          print('Erreur lors de la déconnexion du collecteur: $e');
        }
      }
      
      // Arrêter la vérification de l'heure de clôture
      _closingTimeService.stopChecking();
      _closingTimeService.reset();
      
      // Supprimer les données locales
      await StorageService.logout();
      
      // Réinitialiser l'état
      currentUser.value = null;
      currentCollecteur.value = null;
      isLoggedIn.value = false;
      errorMessage.value = '';
      
      isLoading.value = false;
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
      isLoading.value = false;
    }
  }

  // Obtenir l'ID du collecteur actuel
  int? get collecteurId => currentCollecteur.value?.id;
  
  // Obtenir le nom complet du collecteur
  String get collecteurFullName {
    if (currentCollecteur.value != null) {
      return currentCollecteur.value!.fullName;
    }
    return '';
  }

  // Obtenir le service de clôture
  ClosingTimeService get closingTimeService => _closingTimeService;
}

