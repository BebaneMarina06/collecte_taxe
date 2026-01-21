import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import '../apis/api_service.dart';
import '../models/collecte.dart';
import '../models/contribuable.dart';
import '../services/offline_service.dart';

class CollecteController extends GetxController {
  final ApiService _apiService = ApiService();
  final OfflineService _offlineService = OfflineService();
  
  final RxBool isLoading = false.obs;
  final RxList<Collecte> collectes = <Collecte>[].obs;
  final Rx<Collecte?> selectedCollecte = Rx<Collecte?>(null);
  final RxString errorMessage = ''.obs;
  final RxInt totalCollectes = 0.obs;

  // Pagination
  final RxInt currentPage = 0.obs;
  final int itemsPerPage = 20;
  final RxBool hasMore = true.obs;

  // Charger les collectes d'un collecteur
  Future<void> loadCollectes({
    int? collecteurId,
    String? statut,
    String? dateDebut,
    String? dateFin,
    bool refresh = false,
  }) async {
    try {
      if (refresh) {
        currentPage.value = 0;
        collectes.clear();
        hasMore.value = true;
      }

      if (!hasMore.value && !refresh) return;

      isLoading.value = true;
      errorMessage.value = '';

      print('🔵 CollecteController: Chargement des collectes pour collecteurId=$collecteurId');
      final skip = currentPage.value * itemsPerPage;
      final newCollectes = await _apiService.getCollectes(
        collecteurId: collecteurId,
        statut: statut,
        dateDebut: dateDebut,
        dateFin: dateFin,
        skip: skip,
        limit: itemsPerPage,
      );

      if (refresh) {
        collectes.value = newCollectes;
      } else {
        collectes.addAll(newCollectes);
      }

      hasMore.value = newCollectes.length == itemsPerPage;
      currentPage.value++;
      totalCollectes.value = collectes.length;
      
      print('✅ CollecteController: ${newCollectes.length} collectes chargées');
      isLoading.value = false;
      await _loadPendingCollectes();
    } catch (e) {
      print('❌ CollecteController: Erreur lors du chargement: $e');
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      isLoading.value = false;
    }
  }

