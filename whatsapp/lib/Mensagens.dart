import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Mensagem.dart';

import 'model/Usuario.dart';

class Mensagens extends StatefulWidget {
  Usuario contato;
  Mensagens(this.contato);
  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  List<String> listaMensagens = [
    "Olá tudo bem?",
    "Tudo bem e você?",
  ];
  TextEditingController _controllerMensagem = TextEditingController();
  String _idUsuarioLogado;
  String _idUsuarioDestinatario;

  _enviarMensagem(){
    String textoMensagem = _controllerMensagem.text;
    if(textoMensagem.isNotEmpty){
      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _idUsuarioLogado;
      mensagem.mensagem = textoMensagem;
      mensagem.urlImagem = "";
      mensagem.tipo = "texto";

      _salvarMensagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);
    }
  }

  _salvarMensagem(String idRemetente, String idDestinatario, Mensagem msg) async{
    Firestore db = Firestore.instance;

    await db.collection("mensagens")
    .document(idRemetente)
    .collection(idDestinatario)
    .add(msg.toMap());

    //Limpa texto
    _controllerMensagem.clear();
  }
  _enviarFoto(){

  }

  _recuperarDadosUsuario() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
    _idUsuarioDestinatario = widget.contato.idUsuario;
  }
  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    var caixaMensagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextField(
                controller: _controllerMensagem,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                    hintText: "Digite uma mensagem...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: _enviarFoto,
                  )
                ),
              ),
            ),
          ),
          FloatingActionButton(
              backgroundColor: Color(0xff075E54),
              child: Icon(Icons.send, color: Colors.white,),
              onPressed: _enviarMensagem,
          )
        ],
      ),
    );

    var listView = Expanded(
      child: ListView.builder(
          itemCount: listaMensagens.length,
          itemBuilder: (context, indice){
            double larguraContainer = MediaQuery.of(context).size.width * 0.8;


            Alignment alinhamento = Alignment.centerRight;
            Color cor = Color(0xffd2ffa5);
            if(indice % 2 == 0){
              cor = Colors.white;
              alinhamento = Alignment.centerLeft;
            }

              return Align(
                alignment: alinhamento,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    width: larguraContainer,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cor,
                      borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                    child: Text(listaMensagens[indice],
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              );
          }),
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              maxRadius: 20,
              backgroundImage:
              widget.contato.urlImagem != null
                  ? NetworkImage(widget.contato.urlImagem)
                  : null,
              backgroundColor: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(widget.contato.nome),
            ),
          ],
        )
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("imagens/bg.png"),
            fit: BoxFit.cover
          )
        ),
        child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  listView,
                  caixaMensagem,
                ],
              ),
            )
        ),
      ),
    );
  }
}
