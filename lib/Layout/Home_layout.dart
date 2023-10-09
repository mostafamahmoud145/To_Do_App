
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../shared/components/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class HomeLayout extends StatelessWidget{
  
  var title = new TextEditingController();
  var dateInput = new TextEditingController();
  var timeInput = new TextEditingController();
  var globkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(AppInitialState())..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context, state){
          AppCubit appCubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: Color(0xFFB010f26),
            key: globkey,
            appBar: AppBar(
              backgroundColor: Colors.yellow.shade800,
              title: Text(appCubit.titles[appCubit.index],style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            body: ConditionalBuilder(
                condition: state is! AppGetDatabaseLoadingState,
                builder: (context) => appCubit.screens[appCubit.index],
                fallback: (context) => Center(child: CircularProgressIndicator())
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.yellow.shade800,
              onPressed: ()
              {
                TimeOfDay _time = TimeOfDay.now();
                if (appCubit.isBottomSheetShown) {
                  if (formkey.currentState!.validate()) {
                    appCubit.insertIntoDatabase(title.text,dateInput.text,timeInput.text);
                    Navigator.pop(context);
                    //setState(() {
                    appCubit.changeBottomSheetShown(false, Icons.edit);
                    title.text = "";
                    dateInput.text = "";
                    timeInput.text = "";
                    //});
                  }
                }
                else {
                  //setState(() {
                  appCubit.changeBottomSheetShown(true, Icons.add);
                  globkey.currentState?.showBottomSheet((context) =>
                      SingleChildScrollView(
                        child: Container(
                          color: Color(0xFFB0e1f3b),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formkey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  defaultText(controller: title,
                                      text: "Title",
                                      prefix: Icons.title,
                                      valid: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Title Must Not Be Empty";
                                        }
                                      }),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultText(controller: dateInput,
                                    text: "Date",
                                    readOnly: true,
                                    prefix: Icons.date_range,
                                    valid: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Title Must Not Be Empty";
                                      }
                                    },
                                    date: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          //DateTime.now() - not to allow to choose before today.
                                          lastDate: DateTime(2100));

                                      if (pickedDate != null) {
                                        print(
                                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                        String formattedDate =
                                        DateFormat('yMMMMd').format(pickedDate);
                                        print(
                                            formattedDate); //formatted date output using intl package =>  2021-03-16
                                        //setState(() {
                                        dateInput.text =
                                            formattedDate; //set output date to TextField value.
                                        //});
                                      } else {}
                                    },
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultText(controller: timeInput,
                                    text: "Time",
                                    prefix: Icons.timer,
                                    valid: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Title Must Not Be Empty";
                                      }
                                    },
                                    readOnly: true,
                                    date: () async {
                                      final TimeOfDay? newTime = await showTimePicker(
                                        context: context,
                                        initialTime: _time,
                                      ).then((value) {
                                        if (value != null) {
                                          _time = value;
                                          AppTimeState();
                                          timeInput.text = "${_time.format(context)}";
                                        }
                                      });

                                    },
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),).closed.then((value) {
                    appCubit.changeBottomSheetShown(false, Icons.edit);
                    // });
                  });
                  //});
                }

              },
              child: Icon(appCubit.iconData),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Color(0xFFB0e1f3b),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.yellow.shade800,
              currentIndex: appCubit.index,
              onTap: (value){
                //setState(() {
                appCubit.index = value;
                appCubit.changeIndex(value);
                // });
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: "Done"),
                BottomNavigationBarItem(icon: Icon(Icons.archive), label: "Archived"),
              ],

            ),
          );
        },
      ),
    );
  }
}