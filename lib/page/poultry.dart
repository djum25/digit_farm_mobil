import 'dart:convert';
import 'package:digital_farm_app/page/poultry_list.dart';
import 'package:digital_farm_app/page/poultry_register.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:flutter/material.dart';
import 'scanner.dart';

class PoultryPage extends StatefulWidget {
  const PoultryPage({ Key? key }) : super(key: key);

  @override
  _PoultryPageState createState() => _PoultryPageState();
}

class _PoultryPageState extends State<PoultryPage> {
  bool load = true;
  int present = 0;
  int missing = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: ClipRect(child: Image.asset('images/logoFarm.gif',width: 60.0,height: 60.0,)),
          actions: <Widget>[ IconButton(icon: const Icon(Icons.flutter_dash_outlined),onPressed: () { })],
        ),
      body: Container( child: load? Center(child: Image.asset('images/loading.gif',width: 300.0,height: 300.0,),) : menu(),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/poultry.png"),fit: BoxFit.cover,),),)
    );
  }

  Widget loading(){
    return load ?  Center(child: Image.asset('images/loading.gif',width: 60.0,height: 60.0,),) : menu();
  }

    Widget menu(){
    return Column(
      children:<Widget> [
      SizedBox(height: 10,),
      Padding(padding: EdgeInsets.only(left: 10,right: 10), 
      child :Container(
        height: MediaQuery.of(context).size.height/2 - 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(30),bottomLeft: Radius.circular(30),),
          color: Color.fromRGBO(0, 0, 0, 0.7)
        ),
          child: Row(
          children: <Widget> [
            Expanded(child:
            Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
            IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PoultryListPage(true)));}, 
            icon: Icon(Icons.login_outlined,),iconSize:100,),
            SizedBox(height: 10,),
            Text("Actuellement présent",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
            SizedBox(height: 10,),
            Text(present.toString(),style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),)],
          ),
        )),
        Expanded(child:
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PoultryListPage(false)));}, 
            icon: Icon(Icons.launch_outlined,),iconSize:100,),
            SizedBox(height: 10,),
            Text("Ont quitté",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
            SizedBox(height: 10,),
            Text(missing.toString(),style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),)],
          ),
        )),
          ],
        ),
      ),),
      SizedBox(height: 10,),
      Padding(padding: EdgeInsets.only(left: 10,right: 10),
      child: Container(
        height: MediaQuery.of(context).size.height/2 -55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(30),bottomLeft: Radius.circular(30),),
          color: Color.fromRGBO(0, 0, 0, 0.7)
        ),
        child: Row(
          children: <Widget> [
              Expanded(child: 
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => QRScanPage("poultry","Aviculture","images/poultry.png")));}, 
            icon: Icon(Icons.visibility_outlined,),iconSize:100,),
            SizedBox(height: 10,),
            Text("Gestion d'une bande",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),]
          ),
        ),),
        Expanded(child: 
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PoultryRegisterPage()));}, icon: Icon(Icons.loupe_outlined,),iconSize:100,),
            SizedBox(height: 10,),
            Text("Enregistrer une bande",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),]
          ),
        ),)
          ])

      ),),
      SizedBox(height: 10,),]
    );
  }

  Future<void> getData() async {

    var response = await CallApi().getData("/api/v1/poultry/count");
    var body = json.decode(response.body);
    if(body['success']){
      setState(() {
        present = body['present'];
        missing = body['missing'];
        load = false;
      });
    }
  }
}