
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RandNumData {
  final int id;
  final int number;
  RandNumData({this.id, this.number});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
    };
  }}
  class DatabaseHelper {
  Database database ;
  String table = "randNumTable";
   DatabaseHelper(){
      open();
      print("calling constructor");
    }

    Future open() async {
      // Directory documentsDirectory = await getApplicationDocumentsDirectory();
      // String path = join(documentsDirectory.path, "TestDB.db");
      database = await openDatabase(join(await getDatabasesPath(), 'rand_num_database.db'), version: 1,
          onCreate: (Database db, int version) async {
          print("opening database");
            return db.execute(
              "CREATE TABLE randNumTable(id INTEGER PRIMARY KEY, number INTEGER)",
            );
          });
    }

    Future<void> insertRandNum(RandNumData randNum) async {
      // Get a reference to the database.
      final Database db = await database;
      print("inserting in database");
      await db.insert(
        'randNumTable',
        randNum.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    Future<int> getRandNum() async {
      // Get a reference to the database.
      final Database db = await database;
      print("get data from database");
      // Query the table for all The Dogs.
      final num = await db.query(table);
      print(num);
      // Convert the List<Map<String, dynamic> into a List<Dog>.
      return (num[0]['number']);
    }

  }



