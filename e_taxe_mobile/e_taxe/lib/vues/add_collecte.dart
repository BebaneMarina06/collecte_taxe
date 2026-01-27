import 'package:e_taxe/design/design.dart';
import 'package:e_taxe/utils/responsive_layout.dart';
import 'package:e_taxe/controllers/collecte_controller.dart';
import 'package:e_taxe/controllers/client_controller.dart';
import 'package:e_taxe/controllers/taxe_controller.dart';
import 'package:e_taxe/controllers/auth_controller.dart';
import 'package:e_taxe/models/contribuable.dart';
import 'package:e_taxe/models/taxe.dart';
import 'package:e_taxe/services/location_service.dart';
import 'package:e_taxe/vues/scanner_qr.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class AddCollecte extends StatefulWidget {
  const AddCollecte({super.key});

  @override
  State<AddCollecte> createState() => _AddCollecteState();
}

class _AddCollecteState extends State<AddCollecte> {
  final CollecteController _collecteController =
      Get.isRegistered<CollecteController>()
          ? Get.find<CollecteController>()
          : Get.put(CollecteController(), permanent: true);
  final ClientController _clientController =
      Get.isRegistered<ClientController>()
          ? Get.find<ClientController>()
          : Get.put(ClientController());
  final TaxeController _taxeController =
      Get.isRegistered<TaxeController>()
          ? Get.find<TaxeController>()
          : Get.put(TaxeController());
  final AuthController _authController = Get.find<AuthController>();
  
  final TextEditingController _montantController = TextEditingController();
  final TextEditingController _billetageController = TextEditingController();
  
  Contribuable? _selectedClient;
  Taxe? _selectedTaxe;
  String? _selectedTypePaiement;
  Position? _manualPosition;
  bool _isLocating = false;
  String? _locationMessage;

