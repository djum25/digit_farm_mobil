import 'package:digital_farm_app/page/shop.dart';
import 'package:digital_farm_app/page/stock.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cattle.dart';
import 'farming.dart';
import 'fish.dart';
import 'login.dart';
import 'poultry.dart';
import 'tree.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          actions: <Widget>[IconButton(icon: const Icon(Icons.settings_power_outlined), onPressed: () {logOut(context);})],
          title: ClipRect(
              child: Image.asset(
            'images/logoFarm.gif',
            width: 60.0,
            height: 60.0,
          ))),
      body: loading());

  Widget loading() {
    return menu(); // album(pictures);
  }

  Widget album(List data) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 10, vertical: 20),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 0,
            color: Colors.white, //green[100],
            child: ClipRRect(
              child: Image.network(
                data[index]['url'],
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        });
  }

  Widget menu() {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 10, vertical: 20),
      children: <Widget>[
        GestureDetector(
          onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => CattlePage()));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/cattle.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Elevage",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ),
        GestureDetector(
          onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => PoultryPage()));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/poultry.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Aviculture",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ),
        GestureDetector(
          onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => FishPage()));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/fish.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Pisciculture",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ),
        GestureDetector(
          onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => TreePage()));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/tree.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Arboculture",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ),
        GestureDetector(
          onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => FarmingPage()));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/speculation.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Hortoculture",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ),
        GestureDetector(
          onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => StockPage()));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/stock.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Stock",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ),
        GestureDetector(
          onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShopPage()));},
          child: Card(
              elevation: 0,
              color: Colors.white, //green[100],
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/shop.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        "Vente",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ),
      ],
    );
  }
    Future<void> logOut(BuildContext context) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var remove = await localStorage.remove("token");
    if(remove){
      
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) {
        return LoginPage();
      }),
    );
  }
  }
}
