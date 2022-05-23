// this page display the sale news of the given shop ID
import 'dart:convert';

import 'package:digital_farm_app/utils/sale.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaleNewsPage extends StatefulWidget {
  final int id;
  const SaleNewsPage(this.id);

  @override
  State<SaleNewsPage> createState() => _SaleNewsPageState();
}

class _SaleNewsPageState extends State<SaleNewsPage> {
  bool load = true;
  List<Sale> sales = [];
  late DateFormat dateFormat;
  late DateFormat timeFormat;
  late num priceTotal ;
  late num accountTotal;
  late num advanceTotal;
  late String openAmount;

  @override
  void initState() {
    initializeDateFormatting(); 
    dateFormat = new DateFormat.yMMMMEEEEd('fr');
    timeFormat = new DateFormat.Hms('fr');
    getNews();
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
          actions: <Widget>[ IconButton(icon: const Icon(Icons.home_outlined),onPressed: () {
            print("Button for reverse");
          })],
        )),
        body: Container( 
          height: MediaQuery.of(context).size.height - 62,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/shop.jpg"),fit: BoxFit.cover,),),
          child: load? Center(child: Image.asset('images/loading.gif',width: 300.0,height: 300.0,),) : layout(),
    ));
  }

  Widget layout(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 1, child: itemTotal()),
        Expanded(flex: 5,  child:itemList())
      ],
    );
  }

  Widget itemTotal(){
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 7.5,vertical: 5.0),
      scrollDirection: Axis.horizontal,
      child: DataTable(
        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.6,),borderRadius: BorderRadius.all(Radius.circular(15))),
        dataTextStyle: TextStyle(color: Colors.white),
        headingTextStyle: TextStyle(color: Colors.green),
        columns: [
        DataColumn(label: Text('Total vente',  
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),  
        DataColumn( numeric: true, label: Text('Encaissé',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),  
        DataColumn( numeric: true,label: Text('Dette',  
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                    DataColumn( numeric: true,label: Text('Etat ouverture',  
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
        ],
        rows: [DataRow(cells: [
              DataCell(Text(priceTotal.toString(),style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
              DataCell(Text(advanceTotal.toString(),style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
              DataCell(Text(accountTotal.toString(),style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
               DataCell(Text(openAmount,style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
        ])],),
    );
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
      //border: TableBorder.all(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(15))),
      columns: 
      [  
        DataColumn(label: Text('Produit',  
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),  
        DataColumn( numeric: true, label: Text('Quantité',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),  
        DataColumn( numeric: true,label: Text('Montant total',  
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
        DataColumn( numeric: true,label: Text('Montant recu',  
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
        DataColumn( numeric: true,label: Text('Restant',  
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Caissier',  
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Date',  
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),  
        ], 
     rows:sales.map((sale) => DataRow(cells: [  
                  DataCell(Text(sale.product,style: TextStyle(fontSize: 19, fontStyle: FontStyle.italic),)),
                  DataCell(Text(sale.quantity.toString())),
                  DataCell(Text(sale.price.toString(),style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                  DataCell(Text(sale.advance.toString())),
                  DataCell(Text(sale.account.toString())),
                  DataCell(Text(sale.user.toString())),
                  DataCell(Text(formatDate(sale.date))),
                ])).toList())));
  }

  Future<void> getNews() async{
    var res = await CallApi().getData("/api/v1/cashier/sale/news/"+widget.id.toString());
    var body = jsonDecode(utf8.decode(res.bodyBytes));
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      for (var item in body['objectArray']) {
        sales.add(Sale.fromJson(item));
      }
      setState(() {
        openAmount = localStorage.getString("cash")!;
        priceTotal = sales.map((e) => e.price).toList().reduce((value,element)=>value+element);
        accountTotal = sales.map((e) => e.account).reduce((value,element)=>value+element);
        advanceTotal = sales.map((e) => e.advance).reduce((value,element)=>value+element);
        load = false;
      });
    }
  }

  String formatDate(String date){
   DateTime _dateTime = DateTime.parse(date);
    String formattedDate = dateFormat.format(_dateTime)+"   "+timeFormat.format(_dateTime);
    return formattedDate;
  }
}