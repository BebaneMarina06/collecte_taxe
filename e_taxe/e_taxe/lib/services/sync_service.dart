import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:e_taxe/apis/api_service.dart';
import 'package:e_taxe/services/offline_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SyncService {
  final ApiService _apiService = ApiService();
  final OfflineService _offlineService = OfflineService();
  final Connectivity _connectivity = Connectivity();

  // Vérifier la connexion
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // Synchroniser les collectes en attente
  Future<void> syncPendingCollectes() async {
    if (!await isConnected()) {
      return;
    }

    try {
      final pendingCollectes = await _offlineService.getPendingCollectes();

      for (final pending in pendingCollectes) {
        try {
          final data = json.decode(pending['data_json'] as String) as Map<String, dynamic>;
          await _apiService.createCollecte(data);
          await _offlineService.markCollecteSynced(pending['local_id'] as String);
        } catch (e) {
          // Continuer avec les autres même en cas d'erreur
          print('Erreur lors de la synchronisation de la collecte ${pending['local_id']}: $e');
        }
      }
    } catch (e) {
      print('Erreur lors de la synchronisation des collectes: $e');
    }
  }

  // Synchroniser les contribuables en attente
  Future<void> syncPendingContribuables() async {
    if (!await isConnected()) {
      return;
    }

    try {
      final pendingContribuables = await _offlineService.getPendingContribuables();

      for (final pending in pendingContribuables) {
        try {
          final data = json.decode(pending['data_json'] as String) as Map<String, dynamic>;
          await _apiService.createContribuable(data);
          await _offlineService.markContribuableSynced(pending['local_id'] as String);
        } catch (e) {
          // Continuer avec les autres même en cas d'erreur
          print('Erreur lors de la synchronisation du contribuable ${pending['local_id']}: $e');
        }
      }
    } catch (e) {
      print('Erreur lors de la synchronisation des contribuables: $e');
    }
  }

  // Synchronisation complète
  Future<void> syncAll() async {
    if (!await isConnected()) {
      Get.snackbar(
        'Hors ligne',
        'Aucune connexion internet. Synchronisation impossible.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await Future.wait([
        syncPendingCollectes(),
        syncPendingContribuables(),
      ]);

      final pendingCount = await _offlineService.getPendingCount();
      if (pendingCount == 0) {
        Get.snackbar(
          'Succès',
          'Toutes les données ont été synchronisées',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Information',
          '$pendingCount élément(s) en attente de synchronisation',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de la synchronisation: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Obtenir le nombre d'éléments en attente
  Future<int> getPendingCount() async {
    return await _offlineService.getPendingCount();
  }
}

