import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_taxe/vues/accueil_agent.dart';
import 'package:e_taxe/vues/clients.dart';
import 'package:e_taxe/vues/historique_collecte.dart';
import 'package:e_taxe/vues/caisses.dart';
import 'package:e_taxe/vues/profil.dart';

class AppScaffold extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const AppScaffold({super.key, required this.child, required this.currentIndex});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  void _onTap(int index) {
    // Redirige vers la bonne page selon l'index
    switch (index) {
      case 0:
        Get.offNamed('/AccueilAgent');
        break;
      case 1:
        Get.offNamed('/Clients');
        break;
      case 2:
        Get.offNamed('/HistoriqueCollecte');
        break;
      case 3:
        Get.toNamed('/Caisses');
        break;
      case 4:
        Get.toNamed('/Profil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.currentIndex.clamp(0, 4), // Limiter l'index à 0-4
        onTap: _onTap,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clients'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historique'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Caisses'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
