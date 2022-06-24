class Customer {
  
  late num id;

  late String name;

  late int telephone;

  late String forSearch;

  Customer.fromJson(Map<String,dynamic> json):
  id = json['id'],
  telephone = json['telephone'],
  forSearch = json['forSearch'];

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['id'] = id;
    map['telephone'] = telephone;

    return map;
  }
}