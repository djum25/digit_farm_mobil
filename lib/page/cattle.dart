import 'dart:convert';

import 'package:digital_farm_app/page/cattle_List.dart';
import 'package:digital_farm_app/page/cattle_register.dart';
import 'package:digital_farm_app/page/scanner.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:flutter/material.dart';

class CattlePage extends StatefulWidget {
  const CattlePage({Key? key}) : super(key: key);

  @override
  _CattlePageState createState() => _CattlePageState();
}

class _CattlePageState extends State<CattlePage> {
  bool load = true;
  int present = 0;
  int missing = 0;

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
              : menu(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/cattle.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ));
  }

  void heightScreen() {
    var size = MediaQuery.of(context).size.height;

    print(size);
  }

  Widget menu() {
    return Column(children: <Widget>[
      SizedBox(
        height: 10,
      ),
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Container(
          height: MediaQuery.of(context).size.height / 2 - 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
              color: Color.fromRGBO(0, 0, 0, 0.5)),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CattleListPage(true)));
                      },
                      icon: Icon(
                        Icons.login_outlined,
                      ),
                      iconSize: 100,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Actuellement présent",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      present.toString(),
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                    )
                  ],
                ),
              )),
              Expanded(
                  child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CattleListPage(false)));
                      },
                      icon: Icon(
                        Icons.launch_outlined,
                      ),
                      iconSize: 100,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Ont quitté",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      missing.toString(),
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                    )
                  ],
                ),
                //color: Colors.white,
              )),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Container(
            height: MediaQuery.of(context).size.height / 2 - 55,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                color: Color.fromRGBO(0, 0, 0, 0.7)),
            child: Row(children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => QRScanPage("cattle", "Elevage", "images/cattle.jpg")));
                      },
                      icon: Icon(
                        Icons.visibility_outlined,
                      ),
                      iconSize: 100,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Gestion d'un animal",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ]),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CattleRegisterPage()));
                      },
                      icon: Icon(
                        Icons.loupe_outlined,
                      ),
                      iconSize: 100,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Enregistrer un animal",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ]),
                ),
              )
            ])),
      ),
      SizedBox(
        height: 10,
      ),
    ]);
  }

  Future<void> getData() async {
    var response = await CallApi().getData("/api/v1/cattle/count");
    var body = json.decode(response.body);
    if (body['success']) {
      setState(() {
        present = body['present'];
        missing = body['missing'];
        load = false;
      });
    }
  }
}
