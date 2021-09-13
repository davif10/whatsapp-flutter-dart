import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp/Login.dart';
import 'package:whatsapp/RouteGenerator.dart';

final ThemeData temaPadrao = ThemeData(
    primaryColor: Color(0xff075E54),
    accentColor: Color(0xff25D366)
);
final ThemeData temaIOS = ThemeData(
    primaryColor: Colors.grey[200],
    accentColor: Color(0xff25D366)
);
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: Login(),
    theme: Platform.isIOS ? temaIOS : temaPadrao,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generatorRoute,
    debugShowCheckedModeBanner: false,
  ));
}
