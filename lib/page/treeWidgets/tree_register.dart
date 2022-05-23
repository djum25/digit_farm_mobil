import 'dart:convert';
import 'package:digital_farm_app/utils/category.dart';
import 'package:digital_farm_app/utils/planting.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:digital_farm_app/widget/external_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../utilWidgets/gererater.dart';

class TreeRegisterPage extends StatefulWidget {
  const TreeRegisterPage({ Key? key }) : super(key: key);

  @override
  _TreeRegisterPageState createState() => _TreeRegisterPageState();
}

class _TreeRegisterPageState extends State<TreeRegisterPage> {
  var _formKey = GlobalKey<FormState>();
  DateTime _dateTime = DateTime.now();
  late String formattedDate;
  TextEditingController controllerCategory = new TextEditingController();
  TextEditingController controllerPlanting = new TextEditingController();
  List<Category> categorys = [];
  late Category selectedCategory;
  bool loadCategory = true;
  List<Planting> plantings = [];
  late Planting selectedPlanting ;
  bool loadPlanting = true;

  @override
  void initState() {
    initializeDateFormatting();
    var formatter = new DateFormat.yMMMMEEEEd('fr');
    formattedDate = formatter.format(_dateTime);
    getCategory();
    getPlanting();
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
      body: Container( child: formular(),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/tree.jpg"),fit: BoxFit.cover,),),
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),)
    );
  }

  Widget formular() {
    return SafeArea(
        top: false,
        bottom: false,
        child: Container(
          height: MediaQuery.of(context).size.height - 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color.fromRGBO(255, 255, 255, 0.6),
          ),
          child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                        padding: EdgeInsets.all(35.0),
                    child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: loadCategory
                                    ? Center(child: CircularProgressIndicator())
                                    : TypeAheadFormField(
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                                keyboardType:TextInputType.text,
                                                controller:  this.controllerCategory,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    icon: Icon(Icons.set_meal_outlined),
                                                    labelText: 'Choisir le type')),
                                        suggestionsCallback: (pattern) {
                                          return categorys.where((element) => element.name.toLowerCase().startsWith(pattern.toLowerCase())).toList();},
                                        itemBuilder: (context,Category suggestion) {
                                          return ListTile(
                                            title: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,children: <Widget>[Text(suggestion.name),]),); },
                                        transitionBuilder: (context, suggestionsBox, controller) {
                                          return suggestionsBox;
                                        },
                                        onSuggestionSelected: (Category suggestion) {
                                          this.selectedCategory = suggestion;
                                          controllerCategory.text = suggestion.name;
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Le type est obligatoire';
                                          } else
                                            return null;
                                        },
                                        //onSaved: (Category value) => this.selectedSeed= value,
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: loadPlanting
                                    ? Center(child: CircularProgressIndicator())
                                    : TypeAheadFormField(
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                                keyboardType:TextInputType.text,
                                                controller: this.controllerPlanting,
                                                decoration: InputDecoration(
                                                    border:OutlineInputBorder(),
                                                    icon: Icon(Icons.home_outlined),
                                                    labelText:"Choisir la Plantation ")),
                                        suggestionsCallback: (pattern) {
                                          return plantings.where((element) => element.name.toLowerCase().startsWith(pattern.toLowerCase())).toList();
                                        },
                                        itemBuilder: (context,Planting suggestion) {
                                          return ListTile(title: Row( mainAxisAlignment:  MainAxisAlignment.spaceBetween, children: <Widget>[ Text(suggestion.name), ]),);},
                                        transitionBuilder: (context,suggestionsBox, controller) {
                                          return suggestionsBox;
                                        },
                                        onSuggestionSelected: (Planting suggestion) {this.selectedPlanting= suggestion; controllerPlanting.text = suggestion.name; },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "La plantation est obligatoire";
                                          } else
                                            return null;
                                        },
                                        //onSaved: (Category value) => this.selectedSeed= value,
                                      ),
                              ),
                        Padding(padding: const EdgeInsets.symmetric(vertical:20.0),
                        child:Row(children: [
                          Expanded(child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF00CC00)),),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5.0,bottom: 5.0,left: 5.0, right: 5.0),
                                  child: Text("Changer la date",style: TextStyle(color: Colors.white,fontSize: 18.0,decoration: TextDecoration.none,fontWeight: FontWeight.normal,),),
                                ),
                                onPressed: () {
                                  DatePicker.showDatePicker(context,showTitleActions: true,
                              theme: DatePickerTheme(doneStyle: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF7ED957)),
                              cancelStyle: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF7ED957))),
                              minTime: DateTime(2020, 1, 1),maxTime: DateTime(2050, 12, 31), 
                          onChanged: (date) { }, 
                          onConfirm: (date) {
                            setState(() {
                              _dateTime = date;
                              var formatter = new DateFormat.yMMMMEEEEd('fr');
                              formattedDate = formatter.format(date);
                            });
                          }, currentTime: DateTime.now(), locale: LocaleType.fr);
                                },
                              )),
                        Expanded(child: Center(child: Text(formattedDate,style: TextStyle(fontSize: 20.0),),))
                        ],)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
                                  ),
                                  Expanded(
                                    child: Center(
                                        child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>( Color(0xFF00CC00)),),
                                      child: Padding(
                                        padding: EdgeInsets.only( top: 15, bottom: 15.0, left: 25.0, right: 25.0),
                                        child: Text( 'VALIDER', style: TextStyle(color: Colors.white, fontSize: 24.0, decoration: TextDecoration.none, fontWeight: FontWeight.normal,),
                                         ),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate())
                                          _onSave();
                                      },
                                    )),
                                  )
                                ],
                              ),
                              ]),))
        ));
  }

  Future<void> getCategory() async{
      var response = await CallApi().getData("/api/v1/treeCategory");
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      if(body['success']){
        for (var item in body['categorys']) {
          categorys.add(Category.fromJson(item));
        }
      }
      setState(() {
        loadCategory = false;
      });
  }

  Future<void> getPlanting() async{
    var response = await CallApi().getData("/api/v1/planting");
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      if(body['success']){
        for (var item in body['plantings']) {
          plantings.add(Planting.fromJson(item));
        }
      }
      setState(() {
        loadPlanting= false;
      });
  }

  Future<void> _onSave() async{
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(_dateTime);
      DateTime created  = DateTime.now();
      String createdOn = formatter.format(created);
      var data =Map<String, dynamic>();
      data['id'] = null;
      data['name'] = null;
      data['plantingDate'] = formattedDate;
      data['present'] = true;
      data['createdOn'] = createdOn;
      data['updatedOn'] = createdOn;
      data['planting'] = selectedPlanting.toMap();
      data['category'] = selectedCategory.toMap();

      var response = await CallApi().postData(data, "/api/v1/tree");
      var body = jsonDecode(utf8.decode(response.bodyBytes));
    if(body['success']){
      MyWidget().notification(context, "Enregistement reussit");
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GenerateCodePage(body['tree']['name'],'tree')));
    }else{
      MyWidget().notification(context,"Echec de l'enregistement");
    }
  }
}