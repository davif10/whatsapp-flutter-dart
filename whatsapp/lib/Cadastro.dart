import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Usuario.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";
  
  _validarCampos(){
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    
    if(nome.isNotEmpty){
      if(email.isNotEmpty && email.contains("@")){
        if(senha.isNotEmpty && senha.length > 6){
          setState(() {
            _mensagemErro = "";
          });

          Usuario usuario = Usuario();
          usuario.nome = nome;
          usuario.email = email;
          usuario.senha = senha;
          _cadastrarUsuario(usuario);

        }else{
          setState(() {
            _mensagemErro = "Preencha a senha! Digite mais de 6 caracteres!";
          });
        }
      }else{
        setState(() {
          _mensagemErro = "Preencha o email utilizando @";
        });
      }
    }else{
      setState(() {
        _mensagemErro = "Preencha o nome";
      });
    }
  }

  _cadastrarUsuario(Usuario usuario){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser){

      //Salvando dados
      Firestore db = Firestore.instance;
      db.collection("usuarios")
      .document(firebaseUser.uid)
      .setData(usuario.toMap());

      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);

    }).catchError((error){
      setState(() {
        _mensagemErro = "Erro ao cadastrar usuário, verifique os campos e tente novamente!";
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xff075E54)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/usuario.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "E-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: ElevatedButton(
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32))),
                    onPressed: () {
                      _validarCampos();
                    },
                  ),
                ),
                Center(
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
