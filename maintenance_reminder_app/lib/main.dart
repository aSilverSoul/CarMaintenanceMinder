import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Maintenance Reminder',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Car Maintenance Reminder'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[carList],
        ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              //where we add the code for adding a car
              //move to second page here
       },
        child: Icon(Icons.add),
      ),
      ),
    );
  }

  Widget carList = Container(
    padding: const EdgeInsets.all(32),
    child: Row(
      children: [
        Expanded(
          /*1*/
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*2*/
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Car Number 1',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Car Detail',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        /*3*/
        Icon(
          Icons.directions_car,
          color: Colors.red[500],
        ),
       ],
    ),
  );}