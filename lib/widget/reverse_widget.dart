
import 'dart:convert';

import 'package:digital_farm_app/page/shopWidgets/shop_stock.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:digital_farm_app/widget/external_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReverseForm extends StatefulWidget {
  final String currentAmount;
  const ReverseForm(this.currentAmount);

  @override
  State<ReverseForm> createState() => _ReverseFormState();
}

class _ReverseFormState extends State<ReverseForm> {
  TextEditingController _controller = new TextEditingController();
  var _key = GlobalKey<FormState>();
  String keepAmount = '0';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text("Versement de liquidité",style: TextStyle(color: Colors.green,
      fontSize: 22.0,fontWeight: FontWeight.bold),),
      content: Form(
                    key: _key,
                    child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 20.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text('Liquidité sur place : ${widget.currentAmount}',style: TextStyle(fontWeight: FontWeight.bold),),),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.phone,
                                  controller:this._controller,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                    icon: Icon(Icons.hourglass_bottom_outlined), labelText:"Montant à versé"),
                                    onChanged: (value) => calculKeepAmount(value),
                                  validator: (value) {if (value!.isEmpty) {return "Cette champ est obligatoire";}else return null; },),),
                              Padding(padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Text("Va rester en caisse : $keepAmount"),)
                            ]))),
      actions: [
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.thumb_down),iconSize: 75,color: Colors.red),
                    IconButton(onPressed: ()  {if (_key.currentState!.validate())
                                       _onSave(context);}, icon: Icon(Icons.save_alt_outlined),iconSize: 75,color: Colors.green),
                  ]
    );
  }

  Future<void> _onSave(BuildContext context) async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String shopId = localStorage.getString("shopId")!;
    var data = {
      "shopId": shopId,
      "payment": (int.parse(_controller.text) + int.parse(widget.currentAmount)).toString(),
      "keepAmount": keepAmount
    };
    var res = await CallApi().postData(data, "/api/v1/shop/comptability");
    if(res.statusCode == 401){
      CallApi().logOut(context);
    }else{
      var body = jsonDecode(utf8.decode(res.bodyBytes));
      if(body['success']){
        localStorage.setString("cash", keepAmount);
        Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(
          builder: (BuildContext context) => ShopStockPage(int.parse(shopId)),
      ),ModalRoute.withName("/"));
      }else{
        MyWidget().notifationAlert(context, body['message'], Colors.red);
      }
      
    }
  }

  void calculKeepAmount(String value){
    if (value.isNotEmpty) {
      setState(() {
        keepAmount = (int.parse(widget.currentAmount) - int.parse(value)).toString();
      });
    }else{
      setState(() {
        keepAmount = '0';
      });
    }
  }
}