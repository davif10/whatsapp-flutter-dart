import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/Home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  Firestore.instance.collection("usuarios")
  .document("001")
  .setData({"nome":"Davi"});
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}
