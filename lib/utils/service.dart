import 'dart:convert';

import 'package:digital_farm_app/page/utilWidgets/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class CallApi{
    final String api = 'http://192.168.31.80:8080'; //'http://51.178.140.26:8080/digitalFerme'; //'http://192.168.0.153:8080';
    late String token;

    postData(data, way) async {
    this.token = await getToken();
    var url = Uri.parse(api + way);
    return await http.post(
        url,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

    getData(way) async {
    this.token = await getToken();
    var url = Uri.parse(api + way);
    return await http.get(
        url,
        headers: _setHeaders()
    );
  }

  auth(data) async {
    var url = Uri.parse(api + '/authenticate');
    return await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }
    );
  }

    _setHeaders() =>
      {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization' : 'Bearer '+this.token,
      };

  getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString( 'token' );
    return token;
  }

  logOut(BuildContext context) async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.clear();
    Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => LoginPage(),
      ),ModalRoute.withName("/"));
  }
}