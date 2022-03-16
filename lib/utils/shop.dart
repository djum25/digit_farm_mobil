class Shop{
  late num id;

  late String name;

  Shop.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'];

 Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['name'] = this.name;
    return map;
  }
}