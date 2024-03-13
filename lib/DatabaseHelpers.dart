import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'your_database_name.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Créer la table solde
        await db.execute('''
          CREATE TABLE solde (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            montant REAL
          )
        ''');

        // Créer la table transactions
        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            montant REAL,
            date TEXT,
            statut INTEGER,
            solde_id INTEGER,
            FOREIGN KEY (solde_id) REFERENCES solde (id)
          )
        ''');

        // Créer la table solde_historique
        await db.execute('''
          CREATE TABLE solde_historique (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            montant REAL,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<void> makeTransaction(double montant, int statut) async {
    final db = await database;

    // Récupérer le solde actuel
    final solde = await getSolde();

    // Vérifier si le solde existe
    if (solde['id'] == -1) {
      // Aucun solde enregistré, créer le premier solde
      await db.insert('solde', {'montant': montant});
    } else {
      // Mettre à jour le solde actuel
      final nouveauSolde = statut == 0 ? solde['montant'] + montant : solde['montant'] - montant;
      await db.update('solde', {'montant': nouveauSolde});
    }

    // Enregistrer la transaction
    await db.insert('transactions', {
      'montant': montant,
      'date': DateTime.now().toIso8601String(),
      'statut': statut,
      'solde_id': solde['id'],
    });

    // Enregistrer le solde dans l'historique
    await db.insert('solde_historique', {
      'montant': solde['montant'],
      'date': DateTime.now().toIso8601String(),
    });
  }


  Future<Map<String, dynamic>> getSolde() async {
    final db = await database;
    final result = await db.query('solde');
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {'id': -1, 'montant': 0.0};
    }
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;
    return db.query('transactions', orderBy: 'date DESC');
  }

  Future<List<Map<String, dynamic>>> getSoldeHistorique() async {
    final db = await database;
    return db.query('solde_historique', orderBy: 'date DESC');
  }

  // Fonction pour récupérer la somme des montants des transactions du jour
  Future<double> getSommeTransactionsDuJour() async {
    final db = await database;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    final result = await db.rawQuery('SELECT SUM(montant) FROM transactions WHERE date >= ? AND date < ?', [startOfDay.toIso8601String(), endOfDay.toIso8601String()]);

    return (result.first['SUM(montant)'] ?? 0.0) as double;
  }

// Fonction pour récupérer la somme des montants des transactions du mois
  Future<double> getSommeTransactionsDuMois() async {
    final db = await database;
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));

    final result = await db.rawQuery('SELECT SUM(montant) FROM transactions WHERE date >= ? AND date <= ?', [startOfMonth.toIso8601String(), endOfMonth.toIso8601String()]);

    return (result.first['SUM(montant)'] ?? 0.0) as double;
  }

  // Fonction pour récupérer la somme totale des montants des transactions du mois
  Future<double> getTotalSommeTransactionsDuMois() async {
    final db = await database;
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));

    final result = await db.rawQuery('SELECT SUM(montant) FROM transactions WHERE date >= ? AND date <= ?', [startOfMonth.toIso8601String(), endOfMonth.toIso8601String()]);

    return (result.first['SUM(montant)'] ?? 0.0) as double;
  }

// Fonction pour récupérer la somme des montants des transactions où le statut est égal à 1 (retrait) du mois
  Future<double> getSommeRechargesDuMois() async {
    final db = await database;
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));

    final result = await db.rawQuery('SELECT SUM(montant) FROM transactions WHERE date >= ? AND date <= ? AND statut = 0', [startOfMonth.toIso8601String(), endOfMonth.toIso8601String()]);

    return (result.first['SUM(montant)'] ?? 0.0) as double;
  }

  // Fonction pour récupérer toutes les transactions
  Future<List<Map<String, dynamic>>> getToutesLesRecharges() async {
    final db = await database;
    return db.query('transactions', where: 'statut = ?', whereArgs: [0]);
  }

// Fonction pour récupérer tous les retraits
  Future<List<Map<String, dynamic>>> getTousLesRetraits() async {
    final db = await database;
    return db.query('transactions', where: 'statut = ?', whereArgs: [1]);
  }

}
