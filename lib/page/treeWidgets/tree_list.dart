
import 'dart:convert';

import 'package:digital_farm_app/utils/service.dart';
import 'package:digital_farm_app/utils/tree.dart';
import 'package:flutter/material.dart';

import 'tree_detail.dart';

class TreeListPage extends StatefulWidget {
  final bool present;
  const TreeListPage(this.present);

  @override
  _TreeListPageState createState() => _TreeListPageState(this.present);
}

class _TreeListPageState extends State<TreeListPage> {
  bool present;
   _TreeListPageState(this.present);
  bool load = true;
  List<Tree> trees = [];

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
          actions: <Widget>[ IconButton(icon: const Icon(Icons.park_outlined),onPressed: () {})],
        )),
      body: Container( child: load? Center(child: Image.asset('images/loading.gif',width: 300.0,height: 300.0,),) : itemList(),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/tree.jpg"),fit: BoxFit.cover,),),)
    );
  }

  Future<void> getPresent(bool b) async {
    var response = await CallApi().getData("/api/v1/tree/byPresent?present=" + b.toString());
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    if (body['success']) {
      for (var item in body['trees']) {
        trees.add(Tree.fromJson(item));
      }
      setState(() {
        load = false;
      });
    }
  }

  Widget itemList() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: trees.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TreeDetailPage(trees[index].name)));
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
                                    trees[index].name,
                                    style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                                  ))),
                          Expanded(child: Text(trees[index].categoryName, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Padding(padding: EdgeInsets.only(left: 10.0), child: Text(trees[index].plantingDate.toString(), style: TextStyle(fontSize: 30.0, color: Colors.white)))),
                          Expanded(child: Text(trees[index].plantingName, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                        ],
                      ),
                    ],
                  ))));
        });
  }
}