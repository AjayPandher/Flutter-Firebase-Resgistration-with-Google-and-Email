import 'package:alimento/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xff2F3C51),
        appBar: AppBar(
          title: Text('Welcome'),
          backgroundColor: Color(0xff2F3C51),
          elevation: 10.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.exit_to_app),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
              child:Text('Logged In ',style: TextStyle(fontSize: 40,color: Color(0xff29b6f6))),
            ),
          ),

        ),

    );
  }
}