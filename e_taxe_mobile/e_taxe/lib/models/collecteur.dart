class Collecteur {
  final int id;
  final String nom;
  final String prenom;
  final String matricule;
  final String email;
  final String? telephone;
  final String statut;
  final String etat;
  final bool actif;
  final int? zoneId;
  final String? heureCloture; // Format HH:mm
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Collecteur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.matricule,
    required this.email,
    this.telephone,
    required this.statut,
    required this.etat,
    required this.actif,
    this.zoneId,
    this.heureCloture,
    this.createdAt,
    this.updatedAt,
  });

  factory Collecteur.fromJson(Map<String, dynamic> json) {
    return Collecteur(
      id: _parseInt(json['id']),
      nom: _parseString(json['nom'], defaultValue: 'Collecteur'),
      prenom: _parseString(json['prenom'], defaultValue: ''),
      matricule: _parseString(json['matricule'], defaultValue: 'N/A'),
      email: _parseString(json['email']),
      telephone: _parseNullableString(json['telephone']),
      statut: _parseString(json['statut'], defaultValue: 'inactive'),
      etat: _parseString(json['etat'], defaultValue: 'offline'),
      // Certains anciens enregistrements peuvent avoir actif = null côté API
      // On considère par défaut qu'un collecteur est actif (= true)
      actif: json['actif'] as bool? ?? true,
      zoneId: _parseNullableInt(json['zone_id']),
      heureCloture: _parseNullableString(json['heure_cloture']),
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
      'matricule': matricule,
      'email': email,
      'telephone': telephone,
      'statut': statut,
      'etat': etat,
      'actif': actif,
      'zone_id': zoneId,
      'heure_cloture': heureCloture,
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

