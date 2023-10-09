import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defaultButton ({
  double width = double.infinity,
  Color background = Colors.blue,
  required Function()? function,
  required String text,
  double radius =10.0,
}) => Container(
  width: width,
  child: MaterialButton(
    onPressed: function,
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: background,
  ),
);



Widget defaultText ({
  required TextEditingController controller,
  bool isPassword = false,
  required String text,
  required IconData prefix,
  IconData? suffix,
  Function ()? function,
  Function ()? date,
  bool readOnly = false,
  required String? Function(String? value) valid,
}) => TextFormField(
  style: TextStyle(color: Colors.white),
  controller: controller,
  keyboardType: TextInputType.visiblePassword,
  obscureText: isPassword,
  validator: valid,
  onTap: date,
  readOnly: readOnly,
  decoration: InputDecoration(
    labelText: text,
    labelStyle: TextStyle(color: Colors.white),
    prefixIcon: Icon(
      prefix,
      color: Colors.white,
    ),
    suffixIcon: suffix!= null ? IconButton(onPressed: function, icon: Icon(suffix,color: Colors.white,)):Icon(
      null
    ),
    border: OutlineInputBorder(),
  ),
);