  @override
  void initState() {
    super.initState();
    // Différer le chargement après le build pour éviter l'erreur setState() during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _captureLocationAutomatically(); // Capture GPS automatique
    });
  }

  /// Capturer automatiquement la position GPS
  Future<void> _captureLocationAutomatically() async {
    try {
      setState(() {
        _isLocating = true;
        _locationMessage = 'Localisation en cours...';
      });
      
      final position = await LocationService.getCurrentPosition();
      if (position != null) {
        setState(() {
          _manualPosition = position;
          _locationMessage =
              'Position capturée: Lat ${position.latitude.toStringAsFixed(5)}, Lng ${position.longitude.toStringAsFixed(5)}';
        });
      } else {
        setState(() {
          _locationMessage = 'Impossible de récupérer la position automatiquement. Cliquez sur "Me localiser" pour réessayer.';
        });
      }
    } catch (e) {
      setState(() {
        _locationMessage = 'Erreur de localisation: $e';
      });
    } finally {
      setState(() {
        _isLocating = false;
      });
    }
  }

  Future<void> _loadData() async {
    final collecteurId = _authController.collecteurId;
    if (collecteurId != null) {
      await Future.wait([
        _clientController.loadClients(collecteurId: collecteurId),
        _taxeController.loadTaxes(actif: true),
      ]);
    } else {
      // Charger les taxes même si collecteurId est null
      await _taxeController.loadTaxes(actif: true);
    }
  }

  @override
  void dispose() {
    _montantController.dispose();
    _billetageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    // Vérifier si on peut créer une collecte (heure de clôture)
    if (!_authController.closingTimeService.canCreateCollecte()) {
      final timeRemaining = _authController.closingTimeService.getTimeRemaining();
      Get.snackbar(
        'Fermeture imminente',
        timeRemaining != null
            ? 'Impossible de créer une collecte. Fermeture dans $timeRemaining'
            : 'L\'heure de clôture est atteinte. Impossible de créer une collecte.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        icon: const Icon(Icons.access_time, color: Colors.white),
      );
      return;
    }

    if (_selectedClient == null) {
      Get.snackbar(
        'Erreur',
        'Veuillez sélectionner un client',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedTaxe == null) {
      Get.snackbar(
        'Erreur',
        'Veuillez sélectionner un type de taxe',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedTypePaiement == null) {
      Get.snackbar(
        'Erreur',
        'Veuillez sélectionner un moyen de paiement',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_montantController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez saisir le montant',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final montant = double.tryParse(_montantController.text);
    if (montant == null || montant <= 0) {
      Get.snackbar(
        'Erreur',
        'Montant invalide',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final collecteurId = _authController.collecteurId;
    if (collecteurId == null) {
      Get.snackbar(
        'Erreur',
        'Collecteur non identifié',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final data = {
      'contribuable_id': _selectedClient!.id,
      'taxe_id': _selectedTaxe!.id,
      'collecteur_id': collecteurId,
      'montant': montant,
      'type_paiement': _selectedTypePaiement!,
      if (_billetageController.text.isNotEmpty) 'billetage': _billetageController.text.trim(),
      'date_collecte': DateTime.now().toIso8601String(),
    };

    final metadata = {
      'contribuable_nom': _selectedClient!.nom,
      'contribuable_prenom': _selectedClient!.prenom,
      'contribuable_telephone': _selectedClient!.telephone,
      'contribuable_adresse': _selectedClient!.adresse,
    };

    final success = await _collecteController.createCollecte(
      data,
      localMetadata: metadata,
    );

    if (success) {
      // Enregistrer la position GPS si disponible (capture automatique)
      try {
        // Utiliser la position déjà capturée ou capturer maintenant
        final position = _manualPosition ?? await LocationService.getCurrentPosition();
        if (position != null) {
          // La collecte créée est maintenant en première position dans la liste
          if (_collecteController.collectes.isNotEmpty) {
            final newCollecte = _collecteController.collectes.first;
            // Les collectes créées ont toujours un ID (même temporaire)
            if (newCollecte.id > 0) {
              await LocationService.saveCollecteLocation(
                newCollecte.id,
                position,
              );
              print('✅ Position GPS enregistrée automatiquement pour la collecte ${newCollecte.id}');
            }
          }
        } else {
          print('⚠️ Aucune position GPS disponible pour cette collecte');
        }
      } catch (e) {
        print('⚠️ Erreur lors de l\'enregistrement de la position: $e');
        // Ne pas bloquer si la position ne peut pas être enregistrée
      }

      // Recharger la liste des collectes avant de naviguer
      await _collecteurReload(collecteurId);
      // Afficher le message de succès
      Get.snackbar(
        'Succès',
        'Collecte créée avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      // Attendre un peu pour que le snackbar soit visible avant de naviguer
      await Future.delayed(const Duration(milliseconds: 500));
      // Utiliser Get.back() pour revenir à la page précédente et déclencher le rechargement
      Get.back();
    } else {
      Get.snackbar(
        'Erreur',
        _collecteController.errorMessage.value.isNotEmpty
            ? _collecteController.errorMessage.value
            : 'Erreur lors de la création de la collecte',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> _collecteurReload(int collecteurId) async {
    await _collecteController.loadCollectes(
      collecteurId: collecteurId,
      refresh: true,
    );
  }

  Future<void> _locateMe() async {
    setState(() {
      _isLocating = true;
      _locationMessage = 'Localisation en cours...';
    });
    try {
      final position = await LocationService.getCurrentPosition();
      if (position != null) {
        setState(() {
          _manualPosition = position;
          _locationMessage =
              'Lat: ${position.latitude.toStringAsFixed(5)}, Lng: ${position.longitude.toStringAsFixed(5)}';
        });
      } else {
        setState(() {
          _locationMessage = 'Impossible de récupérer la position.';
        });
      }
    } catch (e) {
      setState(() {
        _locationMessage = 'Erreur de localisation: $e';
      });
    } finally {
      setState(() {
        _isLocating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = ResponsiveLayout.maxContentWidth(context);
    final padding = ResponsiveLayout.screenPadding(context);

    return Scaffold(
      backgroundColor: Design.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.offNamed('/HistoriqueCollecte'),
        ),
        title: const Text(
          'Ajouter une collecte',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Design.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'Renseignez les informations pour créer une collecte',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('Client'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildClientSelector(maxWidth)),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 48,
                        width: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Design.secondColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Get.to(
                              () => ScannerQR(
                                onContribuableScanned: (contribuable) {
                                  setState(() => _selectedClient = contribuable);
                                },
                              ),
                            );
                          },
                          child: const Icon(Icons.qr_code_scanner),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Type de taxe'),
                  const SizedBox(height: 8),
                  _buildTaxeSelector(maxWidth),
                  const SizedBox(height: 20),
                  _buildLabel('Moyen de paiement'),
                  const SizedBox(height: 8),
                  _buildPaiementSelector(maxWidth),
                  const SizedBox(height: 20),
                  _buildLabel('Montant'),
                  const SizedBox(height: 8),
                  _buildAmountField(_montantController, maxWidth),
                  const SizedBox(height: 20),
                  _buildLabel('Billetage (optionnel)'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    _billetageController,
                    'Ex: 1x5000, 2x2000',
                    maxWidth,
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Localisation'),
                  const SizedBox(height: 8),
                  _buildLocationCard(maxWidth),
                  const SizedBox(height: 32),
                  Obx(
                    () => SizedBox(
                      width: maxWidth,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: _collecteController.isLoading.value
                              ? Design.mediumGrey
                              : Design.secondColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _collecteController.isLoading.value
                            ? null
                            : _handleSubmit,
                        child: _collecteController.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Enregistrer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(double maxWidth) {
    return Container(
      width: maxWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Design.inputColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Design.secondColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _locationMessage ??
                      (_manualPosition != null
                          ? 'Position capturée'
                          : 'Aucune localisation enregistrée'),
                  style: TextStyle(
                    color: _manualPosition != null
                        ? Colors.green.shade700
                        : Design.mediumGrey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isLocating ? null : _locateMe,
              icon: Icon(
                _isLocating ? Icons.hourglass_top : Icons.my_location,
              ),
              label: Text(_isLocating ? 'Localisation...' : 'Me localiser'),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Votre position sera associée à la collecte pour la cartographie.',
            style: TextStyle(color: Design.mediumGrey, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.black54,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText,
    double maxWidth, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      width: maxWidth,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: Design.secondColor,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Design.mediumGrey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          filled: true,
          fillColor: Design.inputColor,
        ),
      ),
    );
  }

  Widget _buildAmountField(TextEditingController controller, double width) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        cursorColor: Design.secondColor,
        decoration: InputDecoration(
          hintText: 'cliquez pour saisir',
          hintStyle: TextStyle(color: Design.mediumGrey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          filled: true,
          fillColor: Design.inputColor,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'XAF',
                style: TextStyle(
                  color: Design.secondColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClientSelector(double width) {
    return GestureDetector(
      onTap: () {
        _showClientBottomSheet();
      },
      child: AbsorbPointer(
        child: SizedBox(
          width: width,
          child: TextField(
            controller: TextEditingController(
              text: _selectedClient?.fullName ?? 'Cliquez pour sélectionner',
            ),
            cursorColor: Design.secondColor,
            decoration: InputDecoration(
              hintText: 'Cliquez pour sélectionner',
              hintStyle: TextStyle(
                color: _selectedClient == null ? Design.mediumGrey : Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              filled: true,
              fillColor: Design.inputColor,
              suffixIcon: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaxeSelector(double width) {
    return GestureDetector(
      onTap: () {
        _showTaxeBottomSheet();
      },
      child: AbsorbPointer(
        child: SizedBox(
          width: width,
          child: TextField(
            controller: TextEditingController(
              text: _selectedTaxe?.nom ?? 'Cliquez pour sélectionner',
            ),
            cursorColor: Design.secondColor,
            decoration: InputDecoration(
              hintText: 'Cliquez pour sélectionner',
              hintStyle: TextStyle(
                color: _selectedTaxe == null ? Design.mediumGrey : Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              filled: true,
              fillColor: Design.inputColor,
              suffixIcon: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaiementSelector(double width) {
    return GestureDetector(
      onTap: () {
        _showPaiementBottomSheet();
      },
      child: AbsorbPointer(
        child: SizedBox(
          width: width,
          child: TextField(
            controller: TextEditingController(
              text: _getPaiementLabel(_selectedTypePaiement),
            ),
            cursorColor: Design.secondColor,
            decoration: InputDecoration(
              hintText: 'Cliquez pour sélectionner',
              hintStyle: TextStyle(
                color: _selectedTypePaiement == null ? Design.mediumGrey : Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              filled: true,
              fillColor: Design.inputColor,
              suffixIcon: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
      ),
    );
  }

  String _getPaiementLabel(String? type) {
    switch (type) {
      case 'cash':
        return 'Cash';
      case 'mobile_money':
        return 'Mobile Money';
      case 'bamboo':
        return 'Bamboo';
      case 'carte':
        return 'Visa/Mastercard';
      default:
        return 'Cliquez pour sélectionner';
    }
  }

  void _showClientBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Design.primaryColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            if (_clientController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_clientController.clients.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('Aucun client disponible'),
                ),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Sélectionnez un client',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _clientController.clients.length,
                    itemBuilder: (context, index) {
                      final client = _clientController.clients[index];
                      return _buildClientCard(client);
                    },
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Widget _buildClientCard(Contribuable client) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedClient = client;
        });
        Navigator.pop(context);
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Design.inputColor,
        margin: const EdgeInsets.only(bottom: 5),
        child: Container(
          height: 62,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      client.fullName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Design.secondColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      client.telephone ?? client.adresse ?? '',
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFFB6B6B6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (_selectedClient?.id == client.id)
                const Icon(Icons.check, color: Design.secondColor),
            ],
          ),
        ),
      ),
    );
  }

  void _showTaxeBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Design.primaryColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            if (_taxeController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_taxeController.taxes.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Aucune taxe disponible'),
                      if (_taxeController.errorMessage.value.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          'Erreur: ${_taxeController.errorMessage.value}',
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          _taxeController.loadTaxes(actif: true);
                        },
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Sélectionnez un type de taxe',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _taxeController.taxes.length,
                    itemBuilder: (context, index) {
                      final taxe = _taxeController.taxes[index];
                      return _buildTaxeCard(taxe);
                    },
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Widget _buildTaxeCard(Taxe taxe) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTaxe = taxe;
          // Si la taxe a un montant fixe, pré-remplir le montant
          if (!taxe.montantVariable && taxe.montant > 0) {
            _montantController.text = taxe.montant.toStringAsFixed(0);
          }
        });
        Navigator.pop(context);
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Design.inputColor,
        margin: const EdgeInsets.only(bottom: 5),
        child: Container(
          height: 62,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      taxe.nom,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Design.secondColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      taxe.description ?? '${taxe.montant} XAF - ${taxe.periodicite}',
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFFB6B6B6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (_selectedTaxe?.id == taxe.id)
                const Icon(Icons.check, color: Design.secondColor),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaiementBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Design.primaryColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'A partir de quel opérateur souhaitez-vous effectuer votre paiement ?',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 10),
                _buildPaiementOption('cash', 'Cash', 'Payer en cash', 'assets/cash.png'),
                const SizedBox(height: 5),
                _buildPaiementOption('bamboo', 'Bamboo', 'Payer via votre compte bancaire Bamboo', 'assets/logo_bamboo.png'),
                const SizedBox(height: 5),
                _buildPaiementOption('mobile_money', 'Mobile Money', 'Payer via votre Mobile Money', 'assets/logo_moov_money.png'),
                const SizedBox(height: 5),
                _buildPaiementOption('carte', 'Visa/Mastercard', 'Payer via Visa ou Mastercard', 'assets/logo_master_card.png'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaiementOption(String value, String title, String subtitle, String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTypePaiement = value;
        });
        Navigator.pop(context);
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Design.inputColor,
        child: Container(
          height: 62,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    imagePath,
                    width: 32,
                    height: 32,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Design.secondColor,
                          borderRadius: BorderRadius.circular(360),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Design.secondColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFFB6B6B6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (_selectedTypePaiement == value)
                const Icon(Icons.check, color: Design.secondColor),
            ],
          ),
        ),
      ),
    );
  }
}

