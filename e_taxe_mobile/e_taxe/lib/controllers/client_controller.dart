import 'package:get/get.dart';
import '../apis/api_service.dart';
import '../models/contribuable.dart';
import '../services/offline_service.dart';

class ClientController extends GetxController {
  final ApiService _apiService = ApiService();
  final OfflineService _offlineService = OfflineService();
  
  final RxBool isLoading = false.obs;
  final RxList<Contribuable> clients = <Contribuable>[].obs;
  final Rx<Contribuable?> selectedClient = Rx<Contribuable?>(null);
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  // Charger les clients d'un collecteur
  Future<void> loadClients({
    int? collecteurId,
    bool? actif,
    bool refresh = false,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final clientsList = await _apiService.getContribuables(
        collecteurId: collecteurId,
        actif: actif ?? true,
      );

      if (refresh) {
        clients.value = clientsList;
      } else {
        clients.value = clientsList;
      }
      
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      isLoading.value = false;
    }
  }

  // Charger un client spécifique
  Future<void> loadClient(int clientId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final client = await _apiService.getContribuable(clientId);
      selectedClient.value = client;
      
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      isLoading.value = false;
    }
  }

  // Créer un client (avec support hors ligne)
  Future<bool> createClient(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      try {
        // Tentative de création en ligne
        await _apiService.createContribuable(data);
        
        // Recharger la liste complète depuis le serveur pour avoir les données à jour
        final collecteurId = data['collecteur_id'] as int?;
        await loadClients(
          collecteurId: collecteurId,
          actif: true,
          refresh: true,
        );
        
        isLoading.value = false;
        return true;
      } catch (e) {
        // Extraire le message d'erreur du backend
        String errorMsg = e.toString().replaceAll('Exception: ', '');
        
        // Si c'est une erreur de validation (téléphone existant, etc.), ne pas sauvegarder en local
        if (errorMsg.contains('existe déjà') || errorMsg.contains('déjà')) {
          errorMessage.value = errorMsg;
          isLoading.value = false;
          return false;
        }
        
        // Si échec réseau, sauvegarder en local pour synchronisation ultérieure
        final localId = await _offlineService.saveContribuableOffline(data);
        errorMessage.value = 'Client sauvegardé en local (hors ligne). ID: $localId';
        
        // Créer un client temporaire pour l'affichage
        final tempClient = Contribuable(
          id: -int.parse(localId), // ID négatif pour identifier les clients locaux
          nom: data['nom'] as String,
          prenom: data['prenom'] as String,
          telephone: data['telephone'] as String?,
          adresse: data['adresse'] as String?,
          actif: true,
        );
        
        clients.insert(0, tempClient);
        
        isLoading.value = false;
        return true;
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      isLoading.value = false;
      return false;
    }
  }

  // Rechercher des clients
  List<Contribuable> getFilteredClients() {
    if (searchQuery.value.isEmpty) {
      return clients;
    }
    
    final query = searchQuery.value.toLowerCase();
    return clients.where((client) {
      return client.fullName.toLowerCase().contains(query) ||
          (client.telephone?.toLowerCase().contains(query) ?? false) ||
          (client.adresse?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  // Obtenir un client par ID
  Contribuable? getClientById(int id) {
    try {
      return clients.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}

