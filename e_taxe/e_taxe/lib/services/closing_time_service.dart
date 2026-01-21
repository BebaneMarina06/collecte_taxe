import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_taxe/controllers/auth_controller.dart';
import 'package:e_taxe/apis/api_service.dart';

class ClosingTimeService {
  Timer? _checkTimer;
  final ApiService _apiService = ApiService();
  
  AuthController? get _authController {
    try {
      return Get.find<AuthController>();
    } catch (e) {
      return null;
    }
  }
  
  bool _isClosed = false;
  bool _warningShown = false;
  DateTime? _closingTime;

  // Démarrer la vérification de l'heure de clôture
  void startChecking() {
    // Vérifier immédiatement
    _checkClosingTime();
    
    // Vérifier toutes les minutes
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkClosingTime();
    });
  }

  // Arrêter la vérification
  void stopChecking() {
    _checkTimer?.cancel();
    _checkTimer = null;
  }

  // Vérifier si l'heure de clôture est atteinte
  void _checkClosingTime() {
    final authController = _authController;
    if (authController == null) return;
    
    // Récupérer l'heure de fermeture du collecteur
    final collecteur = authController.currentCollecteur.value;
    final heureCloture = collecteur?.heureCloture ?? '18:00'; // Par défaut 18h si non défini

    final now = DateTime.now();
    final closingTime = _parseClosingTime(heureCloture, now);
    
    if (closingTime == null) {
      return;
    }

    _closingTime = closingTime;
    final difference = closingTime.difference(now);
    final minutesUntilClose = difference.inMinutes;

    // Si l'heure de clôture est passée
    if (difference.isNegative || difference.inMinutes == 0) {
      if (!_isClosed) {
        _handleClosing();
      }
    }
    // Avertissement 15 minutes avant
    else if (minutesUntilClose <= 15 && minutesUntilClose > 0 && !_warningShown) {
      _showWarning(minutesUntilClose);
      _warningShown = true;
    }
    // Avertissement 5 minutes avant
    else if (minutesUntilClose <= 5 && minutesUntilClose > 0) {
      _showCriticalWarning(minutesUntilClose);
    }
  }

  // Parser l'heure de clôture (format HH:mm)
  DateTime? _parseClosingTime(String heureCloture, DateTime referenceDate) {
    try {
      final parts = heureCloture.split(':');
      if (parts.length != 2) return null;
      
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return null;
      }

      return DateTime(
        referenceDate.year,
        referenceDate.month,
        referenceDate.day,
        hour,
        minute,
      );
    } catch (e) {
      return null;
    }
  }

  // Afficher un avertissement 15 minutes avant
  void _showWarning(int minutes) {
    Get.snackbar(
      'Avertissement',
      'L\'application se fermera dans $minutes minute${minutes > 1 ? 's' : ''}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
      icon: const Icon(Icons.warning, color: Colors.white),
    );
  }

  // Afficher un avertissement critique 5 minutes avant
  void _showCriticalWarning(int minutes) {
    Get.snackbar(
      'ATTENTION',
      'Fermeture dans $minutes minute${minutes > 1 ? 's' : ''} !',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 10),
      icon: const Icon(Icons.error, color: Colors.white),
      isDismissible: false,
    );
  }

  // Gérer la fermeture
  Future<void> _handleClosing() async {
    _isClosed = true;
    stopChecking();

    // Déconnecter le collecteur
    final authController = _authController;
    if (authController != null) {
      final collecteurId = authController.collecteurId;
      if (collecteurId != null) {
        try {
          await _apiService.deconnecterCollecteur(collecteurId);
        } catch (e) {
          // Ignorer les erreurs de déconnexion
        }
      }
    }

    // Afficher un dialogue de fermeture
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Empêcher la fermeture
        child: AlertDialog(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.access_time, color: Colors.red),
              const SizedBox(width: 10),
              Flexible(
                child: Text('Heure de clôture atteinte'),
              ),
            ],
          ),
          content: const Text(
            'L\'heure de clôture est atteinte. L\'application va se fermer.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final authController = _authController;
                if (authController != null) {
                  await authController.logout();
                  Get.until((route) => route.isFirst);
                }
              },
              child: const Text('Déconnexion'),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    // Attendre 3 secondes puis déconnecter automatiquement
    await Future.delayed(const Duration(seconds: 3));
    final authCtrl = _authController;
    if (authCtrl != null) {
      await authCtrl.logout();
      Get.until((route) => route.isFirst);
    }
  }

  // Vérifier si l'application est fermée
  bool get isClosed => _isClosed;

  // Vérifier si on peut créer une collecte (avant l'heure de clôture)
  // Modification: Permet l'utilisation 24h/24, pas de restriction
  bool canCreateCollecte() {
    // Toujours permettre la création de collecte (24h/24)
    return true;
  }

  // Obtenir le temps restant avant la fermeture
  String? getTimeRemaining() {
    if (_closingTime == null) return null;
    
    final now = DateTime.now();
    final difference = _closingTime!.difference(now);
    
    if (difference.isNegative) return null;
    
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}min';
    } else {
      return '${minutes}min';
    }
  }

  // Réinitialiser (pour les tests ou après déconnexion)
  void reset() {
    _isClosed = false;
    _warningShown = false;
    _closingTime = null;
    stopChecking();
  }
}

