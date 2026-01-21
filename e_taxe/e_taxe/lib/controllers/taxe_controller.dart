import 'package:get/get.dart';
import '../apis/api_service.dart';
import '../models/taxe.dart';

class TaxeController extends GetxController {
  final ApiService _apiService = ApiService();
  
  final RxBool isLoading = false.obs;
  final RxList<Taxe> taxes = <Taxe>[].obs;
  final Rx<Taxe?> selectedTaxe = Rx<Taxe?>(null);
  final RxString errorMessage = ''.obs;

  // Charger les taxes actives
  Future<void> loadTaxes({bool? actif}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔵 TaxeController: Chargement des taxes (actif=$actif)');
      final taxesList = await _apiService.getTaxes(actif: actif);
      taxes.value = taxesList;
      
      print('✅ TaxeController: ${taxesList.length} taxes chargées');
      isLoading.value = false;
    } catch (e) {
      print('❌ TaxeController: Erreur lors du chargement: $e');
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      isLoading.value = false;
      // Réessayer sans filtre actif si erreur
      if (actif == true) {
        try {
          final allTaxes = await _apiService.getTaxes(actif: null);
          taxes.value = allTaxes.where((t) => t.actif).toList();
          isLoading.value = false;
        } catch (e2) {
          // Ignorer l'erreur de réessai
        }
      }
    }
  }

  // Charger une taxe spécifique
  Future<void> loadTaxe(int taxeId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Pour l'instant, on cherche dans la liste
      // Si besoin, on peut ajouter un endpoint GET /api/taxes/{id}
      final taxe = taxes.firstWhereOrNull((t) => t.id == taxeId);
      selectedTaxe.value = taxe;
      
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      isLoading.value = false;
    }
  }

  // Obtenir une taxe par ID
  Taxe? getTaxeById(int id) {
    try {
      return taxes.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  // Obtenir les taxes actives uniquement
  List<Taxe> getActiveTaxes() {
    return taxes.where((t) => t.actif).toList();
  }
}

