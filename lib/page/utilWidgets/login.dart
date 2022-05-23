import 'dart:convert';

import 'package:digital_farm_app/page/utilWidgets/home.dart';
import 'package:digital_farm_app/utils/service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool checkedLoad = false;
  bool crypte = false;

  _showMsg(BuildContext contetxt, msg) {
    //
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //_scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Stack(
          children: <Widget>[
            ///////////  background///////////
            /* new Container(
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.greenAccent, Colors.blueAccent],
                ),
              ),
            ), */

            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            /////////////  Email//////////////
                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              controller: mailController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Color(0xFF7ED957),
                                ),
                                hintText: "Email",
                                hintStyle: TextStyle(color: Color(0xFF9b9b9b), fontSize: 15, fontWeight: FontWeight.normal),
                              ),
                            ),

                            /////////////// password////////////////////
                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              cursorColor: Color(0xFF9b9b9b),
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: !crypte,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.vpn_key,
                                  color: Color(0xFF7ED957),
                                ),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Color(0xFF9b9b9b), fontSize: 15, fontWeight: FontWeight.normal),
                              ),
                            ),
                            CheckboxListTile(
                                title: Text(
                                  "Afficher mot de passe",
                                  style: TextStyle(
                                  color: Color(0xFF7ED957),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                activeColor: Colors.white,
                                checkColor: Color(0xFF7ED957),
                                controlAffinity: ListTileControlAffinity.leading,
                                value: crypte,
                                onChanged: (bool? value) {
                                  setState(() {
                                    crypte = value!;
                                    print(crypte.toString());
                                  });
                                }),
                            /////////////  LogIn Botton///////////////////
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF7ED957)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                                  child: Text(
                                    _isLoading ? 'Loging...' : 'Login',
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                onPressed: _login,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    var data = {'username': mailController.text, 'password': passwordController.text};

    var res = await CallApi().auth(data);
    var body = json.decode(res.body);

    if (body['data']['token'] != null) {
      print('yes');
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['data']['token']);
      localStorage.setString('user', body['data']['firstname'] + " " + body['data']['lastname']);
      localStorage.setString('role', body['data']['role']);
      localStorage.setString('username', body['data']['username']);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return HomePage();
        }),
      );
    }else{
      _showMsg(context, "lLoginou mot de passe incorrect");
    }
  }
}
