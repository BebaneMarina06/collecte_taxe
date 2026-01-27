import 'package:e_taxe/design/design.dart';
import 'package:e_taxe/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnexionAgents extends StatefulWidget {
  const ConnexionAgents({super.key});

  @override
  State<ConnexionAgents> createState() => _ConnexionAgentsState();
}

class _ConnexionAgentsState extends State<ConnexionAgents> {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir tous les champs',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final success = await _authController.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success) {
      Get.offNamed('/AccueilAgent');
      Get.snackbar(
        'Succès',
        'Connexion réussie',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Erreur',
        _authController.errorMessage.value.isNotEmpty
            ? _authController.errorMessage.value
            : 'Échec de la connexion',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final myWidth = MediaQuery.of(context).size.width;
    final myHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Design.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ok
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Get.offNamed('/ActualiteAgent');
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.black, size: 24),
                  tooltip: "Retour",
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Image.asset(
                'assets/logo_mairie.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Se connecter",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: myWidth / 15,
                  fontWeight: FontWeight.bold,
                  color: Design.secondColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: const Text(
                "Renseigner les informations correspondantes pour vous connecter.",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: const Text(
                'E-mail',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: myWidth / 1.1,
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
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
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: const Text(
                'mot de passe',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: myWidth / 1.1,
              child: TextField(
                controller: _passwordController,
                cursorColor: Design.secondColor,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'cliquez pour saisir',
                  hintStyle: TextStyle(color: Design.mediumGrey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Design.mediumGrey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: myHeight / 10),
            Obx(() => Container(
              width: myWidth / 1.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Design.secondColor,
              ),
              child: TextButton(
                onPressed: _authController.isLoading.value ? null : _handleLogin,
                child: _authController.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Se connecter',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            )),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Mot de passe oublié ? ',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  TextSpan(
                    text: 'Contactez votre administrateur',
                    style: TextStyle(
                      color: Design.secondColor,
                      fontSize: myWidth / 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
