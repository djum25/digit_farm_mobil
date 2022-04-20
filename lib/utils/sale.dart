class Sale {
  late num id;
  late num quantity;
  late num advance;
  late num account;
  late num price;
  late String product;
  late String user;
  late String date;

Sale.fromJson(Map<String, dynamic> json):
  id = json['id'],
  quantity = json['quantity'],
  advance = json['advance'],
  account = json['account'],
  price = json['price'],
  product = json['produit'],
  date = json['date'],
  user = json['cashier']['user']['firstname']+" "+json['cashier']['user']['lastname'];
}