import 'package:sqflite/sqflite.dart';
import 'affirmation_item.dart';
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

  Future<List<AffirmationItem>> getAffirmations() async {
    final db = await AppDatabase.instance.database;

    final rows = await db.query(
      'affirmations',
      orderBy: 'created_at DESC',
    );

    return rows.map((e) {
      return AffirmationItem(
        id: e['id'] as int,
        text: e['text'] as String,
        isFavorite: (e['is_favorite'] as int) == 1,
        createdAt: e['created_at'] as int,
      );
    }).toList();
  }

  Future<void> toggleFavorite(int id, bool isFavorite) async {
    final db = await AppDatabase.instance.database;

    await db.update(
      'affirmations',
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAffirmation(int id) async {
    final db = await AppDatabase.instance.database;
    await db.delete(
      'affirmations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}