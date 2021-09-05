import 'package:flutter/material.dart';
class AbaContatos extends StatefulWidget {

  @override
  _AbaContatosState createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {
  // List<Conversa> listaContatos = [
  //   Conversa(
  //       "José Renato",
  //       "Olá tudo bem?",
  //       "https://avatars.githubusercontent.com/u/43782019?v=4"
  //   ),
  //   Conversa(
  //       "Ana Maria",
  //       "Bem vindo.",
  //       "https://avatars.githubusercontent.com/u/43782019?v=4"
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        //itemCount: listaConversas.length,
        itemBuilder: (context, indice){
          //Conversa conversa = listaConversas[indice];
          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            leading: CircleAvatar(
                maxRadius: 30,
                backgroundColor: Colors.grey,
                //backgroundImage: NetworkImage(conversa.caminhoFoto)
            ),
            title: Text("conversa.nome", style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 16),),
          );
        }
    );
  }
}
