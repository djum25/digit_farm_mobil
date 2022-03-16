
class Tree{

    late int id;

    late String name;

    late String plantingDate;

    late bool present;

    late String categoryName;

    late String plantingName;

    Tree.fromJson(Map<String, dynamic> json):
      id = json['id'],
      name = json['name'],
      plantingDate = json['plantingDate'],
      categoryName = json['categoryName'],
      plantingName = json['plantingName'],
      present = json['present'];
}