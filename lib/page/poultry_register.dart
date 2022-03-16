import 'dart:convert';
import 'package:digital_farm_app/utils/category.dart';
import 'package:digital_farm_app/utils/coop.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:digital_farm_app/widget/snack_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'gererater.dart';

class PoultryRegisterPage extends StatefulWidget {
  const PoultryRegisterPage({ Key? key }) : super(key: key);

  @override
  _PoultryRegisterPageState createState() => _PoultryRegisterPageState();
}

class _PoultryRegisterPageState extends State<PoultryRegisterPage> {
  var _formKey = GlobalKey<FormState>();
  DateTime _dateTime = DateTime.now();
  late String formattedDate;
  TextEditingController controllerCategory = new TextEditingController();
  TextEditingController controllerCoop = new TextEditingController();
  TextEditingController controllerQuantity = new TextEditingController();
  TextEditingController controllerDevelopment = new TextEditingController();
  List<Category> categorys = [];
  late Category selectedCategory;
  bool loadCategory = true;
  List<Coop> coops = [];
  late Coop selectedCoop ;
  bool loadCoop = true;

  @override
  void initState() {
    initializeDateFormatting();
    var formatter = new DateFormat.yMMMMEEEEd('fr');
    formattedDate = formatter.format(_dateTime);
    getCategory();
    getCoop();
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
          actions: <Widget>[ IconButton(icon: const Icon(Icons.flutter_dash_outlined),onPressed: () {})],
        )),
      body: Container( child: formular(),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/poultry.png"),fit: BoxFit.cover,),),
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
                                                keyboardType:
                                                    TextInputType.text,
                                                controller:
                                                    this.controllerCategory,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    icon: Icon(Icons
                                                        .flutter_dash_outlined),
                                                    labelText:
                                                        'Choisir le type')),
                                        suggestionsCallback: (pattern) {
                                          return categorys
                                              .where((element) => element
                                                  .name.toLowerCase()
                                                  .startsWith(pattern.toLowerCase()))
                                              .toList();
                                        },
                                        itemBuilder: (context,Category suggestion) {
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
                                        //onSaved: (Category value) => this.selectedCategory= value,
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: loadCoop
                                    ? Center(child: CircularProgressIndicator())
                                    : TypeAheadFormField(
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                                keyboardType:
                                                    TextInputType.text,
                                                controller:
                                                    this.controllerCoop,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    icon: Icon(Icons
                                                        .home_outlined),
                                                    labelText:
                                                        "Choisir le poulailler ")),
                                        suggestionsCallback: (pattern) {
                                          return coops
                                              .where((element) => element
                                                  .name.toLowerCase()
                                                  .startsWith(pattern.toLowerCase()))
                                              .toList();
                                        },
                                        itemBuilder: (context,Coop suggestion) {
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
                                        onSuggestionSelected: (Coop suggestion) {
                                          this.selectedCoop = suggestion;
                                          controllerCoop.text = suggestion.name;
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Le poulailler est obligatoire";
                                          } else
                                            return null;
                                        },
                                        //onSaved: (Category value) => this.selectedCategory= value,
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:
                                                    TextInputType.number,
                                                controller:
                                                    this.controllerQuantity,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    icon: Icon(Icons
                                                        .hourglass_bottom_outlined),
                                                    labelText:
                                                        "La quantite de la bande "),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "La quantite est obligatoire ";
                                          } else
                                            return null;
                                        },),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:
                                                    TextInputType.number,
                                                controller:
                                                    this.controllerDevelopment,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    icon: Icon(Icons
                                                        .time_to_leave_outlined),
                                                    labelText:
                                                        "Duree de croissance "),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "La duree est obligatoire ";
                                          } else
                                            return null;
                                        },),
                              ),
                        Padding(padding: const EdgeInsets.symmetric(vertical:20.0),
                        child: Center(child:TextButton( child: Text(formattedDate,style: TextStyle(fontSize: 20.0,color: Colors.black),),
                        
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              theme: DatePickerTheme(doneStyle: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF7ED957)),
                              cancelStyle: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF7ED957))),
                              minTime: DateTime(2020, 1, 1),
                              maxTime: DateTime(2050, 12, 31), onChanged: (date) {
                          }, onConfirm: (date) {
                            setState(() {
                              _dateTime = date;
                              var formatter = new DateFormat.yMMMMEEEEd('fr');
                              formattedDate = formatter.format(date);
                            });
                          }, currentTime: DateTime.now(), locale: LocaleType.fr);
                                },))),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 10,
                                        right: 20),
                                  ),
                                  Expanded(
                                    child: Center(
                                        child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xFF00CC00)),
                                    ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 15,
                                            bottom: 15.0,
                                            left: 25.0,
                                            right: 25.0),
                                        child: Text(
                                          'VALIDER',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.0,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.normal,
                                          ),
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
      var response = await CallApi().getData("/api/v1/poultryCategory");
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

  Future<void> getCoop() async{
    var response = await CallApi().getData("/api/v1/chickenCoop");
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      if(body['success']){
        for (var item in body['chickenCoops']) {
          coops.add(Coop.fromJson(item));
        }
      }
      setState(() {
        loadCoop = false;
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
      data['developmentTime'] = int.tryParse(controllerDevelopment.text);
      data['dateOfEntry'] = formattedDate;
      data['quantity'] = int.tryParse(controllerQuantity.text);
      data['present'] = true;
      data['createdOn'] = createdOn;
      data['updatedOn'] = createdOn;
      data['chickenCoop'] = selectedCoop.toMap();
      data['category'] = selectedCategory.toMap();

      var response = await CallApi().postData(data, "/api/v1/poultry");
      var body = jsonDecode(utf8.decode(response.bodyBytes));
    if(body['success']){
      MyWidget().notification(context, "Enregistement reussit");
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GenerateCodePage(body['poultry']['name'],'poultry')));
    }else{
      MyWidget().notification(context,"Echec de l'enregistement");
    }
  }
}