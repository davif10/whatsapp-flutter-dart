import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/telas/AbaContatos.dart';
import 'package:whatsapp/telas/AbaConversas.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  String _emailUsuario = "";
  TabController _tabController;
  List<String> itensMenu = [
    "Configurações", "Deslogar"
  ];

  Future _recuperarDadosUsuario() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser  usuarioLogado = await auth.currentUser();

    setState(() {
      _emailUsuario = usuarioLogado.email;
    });
  }
  _verificarUsuarioLogado() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser  usuarioLogado = await auth.currentUser();
    if(usuarioLogado == null){
      Navigator.pushReplacementNamed(context, "/login");
    }

  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
    _recuperarDadosUsuario();
    _tabController = TabController(
        length: 2, vsync: this
    );
  }

  _escolhaMenuItem(String itemEscolhido){
    switch(itemEscolhido){
      case "Configurações":
        Navigator.pushNamed(context, "/configuracoes");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
    }
  }
  
  _deslogarUsuario() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Whatsapp"),
        elevation: Platform.isIOS ? 0 : 4,
        bottom: TabBar(
          indicatorWeight: 4,
          indicatorColor: Platform.isIOS ? Colors.grey[400] : Colors.white ,
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          controller: _tabController,
          tabs: [
            Tab(text: "Conversas",),
            Tab(text: "Contatos",),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context){
              return itensMenu.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: TabBarView(
          controller: _tabController,
          children: [
            AbaConversas(),
            AbaContatos()
          ],
      )
    );
  }
}
