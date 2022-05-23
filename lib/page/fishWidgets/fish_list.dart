import 'dart:convert';

import 'package:digital_farm_app/utils/fish.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:flutter/material.dart';

import 'fish_detail.dart';

class FishListPage extends StatefulWidget {
  final bool present;
  FishListPage(this.present);

  @override
  _FishListPageState createState() => _FishListPageState(this.present);
}

class _FishListPageState extends State<FishListPage> {
  bool present;
  _FishListPageState(this.present);
  List<Fish> fishs = [];
  bool load = true;

  @override
  void initState() {
    getPresent(present);
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
          actions: <Widget>[ IconButton(icon: const Icon(Icons.set_meal_outlined),onPressed: () {})],
        )),
      body: Container( child: load? Center(child: Image.asset('images/loading.gif',width: 200.0,height: 200.0,),) : itemList(),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/fish.jpg"),fit: BoxFit.cover,),),)
    );
  }

  Future<void> getPresent(bool b) async {
    var response = await CallApi().getData("/api/v1/fish/byPresent?present=" + b.toString());
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    if (body['success']) {
      for (var item in body['fishs']) {
        fishs.add(Fish.fromJson(item));
      }
      setState(() {
        load = false;
      });
    }
  }

  Widget itemList() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: fishs.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details){
               Navigator.of(context).push(MaterialPageRoute(builder: (context) => FishDetail(fishs[index].name)));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Container(
                  height: 200,
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
                                    fishs[index].name,
                                    style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                                  ))),
                          Expanded(child: Text(fishs[index].categoryName, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Padding(padding: EdgeInsets.only(left: 10.0), child: Text(fishs[index].quantity.toString(), style: TextStyle(fontSize: 30.0, color: Colors.white)))),
                          Expanded(child: Text(fishs[index].bowlName, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Padding(padding: EdgeInsets.only(left: 10.0), child: Text(fishs[index].date, style: TextStyle(fontSize: 30.0, color: Colors.white)))),
                          //Expanded(child: Text(cattles[index].enclosureName, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                        ],
                      )
                    ],
                  ))));
        });
  }
}