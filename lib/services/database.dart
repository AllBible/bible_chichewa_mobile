import 'package:chichewa_bible/classes/comment.dart';
import 'package:chichewa_bible/classes/highlight.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqlite3/sqlite3.dart' as sqlite3;
 
Future<sqlite3.Database> loadLocalDB() async {
  var dbPath = await sqflite.getDatabasesPath();
  var p = path.join(dbPath, 'bible.db');
  var db = sqlite3.sqlite3.open(p);
  // Create Tables
  db.execute('''
      CREATE TABLE IF NOT EXISTS ${Highlight.tableName} (id INTEGER PRIMARY KEY, book INTEGER, chapter INTEGER, verse INTEGER, start INTEGER, end INTEGER, color TEXT);
      CREATE TABLE IF NOT EXISTS ${Comment.tableName} (id INTEGER PRIMARY KEY, title TEXT, comment TEXT, book INTEGER, chapter INTEGER)
    ''');
  return db;
}
