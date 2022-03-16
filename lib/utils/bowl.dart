class Bowl{
  late num id;

  late String name;

  late num area;
  
  late num depth;

  late String createdOn;

  late String updatedOn;

  Bowl.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'],
    area = json['area'],
    depth = json['depth'],
    createdOn = json['createdOn'],
    updatedOn = json['updatedOn'];

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['name'] = this.name;
    map['area'] = this.area;
    map['depth'] = this.depth;
    map['createdOn'] = this.createdOn;
    map['updatedOn'] = this.updatedOn;

    return map;
  }
}