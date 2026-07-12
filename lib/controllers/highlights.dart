import 'package:chichewa_bible/classes/highlight.dart';
import 'package:get/get.dart';
import 'package:sqlite3/sqlite3.dart';

class HighlightController extends GetxController {
  final _database = Rxn<Database>();

  void load(Database db) {
    _database.value = db;
  }

  void insertHighlight(Highlight h) {
    final stmt = _database.value!.prepare(
        'INSERT INTO ${Highlight.tableName} (id, book, chapter, verse, start, end, color) VALUES (?, ?, ?, ?, ?, ?, ?)');
    stmt.execute([h.id, h.book, h.chapter, h.verse, h.start, h.end, h.color]);
  }

  Map<int, int> getBibleHighlightCount() {
    Map<int, int> map = {};
    final resultSet =
        _database.value!.select('SELECT * FROM ${Highlight.tableName}', []);

    for (var f in resultSet) {
      var book = f['book'] as int;
      if (map[book] == null) {
        map[book] = 1;
      } else {
        map[book] = (map[book] as int) + 1;
      }
    }
    return map;
  }

  List<Highlight> getHighlights(int book, int chapter) {
    final highlightSet = _database.value!.select(
        'SELECT * FROM ${Highlight.tableName} WHERE book = ? AND chapter = ?',
        [book, chapter]);
    return highlightSet.map((e) => Highlight.fromJson(e)).toList();
  }

  Highlight? getHighlight(int book, int chapter, int verse) {
    final highlightSet = _database.value!.select(
        'SELECT * FROM ${Highlight.tableName} WHERE book = ? AND chapter = ? AND verse = ? LIMIT 1',
        [book, chapter, verse]);
    var list = highlightSet.map((e) => Highlight.fromJson(e)).toList();

    return list.isEmpty ? null : list[0];
  }

  void updateHighlight(int id, Highlight h) {
    final stmt = _database.value!.prepare(
        'UPDATE ${Highlight.tableName} SET book = ?, chapter = ?, verse = ?, start = ?, end = ?, color = ? WHERE id = ?');
    stmt.execute([h.book, h.chapter, h.verse, h.start, h.end, h.color, id]);
  }

  void deleteHighlight(int id) {
    _database.value!
        .execute('DELETE FROM ${Highlight.tableName} WHERE id = ?', [id]);
  }

  void removeHighlight(int book, int chapter, int verse) {
    _database.value!.execute(
        'DELETE FROM ${Highlight.tableName} WHERE book = ? AND chapter =? AND verse = ?',
        [book, chapter, verse]);
  }
}
