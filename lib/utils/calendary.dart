class Calendary{
  late int id;
  late String name;
  late String intervention;
  late String date;
  late bool make;
  late bool giveUp;
  late String description;

  Calendary.fromMap(Map<String, dynamic> json):
  id = json['id'],
  name = json['calendaryName'],
  intervention = json['intervention'],
  date = json['date'],
  make = json['make'],
  giveUp = json['giveUp'],
  description = json['description'].toString();

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['calendaryName'] = name;
    map['intervention'] = intervention;
    map['date'] = date;
    map['make'] = make;
    map['giveUp'] = giveUp;
    map['description'] = description;
    
    return map;
  }
  
}