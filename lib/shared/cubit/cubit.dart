import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/shared/cubit/states.dart';

import '../../modules/BottomNavigation/Archived_Screen.dart';
import '../../modules/BottomNavigation/Done_Screen.dart';
import '../../modules/BottomNavigation/NewTasks_Screen.dart';
import '../components/conestants.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit(super.initialState);

  static AppCubit get(context) => BlocProvider.of(context);
  List<Widget> screens= [NewTasks(), DoneTasks(), ArchivedTasks(),];
  List<String> titles= ["NEW TASKS", "DONE TASKS", "ARCHIVED TASKS"];
  int index=0;
  List<Map> NewTask=[];
  List<Map> DoneTask=[];
  List<Map> ArchivedTask=[];
  bool isBottomSheetShown = false;
  IconData iconData = Icons.edit;
  late Database database;

  void changeBottomSheetShown(bool isShow, IconData icon){
    isBottomSheetShown = isShow;
    iconData = icon;
    emit(AppChangeBottomSheetState());
  }
  void changeIndex(int inde){
    index=inde;
    emit(AppChangeNavBarState());
  }
  void createDatabase() async {
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
          getDataFromDatabase(database);
          print("Database is opened");
        }
    ).then((value) {
      emit(AppCreateDatabaseState());
      return value;
    });
  }
  void updateDatabase({required String status , required int id}) async {
     database.rawUpdate(
        'UPDATE task SET status = ?  WHERE id = ?',
        [status,id]).then((value) {
          getDataFromDatabase(database);
       emit(AppUpdateDatabaseState());
          print(value);
        });

  }
  void deleteFromDatabase({required int id}) async {
     database.rawDelete('DELETE FROM task WHERE id = ?', [id]).then((value) {
       getDataFromDatabase(database);
     });
  }
  void getDataFromDatabase (Database database) async {
    emit(AppGetDatabaseLoadingState());
    NewTask =[];
    DoneTask =[];
    ArchivedTask =[];
    database.rawQuery('SELECT * FROM task').then((value) {
      value.forEach((element)
      {
        if(element['status'] == 'new')
          NewTask.add(element);
        else if(element['status'] == 'done')
          DoneTask.add(element);
        else /**if(element['status']== 'archived')**/
          ArchivedTask.add(element);
      });
      emit(AppGetDatabaseState());
      print(value);
    });

  }
  Future<void> insertIntoDatabase(String title, String date, String time) async {
    database = await openDatabase(
        'todo.db',
        version: 1,
        onOpen: (database) {
          print("Database is opened");
        }
    );
    database.transaction((txn) {
      txn.rawInsert(
          'INSERT INTO task(title, date, time, status) VALUES("$title", "$date", "$time", "new")').then((value) {
            emit(AppInsertDatabaseState());
        print('${value.toString()}inserted successfully');
            getDataFromDatabase(database);
      }).catchError((onError) {
        print(
            'error when inserting record${onError
                .toString()}');
      });
      return Future(() => null);
    }).then((value) {
      emit(AppInsertDatabaseState());
    });
  }

}