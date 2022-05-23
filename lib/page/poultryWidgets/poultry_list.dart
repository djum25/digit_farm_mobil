import 'dart:convert';

import 'package:digital_farm_app/utils/poultry.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:digital_farm_app/widget/external_widget.dart';
import 'package:flutter/material.dart';

import 'poultry_detail.dart';
import 'poultry_out.dart';

class PoultryListPage extends StatefulWidget {
  final bool present;

  PoultryListPage(this.present);

  @override
  _PoultryListPageState createState() => _PoultryListPageState(this.present);
}

class _PoultryListPageState extends State<PoultryListPage> {
  bool present;
  _PoultryListPageState(this.present);
  List<Poultry> poultrys = [];
  bool load = true;

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
      body: Container( child: load? Center(child: Image.asset('images/loading.gif',width: 300.0,height: 300.0,),) : itemList(),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/poultry.png"),fit: BoxFit.cover,),),)
    );
  }

  Future<void> getData() async {
    var response = await CallApi().getData("/api/v1/poultry/byPresent?present=" + present.toString());
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    if(body['success']){
      for (var item in body['poultrys']) {
        poultrys.add(Poultry.fromJson(item));
      }
    }
    setState(() {
      load = false;
    });
  }

  Widget itemList() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: poultrys.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PoultryDetailPage(poultrys[index].name)));
            },
            onDoubleTap: (){
              if(poultrys[index].present){Navigator.of(context).push(MaterialPageRoute(builder: (context) => PoultryOutPage(poultrys[index],true)));}
              else MyWidget().notification(context, "Déja sortie");
            },
            onLongPress: () {
              if(poultrys[index].present){Navigator.of(context).push(MaterialPageRoute(builder: (context) => PoultryOutPage(poultrys[index],false)));}
              else MyWidget().notification(context, "Déja sortie");
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
                                    poultrys[index].name,
                                    style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                                  ))),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Padding(padding: EdgeInsets.only(left: 10.0), child: Text(poultrys[index].quantity.toString()+"sujet", style: TextStyle(fontSize: 30.0, color: Colors.white)))),
                          Expanded(child: Text(poultrys[index].coopsName, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Padding(padding: EdgeInsets.only(left: 10.0), child: Text(poultrys[index].developmentTime.toString()+"jours", style: TextStyle(fontSize: 30.0, color: Colors.white)))),
                          Expanded(child: Text(poultrys[index].dateOfEntry, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                        ],
                      )
                    ],
                  ))));
        });
  }
}
