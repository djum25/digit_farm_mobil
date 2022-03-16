import 'dart:convert';
import 'package:digital_farm_app/page/gererater.dart';
import 'package:digital_farm_app/utils/category.dart';
import 'package:digital_farm_app/utils/enclosure.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:digital_farm_app/widget/snack_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class CattleRegisterPage extends StatefulWidget {
  const CattleRegisterPage({Key? key}) : super(key: key);

  @override
  _CattleRegisterPageState createState() => _CattleRegisterPageState();
}

class _CattleRegisterPageState extends State<CattleRegisterPage> {
  var _formKey = GlobalKey<FormState>();
  DateTime _dateTime = DateTime.now();
  late String formattedDate;
  List<Category> categorys = [];
  List<Enclosure> enclosures = [];
  bool loadCategory = true;
  bool loadEnclosure = true;
  String gender = 'male';
  TextEditingController controllerCategory = new TextEditingController();
  TextEditingController controllerHome = new TextEditingController();
  late Category selectedCategory;
  late Enclosure selectedHome;

  @override
  void initState() {
    initializeDateFormatting();
    var formatter = new DateFormat.yMMMMEEEEd('fr');
    formattedDate = formatter.format(_dateTime);
    getCategory();
    getEnclosure();
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
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/cattle.jpg"),fit: BoxFit.cover,),),
          padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
          child: formular(),
        ));
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
                                                        .savings_outlined),
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
                              Padding(padding: const EdgeInsets.symmetric(vertical:20),
                        child: Row(children: [
                          Expanded(child: ListTile(
                            title: const Text('Male'),
                            leading: Radio(
                              value: 'male',
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = 'male';
                                });
                              },
                            ),
                          ),
                          ),
                          Expanded(child: ListTile(
                            title: const Text('Femelle'),
                            leading: Radio(
                              value: "femelle",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = 'femelle';
                                });
                              },
                            ),
                          ),
                          ),
                        ],)),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: loadEnclosure
                                    ? Center(child: CircularProgressIndicator())
                                    : TypeAheadFormField(
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                                keyboardType:
                                                    TextInputType.text,
                                                controller:
                                                    this.controllerHome,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    icon: Icon(Icons
                                                        .home_outlined),
                                                    labelText:
                                                        "Choisir l'enclos ")),
                                        suggestionsCallback: (pattern) {
                                          return enclosures
                                              .where((element) => element
                                                  .enclosureName.toLowerCase()
                                                  .startsWith(pattern.toLowerCase()))
                                              .toList();
                                        },
                                        itemBuilder: (context,Enclosure suggestion) {
                                          return ListTile(
                                            title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(suggestion.enclosureName),
                                                ]),
                                          );
                                        },
                                        transitionBuilder: (context,
                                            suggestionsBox, controller) {
                                          return suggestionsBox;
                                        },
                                        onSuggestionSelected: (Enclosure suggestion) {
                                          this.selectedHome = suggestion;
                                          controllerHome.text = suggestion.enclosureName;
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "L'enclos est obligatoire";
                                          } else
                                            return null;
                                        },
                                        //onSaved: (Category value) => this.selectedCategory= value,
                                      ),
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

  Future<void> getCategory() async {
      var response = await CallApi().getData("/api/v1/cattleCategories");
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      for (var item in body['_embedded']['cattleCategories']) {
        categorys.add(Category.fromJson(item));
      }
      setState(() {
        loadCategory = false;
      });
  }

   Future<void> getEnclosure() async {
      var response = await CallApi().getData("/api/v1/enclosure");
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      for (var item in body['enclosures']) {
        enclosures.add(Enclosure.fromJson(item));
      }
      setState(() {
        loadEnclosure = false;
      });
  }
  Future<void> _onSave() async {
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(_dateTime);
      DateTime created  = DateTime.now();
      String createdOn = formatter.format(created);
    var data =Map<String, dynamic>();
      data['name']=null;
      data['category']= selectedCategory.toMap();
      data['enclosure']= selectedHome.toMap();
      data['gender']= gender;
      data['present']=true;
      data['id']= null;
      data['createdOn']= createdOn;
      data['date']= formattedDate;
      data['updatedOn']= createdOn;
    print(data);
    var response = await CallApi().postData(data, "/api/v1/cattle");
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    if(body['success']){
      MyWidget().notification(context,"Enregistement reussit");
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GenerateCodePage(body['cattle']['name'],'cattle')));
    }else{
      MyWidget().notification(context,"Echec de l'enregistement");
    }
  }
}
