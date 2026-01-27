import 'contribuable.dart';
import 'taxe.dart';
import 'collecteur.dart';

class Collecte {
  final int id;
  final int contribuableId;
  final int taxeId;
  final int collecteurId;
  final double montant;
  final double commission;
  final String reference;
  final String typePaiement;
  final String statut;
  final DateTime dateCollecte;
  final String? billetage;
  final bool annule;
  final Contribuable? contribuable;
  final Taxe? taxe;
  final Collecteur? collecteur;

  Collecte({
    required this.id,
    required this.contribuableId,
    required this.taxeId,
    required this.collecteurId,
    required this.montant,
    required this.commission,
    required this.reference,
    required this.typePaiement,
    required this.statut,
    required this.dateCollecte,
    this.billetage,
    required this.annule,
    this.contribuable,
    this.taxe,
    this.collecteur,
  });

  factory Collecte.fromJson(Map<String, dynamic> json) {
    return Collecte(
      id: _parseInt(json['id']),
      contribuableId: _parseInt(json['contribuable_id']),
      taxeId: _parseInt(json['taxe_id']),
      collecteurId: _parseInt(json['collecteur_id']),
      montant: _parseDouble(json['montant']),
      commission: _parseDouble(json['commission']),
      reference: _parseString(
        json['reference'],
        defaultValue: 'REF-${json['id']}',
      ),
      typePaiement: _parseString(json['type_paiement']),
      statut: json['statut'] as String? ?? json['status'] as String? ?? 'pending',
      dateCollecte: DateTime.parse(json['date_collecte'] as String),
      billetage: json['billetage'] as String?,
      annule: json['annule'] as bool? ?? false,
      contribuable: json['contribuable'] != null
          ? Contribuable.fromJson(json['contribuable'] as Map<String, dynamic>)
          : null,
      taxe: json['taxe'] != null
          ? Taxe.fromJson(json['taxe'] as Map<String, dynamic>)
          : null,
      collecteur: json['collecteur'] != null
          ? Collecteur.fromJson(json['collecteur'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contribuable_id': contribuableId,
      'taxe_id': taxeId,
      'collecteur_id': collecteurId,
      'montant': montant,
      'commission': commission,
      'reference': reference,
      'type_paiement': typePaiement,
      'statut': statut,
      'date_collecte': dateCollecte.toIso8601String(),
      'billetage': billetage,
      'annule': annule,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'contribuable_id': contribuableId,
      'taxe_id': taxeId,
      'collecteur_id': collecteurId,
      'montant': montant,
      'type_paiement': typePaiement,
      if (billetage != null) 'billetage': billetage,
      'date_collecte': dateCollecte.toIso8601String(),
    };
  }

  bool get isCompleted => statut == 'completed';
  bool get isPending => statut == 'pending';
  bool get isCancelled => annule;

  // Helper method to parse double from string or num
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    if (value is num) return value.toInt();
    return 0;
  }

  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    return value.toString();
  }
}

