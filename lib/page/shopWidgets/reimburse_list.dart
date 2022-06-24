
import 'dart:convert';

import 'package:digital_farm_app/utils/reimburse.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:digital_farm_app/widget/external_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReimbursePage extends StatefulWidget {
  final String id;
  const ReimbursePage(this.id);

  @override
  State<ReimbursePage> createState() => _ReimbursePageState();
}

class _ReimbursePageState extends State<ReimbursePage> {
  bool load = true;
  late List<Reimburse> reimburses = [];
  late List<Reimburse> showReimburses = [];
  late DateFormat dateFormat;
  late DateFormat timeFormat;

  @override
  void initState() {
    
    initializeDateFormatting(); 
    dateFormat = new DateFormat.yMMMMEEEEd('fr');
    timeFormat = new DateFormat.Hms('fr');
    getReimburse();
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
        )),
        body: Container( 
          height: MediaQuery.of(context).size.height - 62,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/shop.jpg"),fit: BoxFit.cover,),),
          child: load? Center(child: Image.asset('images/loading.gif',width: 300.0,height: 300.0,),) : layout(),
    ));
  }

  Widget layout(){
    return Column(
      children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
            child: TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Recherche par téléphone"),
              onChanged: (pattern) => filterItem(pattern),
            ),
          ),
          itemList()
      ]
    );
  }

void filterItem(String pattern){
    setState(() {
      showReimburses = reimburses.where((element) => element.telephone.startsWith(pattern)).toList();
    });
}

  Widget itemList(){
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 7.5), 
      scrollDirection: Axis.horizontal,
      child:SingleChildScrollView(
        scrollDirection: Axis.vertical,
      child : DataTable(
        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.6,),borderRadius: BorderRadius.all(Radius.circular(15))),
        dataTextStyle: TextStyle(color: Colors.white),
        headingTextStyle: TextStyle(color: Colors.green),
      columns: [
        DataColumn(label: Text('Client',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
        DataColumn(label: Text('Telephone',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
        DataColumn(label: Text('Produit',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
        DataColumn(numeric: true, label: Text('Dette',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
        DataColumn(numeric: true, label: Text('avance',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
        DataColumn(numeric: true, label: Text('Date',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
        DataColumn(label: Text('Payer',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
      ], 
      rows: showReimburses.map((data) => DataRow(cells: [
        DataCell(Text(data.name)),
        DataCell(Text(data.telephone)),
        DataCell(Text(data.product)),
        DataCell(Text(data.account.toString())),
        DataCell(Text(data.advance)),
        DataCell(Text(formatDate(data.date))),
        DataCell(IconButton(icon: Icon(Icons.touch_app_outlined,),onPressed: () => formDialog(data.id),),)
      ])).toList())));
  }

  void formDialog(num shopId){
    TextEditingController _controller = new TextEditingController();
    showDialog(barrierDismissible: false, context: context, builder: (_){
      _controller.text = "0";
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        title: Text("Remburser",style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize: 22.0),),
        content: Padding(padding: EdgeInsets.symmetric(horizontal: 5.5,vertical: 7.7),
          child: TextField(controller: _controller,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Montant du remboursement"),),),
        actions: [
          ElevatedButton(child: Text("Effectuer"),
            onPressed: (){_onReimburse(shopId, _controller.text);},),
          ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
            onPressed: (){Navigator.of(context).pop();}, 
            child: Text("Abandonner")),
        ],
      );
    });
  }

    String formatDate(String date){
   DateTime _dateTime = DateTime.parse(date);
    String formattedDate = dateFormat.format(_dateTime)+"   "+timeFormat.format(_dateTime);
    return formattedDate;
  }

  Future<void> _onReimburse(num id,String amount) async{
    Navigator.of(context).pop();
    var data = {"shopId":id,"amount":amount};
    var res = await CallApi().postData(data,'/api/v1/reimburse');
    var body = jsonDecode(utf8.decode(res.bodyBytes));
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      String reimburse = localStorage.getString("reimburse")!;
      localStorage.remove("reimburse");
      reimburse = (int.parse(reimburse) + int.parse(amount)).toString();
      localStorage.setString('reimburse', reimburse);
      setState(() {
        reimburses.clear();
      });
      getReimburse();
      MyWidget().notifationAlert(context, body['message'], Colors.green);
    }else{
      MyWidget().notifationAlert(context, body['message'], Colors.red);
    }
  }

  Future<void> getReimburse() async{
    var res = await CallApi().getData('/api/v1/reimburse/get/'+widget.id);
    var body = jsonDecode(utf8.decode(res.bodyBytes));
    if(body['success']){
      for (var item in body['object']) {
        reimburses.add(Reimburse.fromJson(item));
      }
      showReimburses = reimburses;
      setState(() {
        load = false;
      });
    }

  }
}