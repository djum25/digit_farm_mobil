import 'dart:convert';

import 'package:digital_farm_app/utils/cattle.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:flutter/material.dart';

import 'cattle_detail.dart';

class CattleListPage extends StatefulWidget {
  final bool present;
  CattleListPage(this.present);

  @override
  _CattleListPageState createState() => _CattleListPageState(this.present);
}

class _CattleListPageState extends State<CattleListPage> {
  bool present;
  _CattleListPageState(this.present);

  bool load = true;
  List<Cattle> cattles = [];

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
              title: ClipRect(
                  child: Image.asset(
                'images/logoFarm.gif',
                width: 60.0,
                height: 60.0,
              )),
              actions: <Widget>[
                IconButton(icon: const Icon(Icons.savings_outlined, size: 50), onPressed: () {}),
                SizedBox(
                  width: 10,
                )
              ],
            )),
        body: Container(
          child: load
              ? Center(
                  child: Image.asset(
                    'images/loading.gif',
                    width: 60.0,
                    height: 60.0,
                  ),
                )
              : itemList(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/cattle.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ));
  }

  Future<void> getPresent(bool b) async {
    var response = await CallApi().getData("/api/v1/cattle/byPresent?present=" + b.toString());
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    if (body['success']) {
      for (var item in body['cattles']) {
        cattles.add(Cattle.fromJson(item));
      }
      setState(() {
        load = false;
      });
    }
  }

  Widget itemList() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: cattles.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CattleDetail(cattles[index].name)));
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
                                    cattles[index].name,
                                    style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                                  ))),
                          Expanded(child: Text(cattles[index].categoryName, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Padding(padding: EdgeInsets.only(left: 10.0), child: Text(cattles[index].gender, style: TextStyle(fontSize: 30.0, color: Colors.white)))),
                          Expanded(child: Text(cattles[index].family, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Padding(padding: EdgeInsets.only(left: 10.0), child: Text(cattles[index].date, style: TextStyle(fontSize: 30.0, color: Colors.white)))),
                          Expanded(child: Text(cattles[index].enclosureName, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                        ],
                      )
                    ],
                  ))));
        });
  }
}
