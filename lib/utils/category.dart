class Category {
  late num id;

  late String name;

  late String family;

  late String createdOn;

  late String updatedOn;

  Category.fromJson(Map<String, dynamic> json):
  id = json['id'],
  name = json['name'],
  createdOn = json['createdOn'],
  updatedOn = json['updatedOn'];

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['name'] = this.name;
    map['family'] = null;
    map['createdOn'] = this.createdOn;
    map['updatedOn'] = this.updatedOn;
    return map;
  }
}
