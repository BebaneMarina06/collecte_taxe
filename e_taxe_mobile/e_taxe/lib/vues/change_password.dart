import 'package:e_taxe/design/design.dart';
import 'package:e_taxe/apis/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final ApiService _apiService = ApiService();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _getPasswordStrength(String password) {
    if (password.isEmpty) return '';
    if (password.length < 6) return 'Faible';
    if (password.length < 8) return 'Moyen';
    if (!RegExp(r'[A-Z]').hasMatch(password) || 
        !RegExp(r'[a-z]').hasMatch(password) ||
        !RegExp(r'[0-9]').hasMatch(password)) {
      return 'Moyen';
    }
    return 'Fort';
  }

  Color _getPasswordStrengthColor(String strength) {
    switch (strength) {
      case 'Faible':
        return Colors.red;
      case 'Moyen':
        return Colors.orange;
      case 'Fort':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> _handleChangePassword() async {
    if (_oldPasswordController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez saisir votre mot de passe actuel',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_newPasswordController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez saisir un nouveau mot de passe',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_newPasswordController.text.length < 6) {
      Get.snackbar(
        'Erreur',
        'Le mot de passe doit contenir au moins 6 caractères',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      Get.snackbar(
        'Erreur',
        'Les mots de passe ne correspondent pas',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_oldPasswordController.text == _newPasswordController.text) {
      Get.snackbar(
        'Erreur',
        'Le nouveau mot de passe doit être différent de l\'ancien',
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
      // Appel API pour changer le mot de passe
      // Note: Vous devrez ajouter cette méthode dans ApiService
      final response = await _apiService.changePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (response) {
        Get.snackbar(
          'Succès',
          'Mot de passe modifié avec succès',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.back();
      } else {
        Get.snackbar(
          'Erreur',
          'Erreur lors de la modification du mot de passe',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
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
    final passwordStrength = _getPasswordStrength(_newPasswordController.text);

    return Scaffold(
      backgroundColor: Design.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Changer le mot de passe',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Design.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Pour votre sécurité, veuillez saisir votre mot de passe actuel et choisir un nouveau mot de passe.',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 30),

              // Ancien mot de passe
              _buildLabel('Mot de passe actuel'),
              const SizedBox(height: 10),
              _buildPasswordField(
                controller: _oldPasswordController,
                hintText: 'Saisissez votre mot de passe actuel',
                obscureText: _obscureOldPassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscureOldPassword = !_obscureOldPassword;
                  });
                },
                myWidth: myWidth,
              ),

              const SizedBox(height: 20),

              // Nouveau mot de passe
              _buildLabel('Nouveau mot de passe'),
              const SizedBox(height: 10),
              _buildPasswordField(
                controller: _newPasswordController,
                hintText: 'Saisissez votre nouveau mot de passe',
                obscureText: _obscureNewPassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
                myWidth: myWidth,
              ),
              
              // Indicateur de force du mot de passe
              if (_newPasswordController.text.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _getPasswordStrengthColor(passwordStrength),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Force: $passwordStrength',
                      style: TextStyle(
                        fontSize: 12,
                        color: _getPasswordStrengthColor(passwordStrength),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Le mot de passe doit contenir au moins 6 caractères',
                  style: TextStyle(
                    fontSize: 11,
                    color: Design.mediumGrey,
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Confirmation du mot de passe
              _buildLabel('Confirmer le nouveau mot de passe'),
              const SizedBox(height: 10),
              _buildPasswordField(
                controller: _confirmPasswordController,
                hintText: 'Confirmez votre nouveau mot de passe',
                obscureText: _obscureConfirmPassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
                myWidth: myWidth,
              ),

              // Vérification de correspondance
              if (_confirmPasswordController.text.isNotEmpty &&
                  _newPasswordController.text.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      _newPasswordController.text == _confirmPasswordController.text
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: _newPasswordController.text == _confirmPasswordController.text
                          ? Colors.green
                          : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _newPasswordController.text == _confirmPasswordController.text
                          ? 'Les mots de passe correspondent'
                          : 'Les mots de passe ne correspondent pas',
                      style: TextStyle(
                        fontSize: 12,
                        color: _newPasswordController.text == _confirmPasswordController.text
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 40),

              // Bouton de validation
              Container(
                width: myWidth / 1.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _isLoading ? Design.mediumGrey : Design.secondColor,
                ),
                child: TextButton(
                  onPressed: _isLoading ? null : _handleChangePassword,
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
                          'Changer le mot de passe',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required double myWidth,
  }) {
    return SizedBox(
      width: myWidth / 1.1,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onChanged: (value) {
          setState(() {}); // Pour mettre à jour l'UI
        },
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
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
              color: Design.mediumGrey,
            ),
            onPressed: onToggleVisibility,
          ),
        ),
      ),
    );
  }
}

