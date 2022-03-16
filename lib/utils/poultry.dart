
import 'package:digital_farm_app/utils/category.dart';
import 'package:digital_farm_app/utils/coop.dart';

class Poultry {
	
	late int id;
	
	late String name;
	
	late int developmentTime;
	
	late String dateOfEntry;
	
	late int quantity;
	
	late bool present;

	late String categoryName;

	late String coopsName;

  late Coop chickenCoop;

  late Category category;

  Poultry.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'],
    developmentTime = json['developmentTime'],
    dateOfEntry = json['dateOfEntry'],
    quantity = json['quantity'],
    present = json['present'],
    categoryName = json['categoryName'],
    coopsName = json['coopsName'],
    chickenCoop = Coop.fromJson(json['chickenCoop']),
    category = Category.fromJson(json['category']);

  Map<String, dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['id'] = this.id;
    map['name'] = this.name;
    map['developmentTime'] = this.developmentTime;
    map['dateOfEntry'] = this.dateOfEntry;
    map['quantity'] = this.quantity;
    map['present'] = this.present;
    map['categoryName'] = this.categoryName;
    map['coopsName'] = this.coopsName;
    map['chickenCoop'] = this.chickenCoop.toMap();
    map['category'] = this.category.toMap();

    return map;
  }
}