
import 'package:digital_farm_app/utils/planting.dart';
import 'package:digital_farm_app/utils/seed.dart';

class Speculation {

	late int id;
	
	late String name;
	
	late String seedDate;

	late bool present;

	late String seedName;

	late String plantingName;

  late Seed seed;

  late Planting planting;

  Speculation.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'],
    seedDate = json['seedDate'],
    present = json['present'],
    seedName = json['seedName'],
    plantingName = json['plantingName'],
    planting = Planting.fromJson(json['planting']),
    seed = Seed.fromJson(json['seed']);

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>()  ;
    map['id'] = this.id;
    map['name'] = this.name;
    map['seedDate'] = this.seedDate;
    map['present'] = this.present;
    map['seedName'] = this.seedName;
    map['plantingName'] = this.plantingName;
    map['planting'] = this.planting.toMap();
    map['seed'] = this.seed.toMap();

    return map;
  }
}