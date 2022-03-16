
class Coop{

  late num id;

  late String name;

  late num area;

  late String createdOn;

  late String updatedOn;

  Coop.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'],
    area = json['area'],
    createdOn = json['createdOn'],
    updatedOn = json['updatedOn'];

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['name'] = this.name;
    map['area'] = this.area;
    map['createdOn'] = this.createdOn;
    map['updatedOn'] = this.updatedOn;

    return map;
  }
}