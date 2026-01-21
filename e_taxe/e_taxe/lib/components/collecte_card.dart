import 'package:e_taxe/design/design.dart';
import 'package:e_taxe/models/collecte.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CollecteCard extends StatelessWidget {
  final Collecte collecte;
  final VoidCallback? onTap;

  const CollecteCard({
    super.key,
    required this.collecte,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final myWidth = MediaQuery.of(context).size.width;
    final dateFormat = DateFormat('dd/MM/yyyy à HH:mm', 'fr');
    
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Design.inputColor,
        child: Container(
          height: 62,
          width: myWidth / 1.1,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      collecte.contribuable?.fullName ?? 'Contribuable inconnu',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          dateFormat.format(collecte.dateCollecte),
                          style: TextStyle(
                            fontSize: 12,
                            color: Design.mediumGrey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${NumberFormat.currency(symbol: '', decimalDigits: 0).format(collecte.montant)} XAF',
                          style: TextStyle(
                            fontSize: 12,
                            color: Design.mediumGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

