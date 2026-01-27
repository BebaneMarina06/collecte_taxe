class StatistiquesCollecteur {
  final int? collecteurId;
  final double totalCollecte;
  final int nombreCollectes;
  final int collectesCompletes;
  final int collectesEnAttente;
  final double commissionTotale;

  StatistiquesCollecteur({
    this.collecteurId,
    required this.totalCollecte,
    required this.nombreCollectes,
    required this.collectesCompletes,
    required this.collectesEnAttente,
    required this.commissionTotale,
  });

  factory StatistiquesCollecteur.fromJson(Map<String, dynamic> json) {
    return StatistiquesCollecteur(
      collecteurId: json['collecteur_id'] as int?,
      totalCollecte: _parseDouble(json['total_collecte'] ?? 0),
      nombreCollectes: json['nombre_collectes'] as int? ?? 0,
      collectesCompletes: json['collectes_completes'] as int? ?? 0,
      collectesEnAttente: json['collectes_en_attente'] as int? ?? 0,
      commissionTotale: _parseDouble(json['commission_totale'] ?? 0),
    );
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
}

