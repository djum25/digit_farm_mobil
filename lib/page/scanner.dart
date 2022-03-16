import 'package:digital_farm_app/page/cattle_detail.dart';
import 'package:digital_farm_app/page/fish_detail.dart';
import 'package:digital_farm_app/page/poultry_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'speculation_detail.dart';
import 'tree_detail.dart';

class QRScanPage extends StatefulWidget {
  final String subject;
  final String title;
  final String image;

  QRScanPage(this.subject,this.title,this.image);
  @override
  State<StatefulWidget> createState() => _QRScanPageState(this.subject,this.title,this.image);
}

class _QRScanPageState extends State<QRScanPage> {
  String subject;
  String title;
  String image;

  _QRScanPageState(this.subject,this.title,this.image);
  TextEditingController qrResult = new TextEditingController();
  String qrCode = "";
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(title,style: TextStyle(color: Color(0xFF7ED957),fontWeight: FontWeight.bold,fontSize: 20),)),
        body: Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage(image),fit: BoxFit.cover,),),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(horizontal: 100,vertical: 20),
                        child: Container(
                          decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.4), borderRadius: BorderRadius.all(Radius.circular(30))),
                          child: Center(
                            child: 
            IconButton(onPressed: (){scanQRCode();}, icon: Icon(Icons.qr_code_2_outlined),iconSize: 200,)
                          ),
                        )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 100.0,vertical:20),
                child: Container(
                  decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0.7), borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20,),
                  controller: qrResult,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Entrez un nom ou scannez",
                  ),
                ),
                )
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 100),child:
              ElevatedButton(
                onPressed: () => findSubject(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF7ED957)),       ),
                child: Text('Chercher'),
              )),
            ],
          ),
        ),
      );

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
        print("code : " + this.qrCode);
        qrResult.text = qrCode;
      });
    } on PlatformException {
      setState(() {
        this.qrCode = "Une erreur c'est produite veulliez recommencer";
        print("code : " + this.qrCode);
        qrResult.text = qrCode;
      });
    }
  }

  void findSubject() {
    if(qrResult.text.isNotEmpty){
      if(subject=='cattle')
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CattleDetail(qrResult.text)));
      if(subject=='fish')
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FishDetail(qrResult.text)));
      if(subject=='poultry')
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PoultryDetailPage(qrResult.text)));
      if(subject == 'tree')
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TreeDetailPage(qrResult.text)));
      if(subject == 'speculation')
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SpeculationDetailPage(qrResult.text)));
      }
    }
}
