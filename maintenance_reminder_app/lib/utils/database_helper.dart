import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:maintenance_reminder_app/models/car.dart';


class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String carTable = 'car_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';
  String colWeeklyMileage = 'weeklyMileage';//new

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'cars.db';

    Database carsDatabase =
    await openDatabase(path, version: 1, onCreate: _createDb);
    return carsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $carTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT, $colWeeklyMileage INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getCarMapList() async {
    Database db = await this.database;
    var result = await db.query(carTable, orderBy: '$colPriority ASC');
    return result;
  }

  Future<int> insertCar(Car car) async {
    Database db = await this.database;
    var result = await db.insert(carTable, car.toMap());
    return result;
  }

  Future<int> updateCar(Car car) async {
    Database db = await this.database;
    int result = await db.update(carTable, car.toMap(), where: '$colId = ?', whereArgs: <dynamic>[car.id]);
    return result;
  }

  Future<int> deleteCar(int id) async {
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM $carTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $carTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Car>> getCarList() async {
    var carMapList = await getCarMapList();
    int count = carMapList.length;
    List<Car> carList = List<Car>();
    for (int i = 0 ; i < count ; i++){
      carList.add(Car.fromMapObject(carMapList[i]));
    }
    return carList;

  }

}