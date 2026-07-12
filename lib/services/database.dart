import 'package:chichewa_bible/classes/comment.dart';
import 'package:chichewa_bible/classes/highlight.dart';
import 'package:sqlite3/sqlite3.dart';
 
Database loadLocalDB() {
  var db = sqlite3.open('bible.db');
  // Create Tables
  db.execute('''
      CREATE TABLE IF NOT EXISTS ${Highlight.tableName} (id INTEGER PRIMARY KEY, book INTEGER, chapter INTEGER, verse INTEGER, start INTEGER, end INTEGER, color TEXT);
      CREATE TABLE IF NOT EXISTS ${Comment.tableName} (id INTEGER PRIMARY KEY, title TEXT, comment TEXT, book INTEGER, chapter INTEGER)
    ''');
  return db;
}
