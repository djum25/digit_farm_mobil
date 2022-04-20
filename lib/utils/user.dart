
class User {
  late num id;
  late String lastname;
  late String firstname;
  late String name;

  User.fromJson(Map<String, dynamic> json):
    id = json['id'],
    lastname = json['lastname'],
    firstname = json['firstname'],
    name = json['firstname']+" "+json['lastname'];
}