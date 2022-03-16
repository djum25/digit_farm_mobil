
class Seed{

  late num id;

  late String seedName;

  late String createdOn;

  late String updatedOn;

  Seed.fromJson(Map<String, dynamic> json):
    id = json['id'],
    seedName = json['seedName'],
    createdOn = json['createdOn'],
    updatedOn = json['updatedOn'];

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic> ();
    map['id'] = this.id;
    map['seedName'] = this.seedName;
    map['createdOn'] = this.createdOn;
    map['updatedOn'] = this.updatedOn;
    return map;
  }
}