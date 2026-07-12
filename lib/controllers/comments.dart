import 'package:chichewa_bible/classes/comment.dart';
import 'package:get/get.dart';
import 'package:sqlite3/sqlite3.dart';

// https://docs.flutter.dev/cookbook/persistence/sqlite

class CommentController extends GetxController {
  final _database = Rxn<Database>();

  void load(Database db) {
    _database.value = db;
  }

  Map<int, int> getBibleCommentCount() {
    Map<int, int> map = {};
    final commentSet =
        _database.value!.select('SELECT * FROM ${Comment.tableName}', []);

    for (var f in commentSet) {
      var book = f['book'] as int;
      if (map[book] == null) {
        map[book] = 1;
      } else {
        map[book] = (map[book] as int) + 1;
      }
    }
    return map;
  }

  void insertComment(Comment h) {
    final stmt = _database.value!.prepare(
        'INSERT INTO ${Comment.tableName} (id, book, chapter, title, comment) VALUES (?, ?, ?, ?, ?)');
    stmt.execute([h.id, h.book, h.chapter, h.title, h.comment]);
  }

  List<Comment> getComments(int book, int chapter) {
    final commentSet = _database.value!.select(
        'SELECT * FROM ${Comment.tableName} WHERE book = ? AND chapter = ?',
        [book, chapter]);
    return commentSet.map((e) => Comment.fromJson(e)).toList();
  }

  void updateComment(int id, Comment h) {
    final stmt = _database.value!.prepare(
        'UPDATE ${Comment.tableName} SET book = ?, chapter = ?, title = ?, comment = ? WHERE id = ?');
    stmt.execute([h.book, h.chapter, h.title, h.comment, id]);
  }

  void deleteComment(int id) {
    _database.value!
        .execute('DELETE FROM ${Comment.tableName} WHERE id = ?', [id]);
  }
}
