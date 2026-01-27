import 'package:e_taxe/design/design.dart';
import 'package:e_taxe/controllers/client_controller.dart';
import 'package:e_taxe/controllers/taxe_controller.dart';
import 'package:e_taxe/controllers/auth_controller.dart';
import 'package:e_taxe/models/taxe.dart';
import 'package:e_taxe/apis/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddClient extends StatefulWidget {
  const AddClient({super.key});

  @override
  State<AddClient> createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  final ClientController _clientController = Get.put(ClientController());
  final TaxeController _taxeController = Get.put(TaxeController());
  
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();
  
  Taxe? _selectedTaxe;
  String? _selectedTypePiece;
  String? _selectedNumPiece;

  @override
  void initState() {
    super.initState();
    // Différer le chargement après le build pour éviter l'erreur setState() during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTaxes();
    });
  }

  Future<void> _loadTaxes() async {
    await _taxeController.loadTaxes(actif: true);
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _adresseController.dispose();
    _emailController.dispose();
    _montantController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_nomController.text.isEmpty || 
        _prenomController.text.isEmpty || 
        _telephoneController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir les champs obligatoires (Nom, Prénom, Téléphone)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Récupérer le collecteur_id depuis l'auth controller
    final AuthController _authController = Get.find<AuthController>();
    final collecteurId = _authController.collecteurId;
    
    if (collecteurId == null) {
      Get.snackbar(
        'Erreur',
        'Collecteur non identifié. Veuillez vous reconnecter.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Récupérer les valeurs par défaut pour type_contribuable_id et quartier_id
    final defaultTypeContribuableId = await _getDefaultTypeContribuableId();
    final defaultQuartierId = await _getDefaultQuartierId(collecteurId);

    if (defaultTypeContribuableId == null || defaultQuartierId == null) {
      Get.snackbar(
        'Erreur',
        'Impossible de récupérer les données nécessaires. Veuillez réessayer.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final data = {
      'nom': _nomController.text.trim(),
      'prenom': _prenomController.text.trim(),
      'telephone': _telephoneController.text.trim(),
      'collecteur_id': collecteurId,
      'type_contribuable_id': defaultTypeContribuableId,
      'quartier_id': defaultQuartierId,
      if (_adresseController.text.isNotEmpty) 'adresse': _adresseController.text.trim(),
      if (_emailController.text.isNotEmpty) 'email': _emailController.text.trim(),
      if (_selectedTypePiece != null) 'numero_identification': _selectedNumPiece,
      'actif': true,
    };

    // Si une taxe est sélectionnée, l'ajouter
    if (_selectedTaxe != null) {
      data['taxes_ids'] = [_selectedTaxe!.id];
    }

    final success = await _clientController.createClient(data);

    if (success) {
      // Recharger la liste des clients avant de naviguer
      await _clientController.loadClients(
        collecteurId: collecteurId,
        actif: true,
        refresh: true,
      );
      // Afficher le message de succès
      Get.snackbar(
        'Succès',
        'Client créé avec succès',
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
        _clientController.errorMessage.value.isNotEmpty
            ? _clientController.errorMessage.value
            : 'Erreur lors de la création du client',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<int?> _getDefaultTypeContribuableId() async {
    try {
      final apiService = ApiService();
      final types = await apiService.getTypesContribuables(actif: true);
      if (types.isNotEmpty) {
        return types.first['id'] as int?;
      }
    } catch (e) {
      print('Erreur lors de la récupération des types contribuables: $e');
    }
    return null;
  }

  Future<int?> _getDefaultQuartierId(int collecteurId) async {
    try {
      final apiService = ApiService();
      final AuthController _authController = Get.find<AuthController>();
      final collecteur = _authController.currentCollecteur.value;
      
      // Si le collecteur a une zone, utiliser les quartiers de cette zone
      int? zoneId = collecteur?.zoneId;
      
      final quartiers = await apiService.getQuartiers(zoneId: zoneId, actif: true);
      if (quartiers.isNotEmpty) {
        return quartiers.first['id'] as int?;
      }
    } catch (e) {
      print('Erreur lors de la récupération des quartiers: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final myWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Design.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.offNamed('/Clients');
          },
        ),
        title: const Text(
          'Ajouter un Client',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Design.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Renseignez les informations du client pour l\'ajouter',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            
            // Nom
            _buildLabel('Nom du Client'),
            const SizedBox(height: 10),
            _buildTextField(_nomController, 'cliquez pour saisir', myWidth),
            
            const SizedBox(height: 20),
            // Prénom
            _buildLabel('Prénom', leftPadding: 20),
            const SizedBox(height: 10),
            _buildTextField(_prenomController, 'cliquez pour saisir', myWidth),
            
            const SizedBox(height: 20),
            // Téléphone
            _buildLabel('Numéro de téléphone', leftPadding: 20),
            const SizedBox(height: 10),
            _buildPhoneField(_telephoneController, myWidth),
            
            const SizedBox(height: 20),
            // Adresse
            _buildLabel('Adresse ou point de vente', leftPadding: 17),
            const SizedBox(height: 10),
            _buildTextField(_adresseController, 'cliquez pour saisir', myWidth, 
              suffixIcon: Icon(Icons.location_on)),
            
            const SizedBox(height: 20),
            // Email (optionnel)
            _buildLabel('Email (optionnel)', leftPadding: 25),
            const SizedBox(height: 10),
            _buildTextField(_emailController, 'cliquez pour saisir', myWidth, 
              keyboardType: TextInputType.emailAddress),
            
            const SizedBox(height: 20),
            // Type de taxe
            _buildLabel('Type de taxe', leftPadding: 25),
            const SizedBox(height: 5),
            _buildTaxeSelector(myWidth),
            
            const SizedBox(height: 20),
            // Montant (optionnel, pour référence)
            _buildLabel('Montant (optionnel)', leftPadding: 25),
            const SizedBox(height: 5),
            _buildAmountField(_montantController, myWidth),
            
            const SizedBox(height: 40),
            // Bouton Enregistrer
            Obx(() => Container(
              width: myWidth / 1.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _clientController.isLoading.value 
                    ? Design.mediumGrey 
                    : Design.secondColor,
              ),
              child: TextButton(
                onPressed: _clientController.isLoading.value ? null : _handleSubmit,
                child: _clientController.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Enregistrer',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {double leftPadding = 25}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: leftPadding),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 12, color: Colors.black),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText,
    double width, {
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return SizedBox(
      width: width / 1.1,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
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
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildPhoneField(TextEditingController controller, double width) {
    return SizedBox(
      width: width / 1.1,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.phone,
        cursorColor: Design.secondColor,
        decoration: InputDecoration(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/drapeau_gabon.png',
                width: 24,
                height: 16,
              ),
              const SizedBox(width: 8),
              const Text(
                '+241',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
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

  Widget _buildTaxeSelector(double width) {
    return GestureDetector(
      onTap: () {
        _showTaxeBottomSheet();
      },
      child: AbsorbPointer(
        child: SizedBox(
          width: width / 1.1,
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

  Widget _buildAmountField(TextEditingController controller, double width) {
    return SizedBox(
      width: width / 1.1,
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
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('Aucune taxe disponible'),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Choisissez le type de taxe qui convient à ce client',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._taxeController.taxes.map((taxe) => _buildTaxeCard(taxe)),
                  if (_taxeController.errorMessage.value.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Erreur: ${_taxeController.errorMessage.value}',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
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
}

