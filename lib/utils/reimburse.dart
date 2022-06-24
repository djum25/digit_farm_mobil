class Reimburse{


  late num id;

  late String name;

  late String telephone;

  late String product;

  late String price;

  late String advance;

  late int account;

  late String date;

  Reimburse.fromJson(Map<String,dynamic> json):
    id = json['id'],
    name = json['customer']['name'],
    telephone = json['customer']['telephone'].toString(),
    product = json['produit'],
    price = json['price'].toString(),
    advance = json['advance'].toString(),
    account = json['account'],
    date = json['date'];

  Map<String,dynamic> toMap(){
    var map = new Map<String,dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['telephone'] = telephone;
    map['product'] = product;
    map['price'] = price;
    map['advance'] = advance;
    map['account'] = account;
    map['date'] = date;

    return map;
  }

}