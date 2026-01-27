import 'package:e_taxe/design/design.dart';
import 'package:e_taxe/controllers/auth_controller.dart';
import 'package:e_taxe/apis/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilsInformations extends StatefulWidget {
  const ProfilsInformations({super.key});

  @override
  State<ProfilsInformations> createState() => _ProfilsInformationsState();
}

class _ProfilsInformationsState extends State<ProfilsInformations> {
  final AuthController _authController = Get.find<AuthController>();
  final ApiService _apiService = ApiService();
  
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _matriculeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCollecteurData();
  }

  void _loadCollecteurData() {
    final collecteur = _authController.currentCollecteur.value;
    if (collecteur != null) {
      _nomController.text = collecteur.nom;
      _prenomController.text = collecteur.prenom;
      _matriculeController.text = collecteur.matricule;
      _emailController.text = collecteur.email;
      _telephoneController.text = collecteur.telephone ?? '';
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _matriculeController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final collecteur = _authController.currentCollecteur.value;
    if (collecteur == null) {
      Get.snackbar(
        'Erreur',
        'Collecteur non identifié',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_nomController.text.isEmpty || _prenomController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir les champs obligatoires',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final data = {
        'nom': _nomController.text.trim(),
        'prenom': _prenomController.text.trim(),
        'email': _emailController.text.trim(),
        if (_telephoneController.text.isNotEmpty) 'telephone': _telephoneController.text.trim(),
      };

      final updatedCollecteur = await _apiService.updateCollecteur(collecteur.id, data);
      _authController.currentCollecteur.value = updatedCollecteur;

      Get.snackbar(
        'Succès',
        'Profil mis à jour avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      Get.offNamed('/Profil');
    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final myWidth = MediaQuery.of(context).size.width;
    final myHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Design.primaryColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.offNamed('AccueilAgent');
            },
          ),
        ),
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Design.primaryColor,
      ),
      body: Center(
        child: Column(
          children: [
            Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Avatar circulaire
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.purple[100], // fond violet clair
            backgroundImage: AssetImage('assets/avatar_profil.png'), // ton image ici
          ),
        
          // Bouton caméra
          Positioned(
            left: 60,
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Design.secondColor, // bleu foncé
                shape: BoxShape.circle,
                border: Border.all(color:Colors.white )
              ),
              padding: const EdgeInsets.all(6),
              child:  Center(
                child: IconButton(
                icon: const Icon(Icons.photo_camera, color: Colors.white, size: 20),
                padding: const EdgeInsets.only(right: 6.0,left: 1,top: 2),
                constraints: const BoxConstraints(),
                onPressed: () {
                  // Action à effectuer (ouvrir caméra ou galerie)
                },
                          ),
              ),
            ),
          ),
        ],
            ),
             Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Nom',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
            width: myWidth/1.1,
              child: TextField(
                controller: _nomController,
                cursorColor: Design.secondColor,
                decoration: InputDecoration(
                  hintText: 'Nom',
                  hintStyle: TextStyle(color: Design.mediumGrey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  filled: true,
                  fillColor: Design.inputColor,
                ),
              ),
            ),
                        SizedBox(height: 10),

             Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Prenom',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
            width: myWidth/1.1,
              child: TextField(
                controller: _prenomController,
                cursorColor: Design.secondColor,
                decoration: InputDecoration(
                  hintText: 'Prénom',
                  hintStyle: TextStyle(color: Design.mediumGrey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  filled: true,
                  fillColor: Design.inputColor,
                ),
              ),
            ),
                        SizedBox(height: 10),

             Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Matricule',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
            width: myWidth/1.1,
              child: TextField(
                controller: _matriculeController,
                enabled: false, // Le matricule ne peut pas être modifié
                cursorColor: Design.secondColor,
                decoration: InputDecoration(
                  hintText: 'Matricule',
                  hintStyle: TextStyle(color: Design.mediumGrey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  filled: true,
                  fillColor: Design.inputColor.withOpacity(0.5),
                ),
              ),
            ),
                        SizedBox(height: 10),

              Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Email',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
            width: myWidth/1.1,
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Design.secondColor,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Design.mediumGrey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  filled: true,
                  fillColor: Design.inputColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Téléphone
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Téléphone',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
            width: myWidth/1.1,
              child: TextField(
                controller: _telephoneController,
                keyboardType: TextInputType.phone,
                cursorColor: Design.secondColor,
                decoration: InputDecoration(
                  hintText: 'Téléphone',
                  hintStyle: TextStyle(color: Design.mediumGrey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  filled: true,
                  fillColor: Design.inputColor,
                ),
              ),
            ),
             SizedBox(height: myHeight/8),
            Container(
            width: myWidth/1.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _isLoading ? Design.mediumGrey : Design.secondColor,
              ),
              child: TextButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Envoyer la demande de modification',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}