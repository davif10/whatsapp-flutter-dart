import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversa.dart';

class AbaConversas extends StatefulWidget {

  @override
  _AbaConversasState createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {
  List<Conversa> listaConversas = [
    Conversa(
        "José Renato",
        "Olá tudo bem?",
        "https://avatars.githubusercontent.com/u/43782019?v=4"
    ),
    Conversa(
        "Ana Maria",
        "Bem vindo.",
        "https://avatars.githubusercontent.com/u/43782019?v=4"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listaConversas.length,
        itemBuilder: (context, indice){
          Conversa conversa = listaConversas[indice];
          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(conversa.caminhoFoto)
            ),
            title: Text(conversa.nome, style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: 16),),
            subtitle: Text(
              conversa.mensagem,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14
              ),
            ),
          );
        }
    );
  }
}
