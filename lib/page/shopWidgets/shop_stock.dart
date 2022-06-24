// This page is for display stock in shop having the given ID 
// Is used for sale product, just tape in the product item and receve a for modal
// And click in top-left to redirect in in sale news page
import 'dart:convert';
import 'package:digital_farm_app/page/shopWidgets/reimburse_list.dart';
import 'package:digital_farm_app/page/shopWidgets/sale_news.dart';
import 'package:digital_farm_app/page/shopWidgets/shop.dart';
import 'package:digital_farm_app/utils/customer.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:digital_farm_app/utils/shop.dart';
import 'package:digital_farm_app/widget/customer_widget.dart';
import 'package:digital_farm_app/widget/external_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
  List<Customer> customers = [];
  @override
  void initState() {
    getCustomer();
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
        )),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          overlayColor: Colors.black,
          overlayOpacity: 0.2,
          children: [
            SpeedDialChild(
              child: Icon(Icons.home_outlined,color: Colors.green,),
              label: "Fermé la boutique",
              labelStyle: TextStyle(color: Colors.green),
              onTap: () => showDialog(context: context, builder: (_){
                return CloseShop(id.toString());
              })
            ),SpeedDialChild(
              child: Icon(Icons.shop_2_outlined,color: Colors.green,),
              label: "Voir les ventes",
              labelStyle: TextStyle(color: Colors.green),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) { return SaleNewsPage(id);}))
            ),SpeedDialChild(
              child: Icon(Icons.person_add_alt_1_outlined,color: Colors.green,),
              label: "Ajouté nouveau client",
              labelStyle: TextStyle(color: Colors.green),
              onTap: () => showDialog(context: context,
            builder: (_) {return CustomerWidget(widget.id);},barrierDismissible: false)
            ),SpeedDialChild(
              child: Icon(Icons.money_outlined,color: Colors.green,),
              label: "Voir les dettes",
              labelStyle: TextStyle(color: Colors.green),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_){
                return ReimbursePage(widget.id.toString());
              }))
            )
          ],
        ),
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
              return SaleWidget(stocks[index]["product"],customers);
            },barrierDismissible: false);},
          child: Card(
              elevation: 0,
              color: Color.fromRGBO(0, 0, 0, 0.5),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(stocks[index]["product"],style: TextStyle(color: Color(0xFF7ED957), fontSize: 22, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      Text("En boutique : "+ stocks[index]["inShop"].toString(),style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                      Text("Au depot : "+ stocks[index]["inStore"].toString(),style: TextStyle(color: Colors.white ,fontSize: 18, fontWeight: FontWeight.bold),),
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

  Future<void> getCustomer() async{
    var res = await CallApi().getData("/api/v1/customer");
    if(res.statusCode == 401){
      CallApi().logOut(context);
    }else{
      var body = jsonDecode(utf8.decode(res.bodyBytes));
      if(body['success'])
        for(var item in body['object'])
          customers.add(Customer.fromJson(item));
    }
    
  }
}

class CloseShop extends StatefulWidget {
  final String shopId;
  const CloseShop(this.shopId);

  @override
  State<CloseShop> createState() => _CloseShopState();
}

class _CloseShopState extends State<CloseShop> {
  TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        title: Text("Votre code SVP!",style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
        content: TextField(
          controller: _controller,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Chaisir code"),
        ),
        actions: [
          ElevatedButton(onPressed: () async {
            var data = {
              "shopId": widget.shopId,
              "access": _controller.text
            };
            var res = await CallApi().postData(data,"/api/v1/shopStatus") ;
            var body = jsonDecode(utf8.decode(res.bodyBytes));
            if(body['success'])
             confirm(body['message'], widget.shopId,body['object']['status'],body['object']['cash']);
             else
              MyWidget().notifationAlert(context, body['message'], Colors.red);
          }, 
          child: Text("Soumettre",style: TextStyle(color: Colors.white),)),
          ElevatedButton(onPressed: (){Navigator.of(context).pop();},
           style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
           child: Text("Abandonner",style: TextStyle(color: Colors.white),)),
        ],
      );
  }
    Future<void> confirm(String message,String shopId,bool status,int cash) async{
    showDialog(barrierDismissible: false, context: context, builder: (_){
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        content: Text(message,style: TextStyle(fontSize: 20.0,),),
        actions: [
          ElevatedButton(onPressed: () async {
            var data = {"shopId": shopId};
            Navigator.of(context).pop();
            var res = await CallApi().postData(data,"/api/v1/shopStatus/close");
            var body = jsonDecode(utf8.decode(res.bodyBytes));
            if(body['success']){
                SharedPreferences localStorage = await SharedPreferences.getInstance();
                localStorage.remove("shopId");
                localStorage.remove("shopName");
                localStorage.remove("reimburse");
                Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (context) => ShopPage()),
                ModalRoute.withName("/"));
            }
            else MyWidget().notifationAlert(context, body['message'], Colors.red);
          },
           child: Text("Oui",style: TextStyle(color: Colors.white),)),
          ElevatedButton(onPressed: (){Navigator.of(context).pop();},
           style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
           child: Text("Annuler",style: TextStyle(color: Colors.white),))
        ],
      );
    });
  }
}

