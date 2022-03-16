
class Cattle{

	 late int id;
	
	 late String name;
	
	 late String gender;
	
	 late bool present;
	
	 late String date;

	late String createdOn;
	
	late String updatedOn;

	late String enclosureName ;

	late String categoryName;

  late String family;

  Cattle.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'],
    gender = json['gender'],
    present = json['present'],
    date = json['date'],
    createdOn = json['createdOn'],
    updatedOn = json['updatedOn'],
    enclosureName = json['enclosureName'],
    categoryName = json['categoryName'],
    family = json['family'];

}