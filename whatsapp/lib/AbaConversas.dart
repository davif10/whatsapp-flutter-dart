import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Usuario.dart';

class AbaConversas extends StatefulWidget {
  @override
  _AbaConversasState createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore db = Firestore.instance;
  String _idUsuarioLogado;
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  Stream<QuerySnapshot> _adicionarListenerConversas() {
    final stream = db
        .collection("conversas")
        .document(_idUsuarioLogado)
        .collection("ultima_conversa")
        .snapshots();
    _subscription = stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    _adicionarListenerConversas();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: [
                    Text("Carregando conversas"),
                    CircularProgressIndicator()
                  ],
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text("Erro ao carregar os dados!");
              } else {
                QuerySnapshot querySnapshot = snapshot.data;
                List<DocumentSnapshot> conversas = [];
                if (querySnapshot.documents.length == 0) {
                  return Center(
                    child: Text(
                      "Carregando conversas",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                }else{
                  conversas = querySnapshot.documents.toList();
                }
                return ListView.builder(
                    itemCount: conversas.length,
                    itemBuilder: (context, indice) {
                      DocumentSnapshot item = conversas[indice];
                      String urlImagem = item["caminhoFoto"];
                      //String tipo = item["tipoMensagem"];
                      String mensagem = item["mensagem"];
                      String nome = item["nome"];
                      String idDestinatario = item["idDestinatario"];

                      Usuario usuario = Usuario();
                      usuario.nome = nome;
                      usuario.urlImagem = urlImagem;
                      usuario.idUsuario = idDestinatario;

                      return ListTile(
                        onTap: (){
                          Navigator.pushNamed(context, "/mensagens", arguments: usuario);
                        },
                        contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        leading: CircleAvatar(
                            maxRadius: 30,
                            backgroundColor: Colors.grey,
                            backgroundImage: urlImagem != null
                                ? NetworkImage(urlImagem)
                                : null),
                        title: Text(
                          nome,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          mensagem,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      );
                    });
              }
          }
        });
  }
}
