import 'package:sqflite/sqflite.dart';

/**void createDatabase() async {
  database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (Database database, int version) {
        // When creating the db, create the table
        print("database is created");
        database.execute(
            'CREATE TABLE task (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)').then((value){
          print("table is created");
        }).catchError((onError){
          print("error when creating table ${onError.toString()}");
        });
      },
      onOpen: (database){
        getDataFromDatabase(database).then((value) {
          tasks=value;
        });
        print("Database is opened");
      }
  );
}
Future<List<Map>> getDataFromDatabase (Database database) async {
  List<Map> tas = await database.rawQuery('SELECT * FROM task').then((value){
    print(value);
    return throw"n";
  }).catchError((onError){
    print("error is ${onError.toString()}");
  });
}
Future<void> insertIntoDatabase(String title, String date, String time, String status) async {
  database = await openDatabase(
      'todo.db',
      version: 1,
      onOpen: (database) {
        print("Database is opened");
      }
  );
  database.transaction((txn) {
    txn.rawInsert(
        'INSERT INTO task(title, date, time, status) VALUES("$title", "$time", "$time", "$status")').then((value) {
      print('${value.toString()}inserted successfully');
    }).catchError((onError) {
      print(
          'error when inserting record${onError
              .toString()}');
    });
    return Future(() => null);
  });
}
Future<void> deleteTableFromDatabase() async {
  await database.execute("DROP TABLE IF EXISTS task");
}
List<Map> nul=[{'m':'m'}];
late Database database;**/
