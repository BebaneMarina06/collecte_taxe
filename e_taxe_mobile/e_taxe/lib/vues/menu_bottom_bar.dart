import 'package:flutter/material.dart';
import 'package:e_taxe/design/design.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        elevation: 10,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.currentIndex,
        onTap: widget.onTap,
        selectedItemColor: Design.primaryColor,
        unselectedItemColor: Design.mediumGrey,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.normal,
          height: 1.5,
        ),
        items: [
          _buildItem(Icons.home, 'Accueil', 0),
          _buildItem(Icons.people, 'Clients', 1), // Icône modifiée
          _buildItem(Icons.history, 'Historique', 2),
          _buildItem(Icons.account_balance_wallet, 'Caisse', 3), // Icône modifiée
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: widget.currentIndex == index
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 26),
                const SizedBox(height: 2),
                Container(
                  height: 3,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Design.primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
              ],
            )
          : Icon(icon, size: 24),
      label: label,
    );
  }
}