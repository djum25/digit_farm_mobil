import 'dart:convert';

import 'package:digital_farm_app/page/stock.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:digital_farm_app/widget/external_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class StockProduct extends StatefulWidget {
  final String productName;
  const StockProduct(this.productName);

  @override
  _StockProductState createState() => _StockProductState(this.productName);
}

class _StockProductState extends State<StockProduct> {
  String productName;
  _StockProductState(this.productName);
  var _formKey = GlobalKey<FormState>();
  String type = "in";
  TextEditingController _controllerQty = new TextEditingController();
  DateTime _dateTime = DateTime.now();
  late String formattedDate;

  @override
  initState(){
    initializeDateFormatting();
    var formatter = new DateFormat.yMMMMEEEEd('fr');
    formattedDate = formatter.format(_dateTime);
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
              actions: <Widget>[IconButton(icon: const Icon(Icons.storage), onPressed: () {})],
            )),
            
        body: Container(
          child: formular(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/stock.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text("Stock de "+productName,style: TextStyle(fontSize: 22.0),),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: [
                            Expanded(
                                        child: ListTile(
                                          title: const Text('Entrée'),
                                          leading: Radio(
                                            value: "in",
                                            groupValue: type,
                                            onChanged: (value) {
                                              setState(() {
                                                type = value.toString();
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                            Expanded(
                              child: ListTile(
                                title: const Text('Sortie'),
                                leading: Radio(
                                  value: "out",
                                  groupValue: type,
                                  onChanged: (value) {
                                    setState(() {
                                      type = value.toString();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: this._controllerQty,
                        decoration: InputDecoration(border: OutlineInputBorder(), icon: Icon(Icons.hourglass_bottom_outlined), labelText: "La quantité de produit"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "La quantité est obligatoire ";
                          } else
                            return null;
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                            child: TextButton(
                          child: Text(
                            formattedDate,
                            style: TextStyle(fontSize: 20.0, color: Colors.black),
                          ),
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                theme: DatePickerTheme(
                                    doneStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7ED957)), cancelStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7ED957))),
                                minTime: DateTime(2020, 1, 1),
                                maxTime: DateTime(2050, 12, 31),
                                onChanged: (date) {}, onConfirm: (date) {
                              setState(() {
                                _dateTime = date;
                                var formatter = new DateFormat.yMMMMEEEEd('fr');
                                formattedDate = formatter.format(date);
                              });
                            }, currentTime: DateTime.now(), locale: LocaleType.fr);
                          },
                        ))),
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
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF00CC00)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 15, bottom: 15.0, left: 25.0, right: 25.0),
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
                              if (_formKey.currentState!.validate()) _onSave();
                            },
                          )),
                        )
                      ],
                    ),
                  ]),
                ))));
  }

    Future<void> _onSave() async {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(_dateTime);
    DateTime created = DateTime.now();
    String createdOn = formatter.format(created);

    var data = {
      'id': null,
      'type': type,
      'quantity': _controllerQty.text,
      'createdOn': createdOn,
      'updatedOn': createdOn,
      'date': formattedDate,
      'product': productName,
      'user': null
    };
  
  var response = await CallApi().postData(data, "/api/v1/incoming");
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    MyWidget().notification(context, body['message']);
    if (body['success']) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => StockPage()));
    }
    }
}