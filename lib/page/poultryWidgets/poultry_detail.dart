
import 'dart:convert';

import 'package:digital_farm_app/utils/calendary.dart';
import 'package:digital_farm_app/utils/poultry.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:digital_farm_app/widget/external_widget.dart';
import 'package:flutter/material.dart';

class PoultryDetailPage extends StatefulWidget {
  final String nameSubject;
  PoultryDetailPage(this.nameSubject);

  @override
  _PoultryDetailPageState createState() => _PoultryDetailPageState(this.nameSubject);
}

class _PoultryDetailPageState extends State<PoultryDetailPage> {
  String nameSubject;
  _PoultryDetailPageState(this.nameSubject);
  bool load = true;
  late Poultry poultry;
  List<Calendary> calendarys = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // here the desired height
          child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: ClipRect(child: Image.asset('images/logoFarm.gif',width: 60.0,height: 60.0,)),
          actions: <Widget>[ IconButton(icon: const Icon(Icons.flutter_dash_outlined),onPressed: () {})],
        )),
      body: Container( child: load? Center(child: Image.asset('images/loading.gif',width: 300.0,height: 300.0,),) : screen(),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/poultry.png"),fit: BoxFit.cover,),),)
    );
  }

  Future<void> getData() async {
    var response = await CallApi().getData('/api/v1/poultry/byName?name='+nameSubject);
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    if(body['success']){
      poultry = Poultry.fromJson(body['poultry']);
      for (var item in body['poultry']['calendary']) {
        calendarys.add(Calendary.fromMap(item));
      }
      setState(() {
        load = false;
      });
    }
  }

  Widget screen(){
    
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Container(
                  height: 150,
                  decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.6), borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    poultry.name,
                                    style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                                  ))),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Padding(padding: EdgeInsets.only(left: 10.0), child: Text(poultry.quantity.toString()+"sujet", style: TextStyle(fontSize: 30.0, color: Colors.white)))),
                          Expanded(child: Text(poultry.coopsName, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Padding(padding: EdgeInsets.only(left: 10.0), child: Text(poultry.developmentTime.toString()+"jours", style: TextStyle(fontSize: 30.0, color: Colors.white)))),
                          Expanded(child: Text(poultry.dateOfEntry, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                        ],
                      )
                    ],
                  ))),
                  Container(
                    height: MediaQuery.of(context).size.height -250,
                    child: itemList(),
                  )
        ]));
  }

  Widget itemList() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: calendarys.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
                  title: Text("Confirm !",style: TextStyle(fontSize: 50.0,fontWeight: FontWeight.bold,)),
                  content: calendarys[index].make ? Text("Dommage cette tache est deja effectuee ?",style: TextStyle(fontSize: 30.0,)): Text("Avez vous effectuez cette tache ?",style: TextStyle(fontSize: 30.0,)),
                  actions: [
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.thumb_down),iconSize: 100,color: Colors.red),
                    SizedBox(width: 230,),
                   calendarys[index].make ? IconButton(icon: Icon(Icons.sentiment_very_dissatisfied),onPressed: (){onMake(calendarys[index].id);},iconSize: 100,) : IconButton(icon: Icon(Icons.thumb_up),onPressed: (){onMake(calendarys[index].id);},iconSize: 100,)
                  ],
                );
              },barrierDismissible: false);
            },
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Container(
                  height: 200,
                  decoration: BoxDecoration(color: calendarys[index].make ? Color.fromRGBO(128, 255, 0, 0.5): Color.fromRGBO(255, 0, 0, 0.5),
                   borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  calendarys[index].name,
                                  style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                                ))),
                        Expanded(child: Text(calendarys[index].date, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  calendarys[index].intervention,
                                  style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                                ))),
                      ],
                    )
                  ]))));
        });
  }

  Future<void> onMake(int id) async{
    Navigator.pop(context);
    int index = calendarys.indexWhere((element) => element.id == id);
    if(calendarys[index].make == false){
      var response = await CallApi().getData("/api/v1/make/poultry/$id");
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      if(body['success']){
          MyWidget().notification(context, body['message']);
          setState(() {
            calendarys[index].make = true;
          });
      }else{
        MyWidget().notification(context, body['message']);
      }
    }else{
      MyWidget().notification(context,"D??ja effectu??");
    }
  }

}