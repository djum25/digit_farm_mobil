import 'package:digital_farm_app/page/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Navigation Drawer';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          fontFamily: "Crimson Text",
          primarySwatch: Colors.green,canvasColor: Colors.grey[200],
          iconTheme: IconThemeData(color: Color(0xFF7ED957)),
          appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Color(0xFF7ED957)),)),
          home: SplashScreenPage(),
      );
}