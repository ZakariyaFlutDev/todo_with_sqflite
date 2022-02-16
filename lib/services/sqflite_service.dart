import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_with_sqflite/models/task_model.dart';

class DBHelper{
  static DBHelper _dataBaseHelper = DBHelper._createInstance();
  static Database? _database;

  DBHelper._createInstance();

  String dbName = "todo_sqflite";

  String tableName = "task_table";

  String colId = 'id';
  String colTitle = 'title';
  String colDate = 'date';
  String colPriority = 'priority';
  String colStatus = 'status';

  factory DBHelper(){
    _dataBaseHelper = DBHelper._createInstance();
    return _dataBaseHelper;
  }

  Future<Database?> get database async{
    _database ??= await initializeDataBase();
    return _database;
  }

  Future<Database?> initializeDataBase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + dbName;

    var todoListDb = await openDatabase(path,version: 1, onCreate: _createDb);
    return todoListDb;
  }

  void _createDb(Database database, int newVersion) async{
    await database.execute(
      'CREATE TABLE $tableName('
          '$colId INTEGER PRIMARY KEY AUTOINCREMENT,'
          '$colTitle TEXT,'
          '$colPriority INTEGER,'
          '$colDate TEXT,'
          '$colStatus INTEGER)'
    );
  }

  Future<List<Map<String, dynamic>>?> getTaskMapList() async{
    Database ? db = await this.database;
    final List<Map<String, Object?>>? result = await db?.query(tableName);
    return result;
  }

  Future<List<Task>> getTaskList() async{
    final List<Map<String, dynamic>>? taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList?.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });
    return taskList;
  }

  Future<int?> insertTask(Task task) async{
    Database? db = await this.database;
    final int? result = await db?.insert(tableName, task.toMap());
    return result;
  }

}