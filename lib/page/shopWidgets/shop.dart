import 'dart:convert';

import 'package:digital_farm_app/page/utilWidgets/home.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:digital_farm_app/utils/shop.dart';
import 'package:digital_farm_app/widget/external_widget.dart';
import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';

import 'shop_stock.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({ Key? key }) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Shop> shops = [];
  bool load = true;
  num imOpen = 0;
  @override
  void initState() {
    getShop();
    super.initState();
    getOpenShop();
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
          actions: <Widget>[ IconButton(icon: const Icon(Icons.home_outlined),onPressed: () {})],
        )),
        floatingActionButton: IconButton(onPressed: (){Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => HomePage(),
      ),ModalRoute.withName("/"));}, icon: Icon(Icons.home,size: 35.0,)),
        body: Container( child: load? Center(child: Image.asset('images/loading.gif',width: 300.0,height: 300.0,),) : itemStock(),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/shop.jpg"),fit: BoxFit.cover,),),),
    );
  }

  Widget itemStock() {
    return GridView.builder(
      itemCount: shops.length,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 10, vertical: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10.0,mainAxisSpacing: 10.0),
       itemBuilder: (BuildContext context,int index){
        return GestureDetector(
          onTap: () { handleShop(context,shops[index]);},
          child: Card(
              elevation: 0,
              color: Color.fromRGBO(0, 0, 0, 0.5),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(shops[index].name,style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      SizedBox(height: 15.0,),
                      Icon(Icons.shopping_cart_outlined,size: 50),
                      imOpen == shops[index].id ? Icon(Icons.lock_open_rounded): SizedBox(height: 1.0,)
                    ],))),);},);}

  Future<void> getShop() async {
    var res = await CallApi().getData("/api/v1/shop");
    if (res.statusCode == 401) {
      CallApi().logOut(context);
    } else if(res.statusCode == 200){
      var body = jsonDecode(utf8.decode(res.bodyBytes));
      if(body['success']){
      for(var data in body['shops'])
        shops.add(Shop.fromJson(data));
      setState(() {
        load = false;
      });
    }
    } else{
       MyWidget().notifationAlert(context, "Il y'a une erreur au seveur principal revenez plus tard.", Colors.amber);
    }
  }

  Future<void> getOpenShop() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var shopId = localStorage.getString("shopId");
    if(shopId != null)
      if(num.tryParse(shopId) != null){
        imOpen = num.parse(shopId);
      }
  }

  Future<void> handleShop(context,Shop shop) async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var shopId = localStorage.getString("shopId");
    var shopName = localStorage.getString("shopName");
    if(shopId == null){
          MyWidget().formShop(context,shop);
    }else if(shopId == shop.id.toString()){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ShopStockPage(shop.id.toInt())));
    }
    else{
        MyWidget().notifationAlert(context, "Veuillez fermer la boutique "+shopName!, Colors.amber);
    }
  }
}