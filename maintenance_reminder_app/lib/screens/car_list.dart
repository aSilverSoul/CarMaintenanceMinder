import 'package:flutter/material.dart';
import 'package:maintenance_reminder_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:maintenance_reminder_app/models/car.dart';
import 'car_detail.dart';


class CarList extends StatefulWidget {
  @override
  _CarListState createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Car> carList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (carList == null) {
      carList = List<Car>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cars List'),
      ),
      body: getCarListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        tooltip: 'Add car',
        onPressed: () {
          print('FAB clciked');
          navigateToDetails(Car('','',2,341),'Add car');//weekly average mileage;
        },
      ),
    );
  }

  ListView getCarListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.carList[index].priority),
              child: getPriorityIcon(this.carList[index].priority),
            ),
            title: Text(
              this.carList[index].title,
              style: titleStyle,
            ),
            subtitle: Text(this.carList[index].date),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () {
                _delete(context, this.carList[index]);
              },
            ),
            onTap: () {
              print('The tile has been pressed!');
              navigateToDetails(this.carList[index],'Edit Vehicle Info');
            },
          ),
        );
      },
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.white;
        break;
      default:
        return Colors.white;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.directions_car);
        break;
      case 2:
        return Icon(Icons.directions_car);
        break;
      default:
        return Icon(Icons.directions_car);
    }
  }

  void _delete(BuildContext context, Car car) async {
    int result = await databaseHelper.deleteCar(car.id);
    if (result != 0) {
      _showSnackBar(context, 'vehicle info deleted successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetails(Car car,String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CarDetails(
        car,title,
      );
    }));
    if (result== true){
      updateListView();
    }
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Car>> carListFuture = databaseHelper.getCarList();
      carListFuture.then((carList){
        setState(() {
          this.carList = carList;
          this.count = carList.length;
        });
      });
    });

  }
}