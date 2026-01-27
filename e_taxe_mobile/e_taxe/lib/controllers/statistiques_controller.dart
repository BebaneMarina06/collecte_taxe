import 'package:get/get.dart';
import '../apis/api_service.dart';
import '../models/statistiques.dart';

class StatistiquesController extends GetxController {
  final ApiService _apiService = ApiService();
  
  final RxBool isLoading = false.obs;
  final Rx<StatistiquesCollecteur?> statistiques = Rx<StatistiquesCollecteur?>(null);
  final RxString errorMessage = ''.obs;

  // Charger les statistiques d'un collecteur
  Future<void> loadStatistiques(int collecteurId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔵 StatistiquesController: Chargement des statistiques pour collecteurId=$collecteurId');
      final stats = await _apiService.getStatistiquesCollecteur(collecteurId);
      statistiques.value = stats;
      
      print('✅ StatistiquesController: Statistiques chargées: totalCollecte=${stats.totalCollecte}, nombreCollectes=${stats.nombreCollectes}');
      isLoading.value = false;
    } catch (e) {
      print('❌ StatistiquesController: Erreur lors du chargement: $e');
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      isLoading.value = false;
    }
  }

  // Rafraîchir les statistiques
  Future<void> refreshStatistiques(int collecteurId) async {
    await loadStatistiques(collecteurId);
  }
}

