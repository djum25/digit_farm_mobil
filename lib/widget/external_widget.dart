import 'dart:convert';
import 'package:digital_farm_app/page/shopWidgets/shop.dart';
import 'package:digital_farm_app/page/shopWidgets/shop_stock.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:digital_farm_app/utils/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyWidget{

List<Shop> shops = [];
bool load = true;

 void notification(BuildContext context,String msg){
   final snackBar = SnackBar(
     backgroundColor: Colors.white,
      content: Text(msg,style: TextStyle(fontSize: 18.0,color: Colors.black),),
      action: SnackBarAction(
        label: 'fermer',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
 }

 void notifationAlert(BuildContext context,String msg, Color color){
   showDialog(context: context, builder: (context){
        return AlertDialog(
                  backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                  content: Text(msg,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,color: color),),
        );});
 }

 void formShop(BuildContext context,Shop shop){
   TextEditingController accessController = new TextEditingController();
   TextEditingController cashController = new TextEditingController();
   var _formKey = GlobalKey<FormState>();
    Shop selectedShop = shop;
    showDialog(context: context, builder: (context){
        return AlertDialog(
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                  title: Text("Ouvrir/Fermer une Caisse",style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,)),
                  content: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                                  Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(selectedShop.name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.green),)
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.number,controller:cashController,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                    icon: Icon(Icons.money_outlined ), labelText:"Veuillez saisir l'etat de la caisse"),
                                  validator: (value) {if (value!.isEmpty) {return "L'etat de la caisse est obligatoire ";}else return null; },),),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.number,controller:accessController,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                    icon: Icon(Icons.keyboard_alt_outlined ), labelText:"Veuillez saisir votre code pin"),
                                  validator: (value) {if (value!.isEmpty) {return "Le code PIN est obligatoire ";}else return null; },),),]))),
                  actions: [
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.thumb_down),iconSize: 75,color: Colors.red),
                    IconButton(onPressed: ()  {
                      if (_formKey.currentState!.validate())
                      _openOrClose(context,accessController.text,selectedShop,cashController.text);}, icon: Icon(Icons.save_alt_outlined),iconSize: 75,color: Colors.green),
                  ]
     );
   },barrierDismissible: false);

 }

 Future<void> _openOrClose(context, String access,Shop shop,String cash) async{
   SharedPreferences localStorage = await SharedPreferences.getInstance();
   String? username = localStorage.getString("username");
   var data = {
     'username' : username,
     'access': int.parse(access),
     'id': shop.id,
     'name': shop.name,
     'cash': cash
   };

   var res = await CallApi().postData(data,"/api/v1/cashier/status/");
   var body = jsonDecode(utf8.decode(res.bodyBytes));
   if(body['success']) {
     Navigator.of(context).pop();
     if(body['status']){
     notifationAlert(context, body['message'],Colors.green);
      localStorage.setString("shopId", shop.id.toString());
      localStorage.setString("shopName", shop.name);
      localStorage.setString("cash", cash);
      localStorage.setString("reimburse", "0");
      Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => ShopStockPage(shop.id.toInt()),
      ),ModalRoute.withName("/"));
     }else{
       
      Navigator.of(context).pop();
       notifationAlert(context, body['message'],Colors.redAccent);
        localStorage.remove("shopId");
        localStorage.remove("shopName");
        localStorage.remove("reimburse");
        Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (context) => ShopPage()),
        ModalRoute.withName("/"));
        }
   } else {
     Navigator.of(context).pop();
     notifationAlert(context, body['message'],Colors.red);
   }
 }

 Future<void> getShop(BuildContext context,int id) async{
    List<Shop> shops = [];
    var response = await CallApi().getData("/api/v1/shop");
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    int index = 0;
        if(body["success"]){
            for (var item in body['shops']) {
            shops.add(Shop.fromJson(item));
            index++;
            if(index == body['shops'].length){
              Shop shop = shops.firstWhere((item) => item.id.toInt() == id);
                formShop(context, shop);
            }
        }
        }
  }

 Future<void> getReverseShop(BuildContext context,String product,String type) async{
    List<Shop> shops = [];
    var response = await CallApi().getData("/api/v1/shop");
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    int index = 0;
        if(body["success"]){
            for (var item in body['shops']) {
            shops.add(Shop.fromJson(item));
            index++;
            if(index == body['shops'].length){
              print(index);
                //formReverse(context, shops,product,type);
            }
        }
        }
  }

 Future<void> getReverseShopToShop(BuildContext context,String product) async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? sender =  localStorage.getString("shopId");
    List<Shop> shops = [];
    var response = await CallApi().getData("/api/v1/shop");
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    int index = 0;
        if(body["success"]){
            for (var item in body['shops']) {
            shops.add(Shop.fromJson(item));
            index++;
            if(index == body['shops'].length){
                formReverseShopToShop(context, shops,product,sender!);
            }
        }
        }
  }

 Future<void> formReverse(BuildContext context,String product,String shopId,String shopName) async{
   TextEditingController quantityController = new TextEditingController();
   var _formKey = GlobalKey<FormState>();
       showDialog(context: context, builder: (context){
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceBetween,
                  backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                  title: Text("Ravitaillé "+shopName,style: TextStyle(fontSize: 35.0,fontWeight: FontWeight.bold,)),
                  content: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                        padding: EdgeInsets.all(35.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.number,controller:quantityController,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                    icon: Icon(Icons.keyboard_alt_outlined ), labelText:"Veuillez saisir la quantité"),
                                  validator: (value) {if (value!.isEmpty) {return "La quantité est obligatoire ";}else return null; },),),]))),
                  actions: [
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.thumb_down),iconSize: 100,color: Colors.red),
                    
                    IconButton(onPressed: ()  {
                      if (_formKey.currentState!.validate())
                      _postReverse(context,product,quantityController.text,shopId);}, icon: Icon(Icons.save_alt_outlined),iconSize: 100,color: Colors.green),
                  ]
     );
   },barrierDismissible: false);
  }

 Future<void> formReverseShopToShop(BuildContext context,List<Shop> data,String product,String sender) async{
   TextEditingController quantityController = new TextEditingController();
   TextEditingController shopController = new TextEditingController();
   var _formKey = GlobalKey<FormState>();
   late Shop selectedShop;
       showDialog(context: context, builder: (context){
        return AlertDialog(
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                  title: Text("Ravitaillé des "+product+"s",style: TextStyle(fontSize: 35.0,fontWeight: FontWeight.bold,)),
                  content: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                        padding: EdgeInsets.all(35.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                                  Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TypeAheadFormField(
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                                keyboardType:
                                                    TextInputType.text,
                                                controller:shopController,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    icon: Icon(Icons
                                                        .shop_outlined),
                                                    labelText:
                                                        'Choisir la boutique')),
                                        suggestionsCallback: (pattern) {
                                          return data
                                              .where((element) => element
                                                  .name.toLowerCase()
                                                  .startsWith(pattern.toLowerCase()))
                                              .toList();
                                        },
                                        itemBuilder: (context,Shop suggestion) {
                                          return ListTile(
                                            title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(suggestion.name),
                                                ]),
                                          );
                                        },
                                        transitionBuilder: (context,
                                            suggestionsBox, controller) {
                                          return suggestionsBox;
                                        },
                                        onSuggestionSelected: (Shop suggestion) {
                                          selectedShop = suggestion;
                                          shopController.text = suggestion.name;
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'La boutique est obligatoire';
                                          } else
                                            return null;
                                        },
                                        //onSaved: (Category value) => this.selectedCategory= value,
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.number,controller:quantityController,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                    icon: Icon(Icons.keyboard_alt_outlined ), labelText:"Veuillez saisir la quantité"),
                                  validator: (value) {if (value!.isEmpty) {return "La quantité est obligatoire ";}else return null; },),),]))),
                  actions: [
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.thumb_down),iconSize: 100,color: Colors.red),
                    
                    IconButton(onPressed: ()  {
                      if (_formKey.currentState!.validate())
                      _shopToShop(context,product,quantityController.text,sender,selectedShop);}, icon: Icon(Icons.save_alt_outlined),iconSize: 100,color: Colors.green),
                  ]
     );
   },barrierDismissible: false);
  }

 Future<void> _postReverse(context,String product,String quantity,String shopId) async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? username = localStorage.getString('username');
    var data = {
      "product": product,
      "quantity": quantity,
      "type": "out",
      "username": username,
      "shopId":shopId
    };

    var res = await CallApi().postData(data, "/api/v1/reverse");
    var body = jsonDecode(utf8.decode(res.bodyBytes));
    Navigator.pop(context);
    if(body['success'])
      notifationAlert(context, body['message'], Colors.green);
    else
      notifationAlert(context, body['message'], Colors.red);
  }

  Future<void> _shopToShop(context,String product,String quantity,String senderShop,Shop shop) async{
      var data = {
      "product": product,
      "quantity": quantity,
      "senderShop": senderShop,
      "receverShop":shop.id
    };

    var res = await CallApi().postData(data, "/api/v1/reverse/shoptoshop");
    var body = jsonDecode(utf8.decode(res.bodyBytes));
    Navigator.pop(context);
    if(body['success'])
      notifationAlert(context, body['message'], Colors.green);
    else
      notifationAlert(context, body['message'], Colors.red);
  }
}