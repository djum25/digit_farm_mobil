import 'dart:convert';

import 'package:digital_farm_app/page/speculation_list.dart';
import 'package:digital_farm_app/page/speculation_register.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'scanner.dart';

class FarmingPage extends StatefulWidget {
  const FarmingPage({ Key? key }) : super(key: key);

  @override
  _FarmingPageState createState() => _FarmingPageState();
}

class _FarmingPageState extends State<FarmingPage> {
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // here the desired height
          child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: ClipRect(child: Image.asset('images/logoFarm.gif',width: 60.0,height: 60.0,)),
          actions: <Widget>[ IconButton(icon: const Icon(Icons.set_meal_outlined),onPressed: () {})],
        )),
        floatingActionButton: IconButton(onPressed: (){Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => HomePage(),
      ),ModalRoute.withName("/"));}, icon: Icon(Icons.home,size: 35.0,)),
      body: Container( child: load? Center(child: Image.asset('images/loading.gif',width: 300.0,height: 300.0,),) : menu(),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/speculation.jpg"),fit: BoxFit.cover,),),)
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
          builder: (context) => SpeculationListPage(true)));}, 
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
          builder: (context) => SpeculationListPage(false)));}, 
            icon: Icon(Icons.launch_outlined,),iconSize:100,),
            SizedBox(height: 10,),
            Text("Sont recolté",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
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
          builder: (context) => QRScanPage("speculation","Hortoculture","images/speculation.jpg")));}, 
            icon: Icon(Icons.visibility_outlined,),iconSize:100,),
            SizedBox(height: 10,),
            Text("Gestion d'une semence",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),]
          ),
        ),),
        Expanded(child: 
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            IconButton(onPressed: (){Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => SpeculationRegisterPage()));}, icon: Icon(Icons.loupe_outlined,),iconSize:100,),
            SizedBox(height: 10,),
            Text("Enregistrer une semence",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),]
          ),
        ),)
          ])

      ),),
      SizedBox(height: 10,),]
    );
  }
  
  Future<void> getData() async {

    var response = await CallApi().getData("/api/v1/speculation/count");
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