class SaleWidget extends StatefulWidget {
  final String subject;
  final List<Customer> customers;
  const SaleWidget(this.subject,this.customers);

  @override
  State<SaleWidget> createState() => _SaleWidgetState();
}

class _SaleWidgetState extends State<SaleWidget> {
  TextEditingController qte = new TextEditingController();
  TextEditingController val = new TextEditingController();
  TextEditingController advance = new TextEditingController();
  TextEditingController account = new TextEditingController();
  TextEditingController customer = new TextEditingController();
  late Customer customerSelected ;
  var _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
                  backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  title: Text("Vendre "+widget.subject,style: TextStyle(fontSize: 35.0,fontWeight: FontWeight.bold,)),
                  content: Form(
                    key: _key,
                    child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 20.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.phone,controller:this.qte,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                    icon: Icon(Icons.hourglass_bottom_outlined), labelText:"La quantite de la vente "),
                                  validator: (value) {if (value!.isEmpty) {return "La quantite est obligatoire ";}else return null; },),),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.phone,controller:this.val,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                   icon: Icon(Icons.hourglass_bottom_outlined), labelText:"La valeur total de la vente "),
                                  validator: (value) { if (value!.isEmpty) { return "La valeur est obligatoire "; } else return null;},),),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.phone,controller:this.advance,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                   icon: Icon(Icons.hourglass_bottom_outlined), labelText:"Montant recu "),
                                   onChanged: (String value) async{
                                     dynamicResult(value);},
                                  validator: (value) { if (value!.isEmpty) { return "La valeur de l'avance est obligatoire sinon mettez 0"; } else return null;},),),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  keyboardType:TextInputType.phone,controller:this.account,enabled: false,
                                  decoration: InputDecoration(border:OutlineInputBorder(),
                                   icon: Icon(Icons.hourglass_bottom_outlined), labelText:"Montant restante"),
                                )),
                              Padding(padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: TypeAheadFormField<Customer>(
                                textFieldConfiguration: TextFieldConfiguration(
                                    autofocus: true,controller: customer,keyboardType:TextInputType.phone,
                                    style: DefaultTextStyle.of(context).style.copyWith(
                                      fontStyle: FontStyle.italic
                                    ),
                                    decoration: InputDecoration(border: OutlineInputBorder(),labelText: "choisir client",
                                    icon: Icon(Icons.person_outline_outlined),)),
                                suggestionsCallback: (pattern)
                                 => widget.customers.where((element) => element.telephone.toString().startsWith(pattern)),
                                onSuggestionSelected: (suggestion){customerSelected = suggestion;
                                customer.text = suggestion.telephone.toString();},
                                itemBuilder: (context,suggestion) => Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10.0),
                                child: Text(suggestion.forSearch,style: TextStyle(fontSize: 19.0),),),
                                validator: (suggestion){
                                  if(suggestion!.isEmpty)
                                    return "Le client est obligatoire";
                                  else
                                    return null;
                                },
                              ))
                            ]))),
                  actions: [
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.thumb_down),iconSize: 75,color: Colors.red),
                    IconButton(onPressed: ()  {if (_key.currentState!.validate())
                                       _onSave(widget.subject, context);}, icon: Icon(Icons.save_alt_outlined),iconSize: 75,color: Colors.green),
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
   SharedPreferences localStorage = await SharedPreferences.getInstance();
   String? username = localStorage.getString("username");
   String? shopId = localStorage.getString("shopId");
   if(shopId == null || username == null){
     MyWidget().notification(context, "Veuillez ouvrir une caisse");
   }else{
    var data = {"shopId":shopId, "product":subject, "price": val.text,"quantity":qte.text,
      "username":username,"advance":advance.text,"account":account.text,"customerId":customerSelected.id};

      var response = await CallApi().postData(data, "/api/v1/outgoing/sale");
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      if(body['success']){
        //MyWidget().notification(context, body['message']);
        //Navigator.pop(context);
        Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(
          builder: (BuildContext context) => ShopStockPage(int.parse(shopId)),
      ),ModalRoute.withName("/"));
      }
      else{
        MyWidget().notification(context, body['message']);
        Navigator.pop(context);
      }
 }
 }
}