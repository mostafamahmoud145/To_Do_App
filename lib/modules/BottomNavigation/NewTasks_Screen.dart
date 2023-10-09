import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class NewTasks extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state){},
      builder: (context,state){
        AppCubit appCubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: appCubit.NewTask.length > 0,
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) {
              return doItem(appCubit.NewTask, index,context);
            },
            separatorBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  color: Colors.white38,
                  height: 1.0,
                  width: double.infinity,
                ),
              );
            },
            itemCount: appCubit.NewTask.length,
          ),
          fallback: (context)=>Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu,
                  size: 70,
                  color: Colors.yellow.shade800,
                ),
                Text("No Tasks Yet, Please Add Some Tasks",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey,
                ),)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget doItem(List<Map> jobs, int index,context) =>
      Dismissible(

        background: Container(
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Swap To Delete Task",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ))
            ],
          ),
        ),
        key: Key(jobs[index]['id'].toString()),
        onDismissed: (DismissDirection){
          AppCubit.get(context).deleteFromDatabase(id: jobs[index]['id']);
          },
          child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          CircleAvatar(
          radius: 35,
          backgroundColor: Colors.yellow.shade800,
          child: Text("${jobs[index]['time']}", textAlign: TextAlign.center,
          style: TextStyle(
          color: Colors.white,
            fontWeight: FontWeight.bold
          ),
          ),
          ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${jobs[index]['title']}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("${jobs[index]['date']}",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold
                      ),),
                  ],
                ),
              ),
              IconButton(
                  onPressed: (){
                    AppCubit.get(context).updateDatabase(status: 'done', id: jobs[index]['id']);
                  },
                  icon: Icon(Icons.check_box_rounded,color: Colors.greenAccent,)),
              IconButton(
                  onPressed: (){
                    AppCubit.get(context).updateDatabase(status: 'archived', id: jobs[index]['id']);
                  },
                  icon: Icon(Icons.archive,color: Colors.deepOrange,)),
            ],
          ),
        ),
      );
}