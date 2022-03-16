
import 'dart:convert';

import 'package:digital_farm_app/utils/service.dart';
import 'package:digital_farm_app/utils/speculation.dart';
import 'package:digital_farm_app/widget/snack_widget.dart';
import 'package:flutter/material.dart';

import 'speculation_detail.dart';
import 'speculation_out.dart';

class SpeculationListPage extends StatefulWidget {
  final bool present;
  const SpeculationListPage(this.present);

  @override
  _SpeculationListPageState createState() => _SpeculationListPageState(this.present);
}

class _SpeculationListPageState extends State<SpeculationListPage> {
  bool present;
  _SpeculationListPageState(this.present);
  List<Speculation> speculations = [];
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
      body: Container( child: load? Center(child: Image.asset('images/loading.gif',width: 300.0,height: 300.0,),) : itemList(),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/speculation.jpg"),fit: BoxFit.cover,),),)
    );
  }

  Future<void> getPresent(bool b) async {
    var response = await CallApi().getData("/api/v1/speculation/byPresent?present=" + b.toString());
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    if (body['success']) {
      for (var item in body['speculations']) {
        speculations.add(Speculation.fromJson(item));
      }
      setState(() {
        load = false;
      });
    }
  }

  Widget itemList() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: speculations.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SpeculationDetailPage(speculations[index].name)));
            },
            onDoubleTap: (){
              if(speculations[index].present){Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SpeculationOutPage(speculations[index])));}
              else MyWidget().notification(context, "Déja récolté");},
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
                                    speculations[index].name,
                                    style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                                  ))),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Padding(padding: EdgeInsets.only(left: 10.0), child: Text(speculations[index].seedDate.toString(), style: TextStyle(fontSize: 30.0, color: Colors.white)))),
                          Expanded(child: Text(speculations[index].plantingName, style: TextStyle(fontSize: 30.0, color: Colors.white)))
                        ],
                      ),
                    ],
                  ))));
        });
  }

  
}