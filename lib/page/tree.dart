import 'dart:convert';

import 'package:digital_farm_app/page/tree_list.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'scanner.dart';
import 'tree_register.dart';

class TreePage extends StatefulWidget {
  const TreePage({ Key? key }) : super(key: key);

  @override
  _TreePageState createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
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
          actions: <Widget>[ IconButton(icon: const Icon(Icons.park_outlined),onPressed: () {})],
        )),
        floatingActionButton: IconButton(onPressed: (){Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => HomePage(),
      ),ModalRoute.withName("/"));}, icon: Icon(Icons.home,size: 35.0,)),
      body: Container( child: load? Center(child: Image.asset('images/loading.gif',width: 300.0,height: 300.0,),) : menu(),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/tree.jpg"),fit: BoxFit.cover,),),)
    );
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
          builder: (context) => TreeListPage(true)));}, 
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
          builder: (context) => TreeListPage(false)));}, 
            icon: Icon(Icons.launch_outlined,),iconSize:100,),
            SizedBox(height: 10,),
            Text("Sont déboisé",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
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
          builder: (context) => QRScanPage("tree","Arboculture","images/tree.jpg")));}, 
            icon: Icon(Icons.visibility_outlined,),iconSize:100,),
            SizedBox(height: 10,),
            Text("Gestion d'un arbre",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),]
          ),
        ),),
        Expanded(child: 
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TreeRegisterPage()));}, icon: Icon(Icons.loupe_outlined,),iconSize:100,),
            SizedBox(height: 10,),
            Text("Enregistrer un arbre",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),]
          ),
        ),)
          ])

      ),),
      SizedBox(height: 10,),]
    );
  }
  
  Future<void> getData() async {

    var response = await CallApi().getData("/api/v1/tree/count");
    var body = json.decode(response.body);
    print(body);
    if(body['success']){
      setState(() {
        present = body['present'];
        missing = body['missing'];
        load = false;
      });
    }
  }
}