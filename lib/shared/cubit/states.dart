import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

abstract class AppStates{}
class AppInitialState extends AppStates{}
class AppChangeNavBarState extends AppStates{}
class AppCreateDatabaseState extends AppStates{}
class AppInsertDatabaseState extends AppStates{}
class AppGetDatabaseState extends AppStates{}
class AppUpdateDatabaseState extends AppStates{}
class AppGetDatabaseLoadingState extends AppStates{}
class AppChangeBottomSheetState extends AppStates{}
class AppTimeState extends AppStates{}