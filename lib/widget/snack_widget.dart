import 'dart:convert';
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

 void formShop(BuildContext context,List<Shop> data){
   TextEditingController accessController = new TextEditingController();
   TextEditingController shopController = new TextEditingController();
   TextEditingController cashController = new TextEditingController();
   var _formKey = GlobalKey<FormState>();
    late Shop selectedShop;
    showDialog(context: context, builder: (context){
        return AlertDialog(
                  backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                  title: Text("Ouvrir/Fermer une Caisse",style: TextStyle(fontSize: 35.0,fontWeight: FontWeight.bold,)),
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
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.thumb_down),iconSize: 100,color: Colors.red),
                    SizedBox(width: 100,),
                    IconButton(onPressed: ()  {
                      if (_formKey.currentState!.validate())
                      _openOrClose(context,accessController.text,selectedShop,cashController.text);}, icon: Icon(Icons.save_alt_outlined),iconSize: 100,color: Colors.green),
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
     Navigator.pop(context);
     if(body['status']){
     notifationAlert(context, body['message'],Colors.green);
      localStorage.setString("shopId", shop.id.toString());
     }else{
       notifationAlert(context, body['message'],Colors.redAccent);
        localStorage.remove("shopId");
        }
   } else {
     Navigator.pop(context);
     notifationAlert(context, body['message'],Colors.red);
   }
 }

 

  Future<void> getShop(BuildContext context) async{
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
              formShop(context, shops);
            }
        }
        }
  }
}