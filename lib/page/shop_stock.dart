// This page is for display stock in shop having the given ID 
// Is used for sale product, just tape in the product item and receve a for modal
// And click in top-left to redirect in in sale news page
import 'dart:convert';
import 'package:digital_farm_app/page/sale_news.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:digital_farm_app/widget/external_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopStockPage extends StatefulWidget {
  final int id;
  const ShopStockPage(this.id);

  @override
  State<ShopStockPage> createState() => _ShopStockPageState(this.id);
}

class _ShopStockPageState extends State<ShopStockPage> {
  int id;
  _ShopStockPageState(this.id);
  bool load = true;
  List stocks = []; 

  @override
  void initState() {
    getShop();
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
          actions: <Widget>[ IconButton(icon: const Icon(Icons.home_outlined),onPressed: () {MyWidget().getShop(context,id);}),
          IconButton(icon: const Icon(Icons.shop_2_outlined),onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) { return SaleNewsPage(id); }));
          })]
        )),
        body: Container( child: load? Center(child: Image.asset('images/loading.gif',width: 300.0,height: 300.0,),) : itemStock(),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/shop.jpg"),fit: BoxFit.cover,),),),
    );
  }

Widget itemStock() {
    return GridView.builder(
      itemCount: stocks.length,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 10, vertical: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10.0,mainAxisSpacing: 10.0),
      itemBuilder: (BuildContext context,int index){
        return GestureDetector(
          onTap: () {
            showDialog(
            context: context,
            builder: (_) {
              return SaleWidget(stocks[index]["product"]);
            },barrierDismissible: false);},
          child: Card(
              elevation: 0,
              color: Color.fromRGBO(0, 0, 0, 0.5),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(stocks[index]["product"],style: TextStyle(color: Color(0xFF7ED957), fontSize: 35, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      SizedBox(height: 15.0,),
                      Text("En boutique : "+ stocks[index]["inShop"].toString(),style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
                      SizedBox(height: 15.0,),
                      Text("Au depot : "+ stocks[index]["inStore"].toString(),style: TextStyle(color: Colors.white ,fontSize: 25, fontWeight: FontWeight.bold),),
                    ],))),);},);}

  Future<void> getShop() async{
    var res = await CallApi().getData("/api/v1/shop/stock/"+this.id.toString());
    var body = jsonDecode(utf8.decode(res.bodyBytes));
    if(body['success']){
      setState(() {
      stocks = body['stocks'];
      load = false;
      });
    }
  }
}

class SaleWidget extends StatefulWidget {
  final String subject;
  const SaleWidget(this.subject);

  @override
  State<SaleWidget> createState() => _SaleWidgetState(this.subject);
}

class _SaleWidgetState extends State<SaleWidget> {
  String subject;
  _SaleWidgetState(this.subject);
  TextEditingController qte = new TextEditingController();
  TextEditingController val = new TextEditingController();
  TextEditingController advance = new TextEditingController();
  TextEditingController account = new TextEditingController();
  var _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
                  backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                  title: Text("Vendre "+subject,style: TextStyle(fontSize: 35.0,fontWeight: FontWeight.bold,)),
                  content: Form(
                    key: _key,
                    child: SingleChildScrollView(
                        padding: EdgeInsets.all(35.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.number,controller:this.qte,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                    icon: Icon(Icons.hourglass_bottom_outlined), labelText:"La quantite de la vente "),
                                  validator: (value) {if (value!.isEmpty) {return "La quantite est obligatoire ";}else return null; },),),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.number,controller:this.val,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                   icon: Icon(Icons.hourglass_bottom_outlined), labelText:"La valeur total de la vente "),
                                  validator: (value) { if (value!.isEmpty) { return "La valeur est obligatoire "; } else return null;},),),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.number,controller:this.advance,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                   icon: Icon(Icons.hourglass_bottom_outlined), labelText:"Montant recu "),
                                   onChanged: (String value) async{
                                     dynamicResult(value);},
                                  validator: (value) { if (value!.isEmpty) { return "La valeur de l'avance est obligatoire sinon mettez 0"; } else return null;},),),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.number,controller:this.account,enabled: false,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                   icon: Icon(Icons.hourglass_bottom_outlined), labelText:"Montant restante"),
                                )),
                            ]))),
                  actions: [
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.thumb_down),iconSize: 100,color: Colors.red),
                    SizedBox(width: 100,),
                    IconButton(onPressed: ()  {if (_key.currentState!.validate())
                                       _onSave(subject, context);}, icon: Icon(Icons.save_alt_outlined),iconSize: 100,color: Colors.green),
                  ]
     );
  }

 void dynamicResult(String value){
   var total = int.tryParse(val.text);
    var receiveValue = int.tryParse(value);
    if (total!=null && receiveValue!=null) {
      setState(() {
        account.text = (total - receiveValue).toString();
      });
    }
 }

   Future<void> _onSave(String subject,context) async{
   Navigator.pop(context);
   SharedPreferences localStorage = await SharedPreferences.getInstance();
   String? username = localStorage.getString("username");
   String? shopId = localStorage.getString("shopId");
   if(shopId == null || username == null){
     MyWidget().notification(context, "Veuillez ouvrir une caisse");
   }else{
    var data = {"shopId":shopId, "product":subject, "price": val.text,
      "quantity":qte.text, "username":username,"advance":advance.text,"account":account.text};

      var response = await CallApi().postData(data, "/api/v1/outgoing/sale");
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      if(body['success']){
        MyWidget().notification(context, body['message']);
        }
      else{
        MyWidget().notification(context, body['message']);
      }
 }
 }
}