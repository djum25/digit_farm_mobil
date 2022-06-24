
import 'dart:convert';

import 'package:digital_farm_app/page/stockWidgets/stock.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'external_widget.dart';

class NewMatiere extends StatefulWidget {
  const NewMatiere({ Key? key }) : super(key: key);

  @override
  State<NewMatiere> createState() => _NewMatiereState();
}

class _NewMatiereState extends State<NewMatiere> {
  TextEditingController _controllerProduct = new TextEditingController();
  TextEditingController _controllerQuantity = new TextEditingController();
  TextEditingController _controllerVolume = new TextEditingController();
  TextEditingController _controllerDescription = new TextEditingController();
  var _key = GlobalKey<FormState>();
  DateTime _dateTime = DateTime.now();
  late String formattedDate;
  late String unitVolume = "LITTRE";
  late String unitValue = "BOUTEILLE";
  late String category = "Engrais";

  @override
  void initState() {
    initializeDateFormatting();
    var formatter = new DateFormat.yMMMMEEEEd('fr');
    formattedDate = formatter.format(_dateTime);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.9),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text("Produit inexistant",style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.green),),
      content: Form(
        key: _key,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
              child: TextFormField(controller: _controllerProduct,
              decoration: InputDecoration(border: OutlineInputBorder(),
              labelText: "Produit",icon: Icon(Icons.spa_outlined)),
              validator: (value) {
                if (value!.isEmpty) return "Le produit est obligatoire"; else return null;
              },),),
              //Padding(padding: const EdgeInsets.symmetric(vertical: 20),child: Row(children: [
                          ListTile(title: const Text('Engrais'),
                                    leading: Radio(value: "Engrais",groupValue: category,
                                    onChanged: (value) {setState(() {category = value.toString();});},),),
                          ListTile(title: const Text('Pesticide'),
                                    leading: Radio(value: "Pesticide",groupValue: category,
                                    onChanged: (value) {setState(() {category = value.toString();});},),),
                          ListTile(title: const Text('Insecticide'),
                                    leading: Radio(value: "Insecticide",groupValue: category,
                                    onChanged: (value) {setState(() {category = value.toString();});},),),
                          ListTile(title: const Text('Fongicide'),
                                    leading: Radio(value: "Fongicide",groupValue: category,
                                    onChanged: (value) {setState(() {category = value.toString();});},),),
                          ListTile(title: const Text('Autres'),
                                    leading: Radio(value: "Autres",groupValue: category,
                                    onChanged: (value) {setState(() {category = value.toString();});},),),
                       // ])),
              Padding(padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
              child: TextFormField(controller: _controllerQuantity,keyboardType: TextInputType.number,
              decoration: InputDecoration(border: OutlineInputBorder(),
              labelText: "Quantité",icon: Icon(Icons.spa_outlined)),
              validator: (value) {
                if (value!.isEmpty) return "La quantité est obligatoire"; else return null;
              },),),
          //Padding(padding: const EdgeInsets.symmetric(vertical: 20),child: Row(children: [
                          ListTile(title: const Text('Bouteille'),
                                    leading: Radio(value: "BOUTEILLE",groupValue: unitValue,
                                    onChanged: (value) {setState(() {unitValue = value.toString();});},),),
                          ListTile(title: const Text('Sac'),
                                    leading: Radio(value: "SAC",groupValue: unitValue,
                                    onChanged: (value) {setState(() {unitValue = value.toString();});},),),
                          ListTile(title: const Text('Caisse'),
                                    leading: Radio(value: "CAISSE",groupValue: unitValue,
                                    onChanged: (value) {setState(() {unitValue = value.toString();});},),),
                          ListTile(title: const Text('Piéce'),
                                    leading: Radio(value: "PIECE",groupValue: unitValue,
                                    onChanged: (value) {setState(() {unitValue = value.toString();});},),),  
                          //],)),
              Padding(padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
              child: TextFormField(controller: _controllerVolume,keyboardType: TextInputType.number,
              decoration: InputDecoration(border: OutlineInputBorder(),
              labelText: "Poids / Volume unitaire",icon: Icon(Icons.spa_outlined)),
              validator: (value) {
                if (value!.isEmpty) return "Le poid est obligatoire"; else return null;
              },),),
              ListTile(title: const Text('Litre'),
                                    leading: Radio(value: "LITTRE",groupValue: unitVolume,
                                    onChanged: (value) {setState(() {unitVolume = value.toString();});},),),
              ListTile(title: const Text('Kilogramme'),
                                    leading: Radio(value: "KILOGRAMME",groupValue: unitVolume,
                                    onChanged: (value) {setState(() {unitVolume = value.toString();});},),),
              ListTile(title: const Text('Piéce'),
                                    leading: Radio(value: "PIECE",groupValue: unitVolume,
                                    onChanged: (value) {setState(() {unitVolume = value.toString();});},),),
              Padding(padding: EdgeInsets.symmetric(vertical: 20.0),
              child: TextFormField(controller: _controllerDescription,keyboardType: TextInputType.multiline,maxLines: 3,
              decoration: InputDecoration(border: OutlineInputBorder(),
              labelText: "Description",icon: Icon(Icons.spa_outlined)),),),
            ],
          ),)),
      actions: [
        IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.thumb_down),iconSize: 75,color: Colors.red),
        IconButton(onPressed: ()  {if (_key.currentState!.validate())
                 _onSave(context);}, icon: Icon(Icons.save_alt_outlined),iconSize: 75,color: Colors.green),]
    );
  }

      Future<void> _onSave(BuildContext context) async {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(_dateTime);
    DateTime created = DateTime.now();
    String createdOn = formatter.format(created);

    var data = {
      'id': null,
      'type': "in",
      'value': _controllerQuantity.text,
      'unitVolume': unitVolume,
      'unitValue': unitValue,
      'volume': _controllerVolume.text,
      'description': _controllerDescription.text,
      'createdOn': createdOn,
      'updatedOn': createdOn,
      'date': formattedDate,
      'product': _controllerProduct.text,
      'user': null
    };
    var response = await CallApi().postData(data, "/api/v1/incoming");
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    if (body['success']) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => StockPage()));
    }else{
      MyWidget().notification(context, body['message']);
    } 
    }
}