import 'package:flutter/material.dart';
import 'package:maintenance_reminder_app/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:maintenance_reminder_app/models/car.dart';


class CarDetails extends StatefulWidget {
  final String appBarTitle;
  final Car car;

  const CarDetails(this.car, this.appBarTitle);

  @override
  _CarDetailsState createState() => _CarDetailsState(car, appBarTitle);
}

class _CarDetailsState extends State<CarDetails> {
  final String appBarTitle;
  final Car car;

  DatabaseHelper databaseHelper = DatabaseHelper();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController weeklyMileageController = TextEditingController();
  static var _priorities = ['High', 'Low'];

  _CarDetailsState(this.car, this.appBarTitle);

  @override
  Widget build(BuildContext context) {//these are used to display the details of a car
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text = car.title;
    descriptionController.text = car.description;
    weeklyMileageController.text = car.weeklyMileage.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value) {
                  print('Something changed in Title Text Field');
                  updateTitle();
                },
                decoration: InputDecoration(
                    labelText: 'Car Name',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) {
                  updateDescription();
                  print('Something changed in Description Text Field');
                },
                decoration: InputDecoration(
                    labelText: 'Car Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: weeklyMileageController,
                style: textStyle,
                onChanged: (value) {
                  print('Something changed in weekly mileage Text Field');
                  updateWeeklyMileage();//change this
                },
                decoration: InputDecoration(
                    labelText: 'Weekly Mileage',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Save',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          print('Saved button clicked');
                          _save();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Delete',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          _delete();
                          print('Delete button clicked');
                        });
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        car.priority = 1;
        break;
      case 'Low':
        car.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void updateTitle() {
    car.title = titleController.text;
  }

  void updateDescription() {
    car.description = descriptionController.text;
  }
  void updateWeeklyMileage(){
    car.weeklyMileage = int.parse(weeklyMileageController.text);//getting weekly mileage
  }

  void _save() async {
    moveToLastScreen();
    //int daysAdded = ;
    car.date = DateFormat.yMMMd().format(DateTime.now()); // date time
    int result;
    if (car.id != null) {
      result = await databaseHelper.updateCar(car);
    } else {
      result = await databaseHelper.insertCar(car);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Car Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Car Saved Successfully');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    //showDialog(context: context, builder: (_) => alertDialog);
  }

  void _delete() async {
    moveToLastScreen();
    if(car.id == null){
      _showAlertDialog('Status', 'No Car was deleted');
      return;
    }
    int result = await databaseHelper.deleteCar(car.id);
    if (result != 0){
      _showAlertDialog('Status', 'Car Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Car');
    }
  }
  void moveToLastScreen(){
    Navigator.pop(context, true);
  }
}
