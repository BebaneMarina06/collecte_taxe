// import 'package:e_taxe/design/design.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:e_taxe/vues/accueil_agent.dart';
// import 'package:e_taxe/vues/clients.dart';
// import 'package:e_taxe/vues/historique_collecte.dart';
// import 'package:e_taxe/vues/caisses.dart';

// class MainNavigation extends StatefulWidget {
//   const MainNavigation({super.key});

//   @override
//   State<MainNavigation> createState() => _MainNavigationState();
// }

// class _MainNavigationState extends State<MainNavigation> {
//   int _currentIndex = 0;

//   final List<Widget> _pages = const [
//     AccueilAgent(),
//     Clients(),
//     HistoriqueCollecte(),
//     Caisses(),
//   ];

//   void _onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onTabTapped,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Design.secondColor,
//         unselectedItemColor: Design.mediumGrey,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Accueil',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people),
//             label: 'Clients',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.history),
//             label: 'Historique',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_balance_wallet),
//             label: 'Caisses',
//           ),
//         ],
//       ),
//     );
//   }
// }
