class Taxe {
  final int id;
  final String nom;
  final String code;
  final String? description;
  final double montant;
  final bool montantVariable;
  final String periodicite;
  final double commissionPourcentage;
  final bool actif;
  final int? typeTaxeId;
  final int? serviceId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Taxe({
    required this.id,
    required this.nom,
    required this.code,
    this.description,
    required this.montant,
    required this.montantVariable,
    required this.periodicite,
    required this.commissionPourcentage,
    required this.actif,
    this.typeTaxeId,
    this.serviceId,
    this.createdAt,
    this.updatedAt,
  });

  factory Taxe.fromJson(Map<String, dynamic> json) {
    return Taxe(
      id: _parseInt(json['id']),
      nom: json['nom'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      montant: _parseDouble(json['montant']),
      montantVariable: json['montant_variable'] as bool? ?? false,
      periodicite: json['periodicite'] as String,
      commissionPourcentage: _parseDouble(json['commission_pourcentage'] ?? 0),
      // Certains enregistrements peuvent avoir actif = null, on considère actif par défaut
      actif: json['actif'] as bool? ?? true,
      typeTaxeId: _parseNullableInt(json['type_taxe_id']),
      serviceId: _parseNullableInt(json['service_id']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'code': code,
      'description': description,
      'montant': montant,
      'montant_variable': montantVariable,
      'periodicite': periodicite,
      'commission_pourcentage': commissionPourcentage,
      'actif': actif,
      'type_taxe_id': typeTaxeId,
      'service_id': serviceId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

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
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static int? _parseNullableInt(dynamic value) {
    if (value == null) return null;
    return _parseInt(value);
  }
}

