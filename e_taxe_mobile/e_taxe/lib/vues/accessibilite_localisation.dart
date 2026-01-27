import 'package:e_taxe/design/design.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccessibiliteLocalisation extends StatefulWidget {
  const AccessibiliteLocalisation({super.key});

  @override
  State<AccessibiliteLocalisation> createState() => _AccessibiliteLocalisationState();
}

class _AccessibiliteLocalisationState extends State<AccessibiliteLocalisation> {
  bool modeSombre = false;
  bool animationsAutorisees = true;
  bool sonsConfirmation = true;
  double taillePolice = 16;
  String contraste = 'Standard';
  String langueSelectionnee = 'fr';

  final List<String> contrastesDisponibles = ['Standard', 'Élevé', 'Sépia'];
  final List<Map<String, String>> languesDisponibles = const [
    {'code': 'fr', 'label': 'Français'},
    {'code': 'en', 'label': 'English'},
    {'code': 'pt', 'label': 'Português'},
    {'code': 'es', 'label': 'Español'},
  ];

  void _enregistrerPreferences() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Préférences enregistrées (mode démo)'),
        backgroundColor: Design.secondColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.primaryColor,
      appBar: AppBar(
        title: const Text('Accessibilité & Langues'),
        centerTitle: true,
        backgroundColor: Design.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Accessibilité',
              children: [
                SwitchListTile(
                  value: modeSombre,
                  activeColor: Design.secondColor,
                  title: const Text('Activer le mode sombre'),
                  subtitle: const Text('Réduit la luminosité pour un meilleur confort visuel'),
                  onChanged: (value) => setState(() => modeSombre = value),
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Taille de police'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Slider(
                        min: 12,
                        max: 22,
                        divisions: 5,
                        activeColor: Design.secondColor,
                        value: taillePolice,
                        label: '${taillePolice.toStringAsFixed(0)} px',
                        onChanged: (value) => setState(() => taillePolice = value),
                      ),
                      Text('Taille actuelle : ${taillePolice.toStringAsFixed(0)} px'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: contraste,
                  decoration: InputDecoration(
                    labelText: 'Contraste',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  items: contrastesDisponibles
                      .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  onChanged: (value) => setState(() => contraste = value ?? contraste),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  value: animationsAutorisees,
                  activeColor: Design.secondColor,
                  title: const Text('Animer les transitions'),
                  subtitle: const Text('Désactivez pour économiser la batterie'),
                  onChanged: (value) => setState(() => animationsAutorisees = value),
                ),
                SwitchListTile(
                  value: sonsConfirmation,
                  activeColor: Design.secondColor,
                  title: const Text('Sons de confirmation'),
                  subtitle: const Text('Émettre un son après chaque action importante'),
                  onChanged: (value) => setState(() => sonsConfirmation = value),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Langues disponibles',
              children: [
                const Text(
                  'Choisissez la langue à utiliser dans l’application. Les traductions sont chargées automatiquement depuis l’API.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: languesDisponibles.map((langue) {
                    final selected = langueSelectionnee == langue['code'];
                    return ChoiceChip(
                      label: Text(langue['label']!),
                      selected: selected,
                      selectedColor: Design.secondColor,
                      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
                      onSelected: (_) => setState(() => langueSelectionnee = langue['code']!),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Design.secondColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _enregistrerPreferences,
                icon: const Icon(Icons.save),
                label: const Text('Enregistrer mes réglages'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

