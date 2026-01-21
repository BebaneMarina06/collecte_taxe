import 'package:e_taxe/design/design.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChoixLangue extends StatefulWidget {
  const ChoixLangue({super.key});

  @override
  State<ChoixLangue> createState() => _ChoixLangueState();
}

class _ChoixLangueState extends State<ChoixLangue> {
    String _selectedLang = 'fr';

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
          'Choix de la langue',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Design.primaryColor,
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
           Text(
                  'Choisissez une langue pour votre application',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                          SizedBox(height: 20,),

             _buildLanguageOption('fr', 'Français'),
            _buildLanguageOption('en', 'Anglais'),
            _buildLanguageOption('system', 'Langue du système'),
              SizedBox(height: myHeight/2.8),
            Container(
            width: myWidth/1.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Design.secondColor,
              ),
              child: TextButton(
                onPressed: () {
                },
                child: Text(
                  'Enregistrer',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
        ],
      ),
    );
  }
    // Widget pour chaque option
  Widget _buildLanguageOption(String value, String label) {
    final myWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
            width: myWidth/1.1,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: RadioListTile<String>(
            value: value,
            groupValue: _selectedLang,
            onChanged: (val) {
              setState(() {
                _selectedLang = val!;
              });
            },
            title: Text(label),
            activeColor: Design.secondColor, // bleu foncé
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}