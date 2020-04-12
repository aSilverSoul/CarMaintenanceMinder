import 'package:flutter/material.dart';
import 'screens/car_list.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Car Maintenance Reminder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepOrange
      ),
      home: CarList(), //list of cars saved
    );
  }
}