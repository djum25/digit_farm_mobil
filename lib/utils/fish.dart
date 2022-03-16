class Fish{
  
    late int id;

    late String name;

    late int quantity;

    late String date;

    late bool present ;

    late String categoryName;

    late String bowlName;

    Fish.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'],
    quantity = json['quantity'],
    date = json['date'],
    present = json['present'],
    categoryName = json['categoryName'],
    bowlName = json['bowlName'];
}