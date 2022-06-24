import 'dart:convert';

import 'package:digital_farm_app/page/shopWidgets/shop_stock.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:digital_farm_app/widget/external_widget.dart';
import 'package:flutter/material.dart';

class CustomerWidget extends StatefulWidget {
  final int id;
  const CustomerWidget(this.id);

  @override
  State<CustomerWidget> createState() => _CustomerWidgetState();
}

class _CustomerWidgetState extends State<CustomerWidget> {
  var _key = GlobalKey<FormState>();
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerTelephone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
      title: Text("Nouveau client",style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold,color: Colors.green),),
      content: Form(key: _key,
       child: SingleChildScrollView(scrollDirection: Axis.vertical,
         padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
             Padding(padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
             child: TextFormField(
               controller: _controllerName,
               decoration: InputDecoration(border: OutlineInputBorder(),
               labelText: "Nom du client",icon: Icon(Icons.person_add_alt_1_outlined)),
               validator: (value) {
                 if (value!.isEmpty) {
                   return "Le nom du client est obligatoire";
                 } else {
                   return null;
                 }
               },),),
             Padding(padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
             child: TextFormField(
               controller: _controllerTelephone,
               keyboardType: TextInputType.number,
               decoration: InputDecoration(border: OutlineInputBorder(),
               labelText: "Téléphone du client",icon: Icon(Icons.phone_iphone_outlined)),
               validator: (value) {
                 if (value!.isEmpty) {
                   return "Le Téléphone du client est obligatoire";
                 } else {
                   return null;
                 }
               },),)
           ],
         ),),),
    
    actions: [
      IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.thumb_down),iconSize: 75,color: Colors.red),
      IconButton(onPressed: ()  {if (_key.currentState!.validate())
            _onSave(context);}, icon: Icon(Icons.save_alt_outlined),iconSize: 75,color: Colors.green),]
    );
  }

  Future<void> _onSave(BuildContext context) async{

    var data = {
      "name": _controllerName.text,
      "telephone": _controllerTelephone.text
    };

    var res = await CallApi().postData(data, "/api/v1/customer");
    var body = jsonDecode(utf8.decode(res.bodyBytes));
    if(body['success']){
      Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => ShopStockPage(widget.id),
      ),ModalRoute.withName("/"));
    }else{
      MyWidget().notifationAlert(context, body['message'], Colors.red);
    }
  }
}