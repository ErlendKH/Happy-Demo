import 'package:sqflite/sqflite.dart';
import 'database.dart';

class AffirmationRepository {

  Future<void> insertAffirmation(String text) async {
    final db = await AppDatabase.instance.database;

    await db.insert(
      'affirmations',
      {
        'text': text,
        'source': 'affirmations.dev',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<String>> getAffirmations() async {
    final db = await AppDatabase.instance.database;

    final rows = await db.query(
      'affirmations',
      orderBy: 'created_at DESC',
    );

    return rows.map((e) => e['text'] as String).toList();
  }

  Future<void> deleteAffirmation(String text) async {
    final db = await AppDatabase.instance.database;

    await db.delete(
      'affirmations',
      where: 'text = ?',
      whereArgs: [text],
    );
  }

}