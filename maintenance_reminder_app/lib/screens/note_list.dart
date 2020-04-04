import 'package:flutter/material.dart';
import 'package:maintenance_reminder_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:maintenance_reminder_app/models/note.dart';
import 'note_detail.dart';


class CarList extends StatefulWidget {
  @override
  _CarListState createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> carList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (carList == null) {
      carList = List<Note>();
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
        tooltip: 'Add note',
        onPressed: () {
          print('FAB clciked');
          navigateToDetails(Note('','', 311, 2),'Add car');//weekly average mileage;
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
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
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

  void navigateToDetails(Note note,String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetails(
          note,title,
      );
    }));
    if (result== true){
      updateListView();
    }
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Note>> carListFuture = databaseHelper.getCarList();
      carListFuture.then((carList){
        setState(() {
          this.carList = carList;
          this.count = carList.length;
        });
      });
    });

  }
}