class Contribuable {
  final int id;
  final String nom;
  final String prenom;
  final String? telephone;
  final String? adresse;
  final bool? actif;
  final int? collecteurId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Contribuable({
    required this.id,
    required this.nom,
    required this.prenom,
    this.telephone,
    this.adresse,
    this.actif,
    this.collecteurId,
    this.createdAt,
    this.updatedAt,
  });

  factory Contribuable.fromJson(Map<String, dynamic> json) {
    return Contribuable(
      id: _parseInt(json['id']),
      nom: _parseString(json['nom'], defaultValue: 'Contribuable'),
      prenom: _parseString(json['prenom'], defaultValue: ''),
      telephone: _parseNullableString(json['telephone']),
      adresse: _parseNullableString(json['adresse']),
      // Si le backend renvoie null, on considère le contribuable comme actif par défaut
      actif: (json['actif'] as bool?) ?? true,
      collecteurId: _parseNullableInt(json['collecteur_id']),
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
      'prenom': prenom,
      'telephone': telephone,
      'adresse': adresse,
      'actif': actif,
      'collecteur_id': collecteurId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String get fullName => '$prenom $nom';

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

  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    return value.toString();
  }

  static String? _parseNullableString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }
}

