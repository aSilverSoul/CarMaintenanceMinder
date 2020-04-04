class Note {
  int _id;
  String _title;
  String _description;//use description as mileage for now change later
  String _date;
  int _priority;
  int _weeklyMileage;


  Note(this._title, this._date, this._priority, this._weeklyMileage, [this._description]);

  Note.withId(this._id, this._title, this._date, this._priority,this._weeklyMileage,
      [this._description]);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  int get priority => _priority;
  String get date => _date;
  int get weeklyMileage => _weeklyMileage;

  set title(String newTitle){
    if(newTitle.length <= 20){
      this._title = newTitle;
    }
  }
  set description(String newDescription){
    if(newDescription.length <= 255){
      this._description = newDescription;
    }
  }
  set priority(int newPriority){
    if(newPriority== 1 || newPriority == 2){
      this._priority = newPriority;
    }
  }
  set weeklyMileage(int newMileage){//new mileage setter
    this._weeklyMileage = newMileage;
  }
  set date(String newDate){//setting date for the cars mileage
    this._date = newDate;
  }

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    if (id != null){
      map['id']= _id;
    }
    map['title']= _title;
    map['description']= _description;
    map['priority']= _priority;
    map['date']= _date;
    map['weeklyMileage']= _weeklyMileage;
    return map;
  }

  Note.fromMapObject(Map<String,dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
    this._weeklyMileage = map['weeklyMileage'];
  }
}
