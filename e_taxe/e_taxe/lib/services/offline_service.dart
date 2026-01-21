import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class OfflineService {
  static Database? _database;
  static const String _dbName = 'e_taxe_offline.db';
  static const int _dbVersion = 1;
  
  // Vérifier si on est sur le web
  bool get isWeb => kIsWeb;

  // Table pour les collectes en attente de synchronisation
  static const String _tableCollectes = 'collectes_pending';
  static const String _tableContribuables = 'contribuables_pending';

  Future<Database?> get database async {
    // Désactiver le mode hors ligne sur le web
    if (isWeb) return null;
    
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Ne pas initialiser sur le web
    if (isWeb) {
      throw UnsupportedError('OfflineService n\'est pas supporté sur le web');
    }
    
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        // Table pour les collectes en attente
        await db.execute('''
          CREATE TABLE $_tableCollectes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            local_id TEXT UNIQUE,
            contribuable_id INTEGER,
            taxe_id INTEGER,
            collecteur_id INTEGER,
            montant REAL,
            type_paiement TEXT,
            billetage TEXT,
            date_collecte TEXT,
            data_json TEXT,
            synced INTEGER DEFAULT 0,
            created_at TEXT
          )
        ''');

        // Table pour les contribuables en attente
        await db.execute('''
          CREATE TABLE $_tableContribuables (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            local_id TEXT UNIQUE,
            nom TEXT,
            prenom TEXT,
            telephone TEXT,
            adresse TEXT,
            email TEXT,
            data_json TEXT,
            synced INTEGER DEFAULT 0,
            created_at TEXT
          )
        ''');
      },
    );
  }

  // Sauvegarder une collecte en local
  Future<String> saveCollecteOffline(Map<String, dynamic> data) async {
    if (isWeb) {
      throw UnsupportedError('Mode hors ligne non supporté sur le web');
    }
    
    final db = await database;
    if (db == null) {
      throw UnsupportedError('Base de données non disponible');
    }
    
    final localId = DateTime.now().millisecondsSinceEpoch.toString();
    
    await db.insert(
      _tableCollectes,
      {
        'local_id': localId,
        'contribuable_id': data['contribuable_id'],
        'taxe_id': data['taxe_id'],
        'collecteur_id': data['collecteur_id'],
        'montant': data['montant'],
        'type_paiement': data['type_paiement'],
        'billetage': data['billetage'] ?? '',
        'date_collecte': data['date_collecte'],
        'data_json': json.encode(data),
        'synced': 0,
        'created_at': DateTime.now().toIso8601String(),
      },
    );
    
    return localId;
  }

  // Sauvegarder un contribuable en local
  Future<String> saveContribuableOffline(Map<String, dynamic> data) async {
    if (isWeb) {
      throw UnsupportedError('Mode hors ligne non supporté sur le web');
    }
    
    final db = await database;
    if (db == null) {
      throw UnsupportedError('Base de données non disponible');
    }
    
    final localId = DateTime.now().millisecondsSinceEpoch.toString();
    
    await db.insert(
      _tableContribuables,
      {
        'local_id': localId,
        'nom': data['nom'],
        'prenom': data['prenom'],
        'telephone': data['telephone'] ?? '',
        'adresse': data['adresse'] ?? '',
        'email': data['email'] ?? '',
        'data_json': json.encode(data),
        'synced': 0,
        'created_at': DateTime.now().toIso8601String(),
      },
    );
    
    return localId;
  }

  // Récupérer les collectes non synchronisées
  Future<List<Map<String, dynamic>>> getPendingCollectes() async {
    if (isWeb) return [];
    
    final db = await database;
    if (db == null) return [];
    
    return await db.query(
      _tableCollectes,
      where: 'synced = ?',
      whereArgs: [0],
      orderBy: 'created_at DESC',
    );
  }

  // Récupérer les contribuables non synchronisés
  Future<List<Map<String, dynamic>>> getPendingContribuables() async {
    if (isWeb) return [];
    
    final db = await database;
    if (db == null) return [];
    
    return await db.query(
      _tableContribuables,
      where: 'synced = ?',
      whereArgs: [0],
      orderBy: 'created_at DESC',
    );
  }

  // Marquer une collecte comme synchronisée
  Future<void> markCollecteSynced(String localId) async {
    if (isWeb) return;
    
    final db = await database;
    if (db == null) return;
    
    await db.update(
      _tableCollectes,
      {'synced': 1},
      where: 'local_id = ?',
      whereArgs: [localId],
    );
  }

  // Marquer un contribuable comme synchronisé
  Future<void> markContribuableSynced(String localId) async {
    if (isWeb) return;
    
    final db = await database;
    if (db == null) return;
    
    await db.update(
      _tableContribuables,
      {'synced': 1},
      where: 'local_id = ?',
      whereArgs: [localId],
    );
  }

  // Supprimer les données synchronisées (nettoyage)
  Future<void> cleanSyncedData() async {
    if (isWeb) return;
    
    final db = await database;
    if (db == null) return;
    
    await db.delete(
      _tableCollectes,
      where: 'synced = ?',
      whereArgs: [1],
    );
    await db.delete(
      _tableContribuables,
      where: 'synced = ?',
      whereArgs: [1],
    );
  }

  // Compter les éléments en attente
  Future<int> getPendingCount() async {
    if (isWeb) return 0;
    
    final db = await database;
    if (db == null) return 0;
    
    final collectesCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $_tableCollectes WHERE synced = 0'),
    ) ?? 0;
    final contribuablesCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $_tableContribuables WHERE synced = 0'),
    ) ?? 0;
    return collectesCount + contribuablesCount;
  }

  // Fermer la base de données
  Future<void> close() async {
    if (isWeb) return;
    
    final db = await database;
    if (db != null) {
      await db.close();
    }
  }
}

