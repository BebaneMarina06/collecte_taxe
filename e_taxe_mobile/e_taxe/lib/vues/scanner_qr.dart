import 'package:e_taxe/design/design.dart';
import 'package:e_taxe/services/qr_service.dart';
import 'package:e_taxe/models/contribuable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerQR extends StatefulWidget {
  final Function(Contribuable)? onContribuableScanned;
  final bool isReceiptScan;

  const ScannerQR({
    super.key,
    this.onContribuableScanned,
    this.isReceiptScan = false,
  });

  @override
  State<ScannerQR> createState() => _ScannerQRState();
}

class _ScannerQRState extends State<ScannerQR> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isScanning = true;
  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleScan(String qrCode) async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
      _isScanning = false;
    });

    try {
      if (widget.isReceiptScan) {
        // Vérifier un reçu
        final receiptData = await QRService.verifyReceiptQR(qrCode);
        if (receiptData != null) {
          Get.back();
          Get.snackbar(
            'Reçu trouvé',
            'Référence: ${receiptData['reference']}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Naviguer vers les détails de la collecte
          if (receiptData['id'] != null) {
            Get.toNamed('/DetailsCollecte', arguments: receiptData['id']);
          }
        } else {
          Get.snackbar(
            'Reçu non trouvé',
            'Aucun reçu correspondant à ce QR code',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          setState(() {
            _isProcessing = false;
            _isScanning = true;
          });
        }
      } else {
        // Scanner un contribuable
        final contribuable = await QRService.scanContribuableQR(qrCode);
        if (contribuable != null) {
          Get.back();
          if (widget.onContribuableScanned != null) {
            widget.onContribuableScanned!(contribuable);
          }
          Get.snackbar(
            'Contribuable trouvé',
            '${contribuable.fullName}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Contribuable non trouvé',
            'Aucun contribuable correspondant à ce QR code',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          setState(() {
            _isProcessing = false;
            _isScanning = true;
          });
        }
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors du scan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      setState(() {
        _isProcessing = false;
        _isScanning = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.isReceiptScan ? 'Scanner un reçu' : 'Scanner un QR code',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Scanner
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null && _isScanning) {
                  _handleScan(barcode.rawValue!);
                  break;
                }
              }
            },
          ),
          
          // Overlay avec guide de scan
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Design.secondColor,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  // Coins
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Design.secondColor, width: 4),
                          left: BorderSide(color: Design.secondColor, width: 4),
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Design.secondColor, width: 4),
                          right: BorderSide(color: Design.secondColor, width: 4),
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Design.secondColor, width: 4),
                          left: BorderSide(color: Design.secondColor, width: 4),
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Design.secondColor, width: 4),
                          right: BorderSide(color: Design.secondColor, width: 4),
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.isReceiptScan
                      ? 'Pointez la caméra vers le QR code du reçu'
                      : 'Pointez la caméra vers le QR code du contribuable',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // Indicateur de traitement
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

