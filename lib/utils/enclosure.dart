class Enclosure {

	late num id;
	
	late String enclosureName;
	
	late num area;
	
	late String createdOn;
	
	late String updatedOn;

  Enclosure.fromJson(Map<String, dynamic> json):
    id = json['id'],
    enclosureName = json['name'],
    area = json['area'],
    createdOn = json['createdOn'],
    updatedOn = json['updatedOn'];

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic> ();
    map['id'] = this.id;
    map['name'] = this.enclosureName;
    map['area'] = this.area;
    map['createdOn'] = this.createdOn;
    map['updatedOn'] = this.updatedOn;
    return map;
  }
}