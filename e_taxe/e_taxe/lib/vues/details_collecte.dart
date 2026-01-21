import 'package:e_taxe/design/design.dart';
import 'package:e_taxe/controllers/collecte_controller.dart';
import 'package:e_taxe/services/receipt_service.dart';
import 'package:e_taxe/services/qr_service.dart';
import 'package:e_taxe/vues/scanner_qr.dart';
import 'package:e_taxe/models/collecte.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DetailsCollecte extends StatefulWidget {
  const DetailsCollecte({super.key});

  @override
  State<DetailsCollecte> createState() => _DetailsCollecteState();
}

class _DetailsCollecteState extends State<DetailsCollecte> {
  final CollecteController _collecteController = Get.put(CollecteController());
  int? _collecteId;
  
  @override
  void initState() {
    super.initState();
    // Récupérer l'ID de la collecte depuis les arguments
    _collecteId = Get.arguments as int?;
    
    // Si une collecte est déjà sélectionnée dans le controller, on l'utilise
    // Sinon, on charge la collecte par son ID
    if (_collecteController.selectedCollecte.value == null && _collecteId != null) {
      _collecteController.loadCollecte(_collecteId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.primaryColor,
      appBar: AppBar(
        backgroundColor: Design.primaryColor,
        centerTitle: true,
        title: const Text(
          'Details de la collecte',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.offNamed('/HistoriqueCollecte');
          },
        ),
      
      ),
      body: Obx(() {
        if (_collecteController.isLoading.value && _collecteController.selectedCollecte.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final collecte = _collecteController.selectedCollecte.value;
        
        if (collecte == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Collecte non trouvée',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.offNamed('/HistoriqueCollecte'),
                  child: const Text('Retour à l\'historique'),
                ),
              ],
            ),
          );
        }

        final dateFormat = DateFormat('dd/MM/yyyy à HH:mm', 'fr');
        final numberFormat = NumberFormat.currency(symbol: '', decimalDigits: 0);

        final isLocalCollecte = collecte.id <= 0 || collecte.reference.startsWith('LOCAL-');

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Row(
                  children: [
                    Text(
                      '+ ${numberFormat.format(collecte.montant)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Design.secondColor,
                        borderRadius: BorderRadius.circular(360),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(360),
                        child: Image.asset(
                          'assets/cash.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Text(
                      dateFormat.format(collecte.dateCollecte),
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 10,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (collecte.contribuable != null) ...[
                          infoRow("Nom", collecte.contribuable!.nom),
                          infoRow("Prénom", collecte.contribuable!.prenom),
                          if (collecte.contribuable!.telephone != null)
                            infoRow("Numéro de téléphone", collecte.contribuable!.telephone!),
                          if (collecte.contribuable!.adresse != null)
                            infoRow("Adresse", collecte.contribuable!.adresse!),
                        ],
                        infoRow("Moyen de paiement", collecte.typePaiement),
                        infoRow("Montant", "${numberFormat.format(collecte.montant)} XAF"),
                        if (collecte.taxe != null)
                          infoRow("Type de taxe", collecte.taxe!.nom),
                        infoRow("Date", dateFormat.format(collecte.dateCollecte)),
                        infoRow(
                          "Statut",
                          isLocalCollecte ? 'En attente de synchronisation' : collecte.statut,
                        ),
                        if (collecte.reference.isNotEmpty)
                          infoRow("Référence", collecte.reference),
                        if (collecte.commission > 0)
                          infoRow("Commission", "${numberFormat.format(collecte.commission)} XAF"),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Boutons d'action selon le statut
              if (collecte.statut == 'pending' && !collecte.annule) ...[
                // Boutons Valider et Annuler pour les collectes en attente
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Obx(() {
                          final isBusy = _collecteController.isLoading.value;
                          final canValidate = !isLocalCollecte && !isBusy;
                          return Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: canValidate ? Colors.green : Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: canValidate ? () => _handleValidate(collecte.id) : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isBusy
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.white, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Valider',
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                            ),
                          );
                        }),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Obx(() {
                          final isBusy = _collecteController.isLoading.value;
                          final canCancel = !isLocalCollecte && !isBusy;
                          return Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: canCancel ? Colors.red : Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: canCancel ? () => _handleCancel(collecte.id) : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isBusy
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cancel, color: Colors.white, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Annuler',
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (isLocalCollecte)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Collecte sauvegardée hors ligne. Patientez jusqu\'à la synchronisation pour la valider ou l\'annuler.',
                      style: TextStyle(
                        color: Design.mediumGrey,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],

              // QR Code du reçu
              if (collecte.statut == 'completed') ...[
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'QR Code du reçu',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        QrImageView(
                          data: QRService.generateReceiptQRCode(
                            collecte.id ?? 0,
                            collecte.reference,
                          ),
                          version: QrVersions.auto,
                          size: 150,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          collecte.reference,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // Boutons d'impression et partage
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Design.secondColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () => _handlePrint(collecte),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.print, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Imprimer',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () => _handleShare(collecte),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.share, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Partager',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Bouton scanner reçu
              if (collecte.statut == 'completed') ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const ScannerQR(isReceiptScan: true));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code_scanner, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Scanner un reçu',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  /// Widget réutilisable pour les lignes d'information
  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 13,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePrint(Collecte collecte) async {
    try {
      await ReceiptService.generateAndPrintReceipt(collecte);
      Get.snackbar(
        'Succès',
        'Reçu prêt à être imprimé',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de l\'impression: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> _handleShare(Collecte collecte) async {
    try {
      await ReceiptService.generateAndShareReceipt(collecte);
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors du partage: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> _handleValidate(int collecteId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Valider la collecte'),
        content: const Text('Êtes-vous sûr de vouloir valider cette collecte ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Valider'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _collecteController.validerCollecte(collecteId);
      if (success) {
        Get.snackbar(
          'Succès',
          'Collecte validée avec succès',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Recharger la collecte pour mettre à jour l'affichage
        if (_collecteId != null) {
          await _collecteController.loadCollecte(_collecteId!);
        }
      } else {
        Get.snackbar(
          'Erreur',
          _collecteController.errorMessage.value.isNotEmpty
              ? _collecteController.errorMessage.value
              : 'Erreur lors de la validation',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    }
  }

  Future<void> _handleCancel(int collecteId) async {
    final reasonController = TextEditingController();
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Annuler la collecte'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Veuillez indiquer la raison de l\'annulation :'),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Raison de l\'annulation',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Fermer'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Annuler la collecte'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _collecteController.annulerCollecte(
        collecteId,
        raison: reasonController.text.isNotEmpty ? reasonController.text : null,
      );
      if (success) {
        Get.snackbar(
          'Succès',
          'Collecte annulée avec succès',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        // Recharger la collecte pour mettre à jour l'affichage
        if (_collecteId != null) {
          await _collecteController.loadCollecte(_collecteId!);
        }
      } else {
        Get.snackbar(
          'Erreur',
          _collecteController.errorMessage.value.isNotEmpty
              ? _collecteController.errorMessage.value
              : 'Erreur lors de l\'annulation',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    }
  }
}