  // Charger une collecte spécifique
  Future<void> loadCollecte(int collecteId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final collecte = await _apiService.getCollecte(collecteId);
      selectedCollecte.value = collecte;
      
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      isLoading.value = false;
    }
  }

  // Créer une collecte (avec support hors ligne)
  Future<bool> createCollecte(
    Map<String, dynamic> data, {
    Map<String, dynamic>? localMetadata,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      String? localId;
      Collecte? tempCollecte;

      try {
        final offlinePayload = Map<String, dynamic>.from(data);
        if (localMetadata != null) {
          offlinePayload.addAll(localMetadata);
        }

        localId = DateTime.now().millisecondsSinceEpoch.toString();
        if (!kIsWeb) {
          localId = await _offlineService.saveCollecteOffline(offlinePayload);
        }
        tempCollecte = _buildTempCollecte(localId, offlinePayload);
        collectes.insert(0, tempCollecte);
        totalCollectes.value = collectes.length;
      } catch (offlineError) {
        print('⚠️ Impossible d\'enregistrer la collecte localement: $offlineError');
      }

      final apiPayload = Map<String, dynamic>.from(data);
      final newCollecte = await _apiService.createCollecte(apiPayload);
      _replaceTempCollecte(tempCollecte, newCollecte);
      if (localId != null && !kIsWeb) {
        await _offlineService.markCollecteSynced(localId);
      }

      // Recharger la liste complète depuis le serveur pour avoir les données à jour
      final collecteurId = data['collecteur_id'] as int?;
      if (collecteurId != null) {
        await loadCollectes(
          collecteurId: collecteurId,
          refresh: true,
        );
      }

      isLoading.value = false;
      return true;
    } catch (e) {
      // Extraire le message d'erreur du backend
      String errorMsg = e.toString().replaceAll('Exception: ', '');
      
      // Si c'est une erreur de validation, ne pas sauvegarder en local
      if (errorMsg.contains('non trouv') || 
          errorMsg.contains('invalide') || 
          errorMsg.contains('requis') ||
          errorMsg.contains('obligatoire')) {
        errorMessage.value = errorMsg;
        isLoading.value = false;
        return false;
      }
      
      // Si erreur réseau ou autre, sauvegarder en local
      if (kIsWeb) {
        errorMessage.value = errorMsg;
        isLoading.value = false;
        return false;
      }

      errorMessage.value =
          'Collecte enregistrée hors ligne. Elle sera synchronisée automatiquement.';
      isLoading.value = false;
      return true;
    }
  }

  // Valider une collecte
  Future<bool> validerCollecte(int collecteId) async {
    try {
      if (collecteId <= 0) {
        errorMessage.value =
            'Cette collecte est en attente de synchronisation. Veuillez réessayer une fois la connexion rétablie.';
        return false;
      }

      isLoading.value = true;
      errorMessage.value = '';
      
      final updatedCollecte = await _apiService.validerCollecte(collecteId);
      
      // Mettre à jour la collecte dans la liste
      final index = collectes.indexWhere((c) => c.id == collecteId);
      if (index != -1) {
        collectes[index] = updatedCollecte;
      }
      
      if (selectedCollecte.value?.id == collecteId) {
        selectedCollecte.value = updatedCollecte;
      }
      
      isLoading.value = false;
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      isLoading.value = false;
      return false;
    }
  }

  // Annuler une collecte
  Future<bool> annulerCollecte(int collecteId, {String? raison}) async {
    try {
      if (collecteId <= 0) {
        errorMessage.value =
            'Cette collecte est en attente de synchronisation. Vous pourrez l\'annuler une fois qu\'elle sera envoyée au serveur.';
        return false;
      }

      isLoading.value = true;
      errorMessage.value = '';
      
      final updatedCollecte = await _apiService.annulerCollecte(collecteId, raison: raison);
      
      // Mettre à jour la collecte dans la liste
      final index = collectes.indexWhere((c) => c.id == collecteId);
      if (index != -1) {
        collectes[index] = updatedCollecte;
      }
      
      if (selectedCollecte.value?.id == collecteId) {
        selectedCollecte.value = updatedCollecte;
      }
      
      isLoading.value = false;
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      isLoading.value = false;
      return false;
    }
  }

  // Filtrer les collectes par statut
  List<Collecte> getCollectesByStatut(String statut) {
    return collectes.where((c) => c.statut == statut).toList();
  }

  // Obtenir les collectes récentes (dernières 10)
  List<Collecte> getRecentCollectes({int limit = 10}) {
    final sorted = List<Collecte>.from(collectes);
    sorted.sort((a, b) => b.dateCollecte.compareTo(a.dateCollecte));
    return sorted.take(limit).toList();
  }

  // Calculer le total des collectes
  double getTotalMontant() {
    return collectes
        .where((c) => c.isCompleted)
        .fold(0.0, (sum, c) => sum + c.montant);
  }

  // Calculer le total des commissions
  double getTotalCommission() {
    return collectes
        .where((c) => c.isCompleted)
        .fold(0.0, (sum, c) => sum + c.commission);
  }

  Future<void> _loadPendingCollectes() async {
    if (kIsWeb) return;
    try {
      final pending = await _offlineService.getPendingCollectes();
      for (final row in pending) {
        final localId = row['local_id'] as String?;
        if (localId == null) continue;
        final localTempId = -(int.tryParse(localId) ?? 0);
        final alreadyExists = collectes.any(
          (c) => c.reference == 'LOCAL-$localId' || (localTempId != 0 && c.id == localTempId),
        );
        if (alreadyExists) continue;

        Map<String, dynamic> data;
        if (row['data_json'] != null) {
          data = json.decode(row['data_json'] as String) as Map<String, dynamic>;
        } else {
          data = {
            'contribuable_id': row['contribuable_id'],
            'taxe_id': row['taxe_id'],
            'collecteur_id': row['collecteur_id'],
            'montant': row['montant'],
            'type_paiement': row['type_paiement'],
            'billetage': row['billetage'],
            'date_collecte': row['date_collecte'],
          };
        }

        final tempCollecte = _buildTempCollecte(localId, data);
        collectes.insert(0, tempCollecte);
      }
      totalCollectes.value = collectes.length;
    } catch (e) {
      print('⚠️ Impossible de charger les collectes locales: $e');
    }
  }

  Collecte _buildTempCollecte(String? localId, Map<String, dynamic> data) {
    final generatedId = localId ?? DateTime.now().millisecondsSinceEpoch.toString();
    final parsedId = int.tryParse(generatedId);
    final tempId = parsedId != null ? -parsedId : -DateTime.now().microsecondsSinceEpoch;
    final dateString = data['date_collecte'] as String? ?? DateTime.now().toIso8601String();
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(dateString);
    } catch (_) {
      parsedDate = DateTime.now();
    }

    final montantValue = data['montant'];
    double montant = 0.0;
    if (montantValue is num) {
      montant = montantValue.toDouble();
    } else if (montantValue != null) {
      montant = double.tryParse(montantValue.toString()) ?? 0.0;
    }

    Contribuable? tempContribuable;
    if (data.containsKey('contribuable_id')) {
      final contribuableId = data['contribuable_id'];
      if (contribuableId is int || contribuableId is String) {
        tempContribuable = Contribuable(
          id: contribuableId is int
              ? contribuableId
              : int.tryParse(contribuableId.toString()) ?? 0,
          nom: (data['contribuable_nom'] as String?) ?? 'Contribuable',
          prenom: (data['contribuable_prenom'] as String?) ?? '',
          telephone: data['contribuable_telephone'] as String?,
          adresse: data['contribuable_adresse'] as String?,
          actif: null,
          collecteurId: data['collecteur_id'] as int?,
          createdAt: null,
          updatedAt: null,
        );
      }
    }

    return Collecte(
      id: tempId,
      contribuableId: data['contribuable_id'] as int,
      taxeId: data['taxe_id'] as int,
      collecteurId: data['collecteur_id'] as int,
      montant: montant,
      commission: 0.0,
      reference: 'LOCAL-$generatedId',
      typePaiement: (data['type_paiement'] as String?) ?? '',
      statut: 'pending',
      dateCollecte: parsedDate,
      billetage: data['billetage'] as String?,
      annule: false,
      contribuable: tempContribuable,
    );
  }

  void _replaceTempCollecte(Collecte? tempCollecte, Collecte newCollecte) {
    if (tempCollecte == null) {
      collectes.insert(0, newCollecte);
      totalCollectes.value = collectes.length;
      return;
    }

    final index = collectes.indexWhere((c) => c.id == tempCollecte.id);
    if (index != -1) {
      collectes[index] = newCollecte;
    } else {
      collectes.insert(0, newCollecte);
    }
    totalCollectes.value = collectes.length;
  }
}

