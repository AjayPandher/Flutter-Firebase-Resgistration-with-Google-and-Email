import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color(0xff2F3C51),
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitRotatingPlain(
              color: Color(0xff29b6f6),
              size: 50.0,
            ),
            SizedBox (height: 30),
              Text('Loading...',style: TextStyle(fontSize: 30,color:Color(0xff29b6f6),),
            ),
          ],
        ),
    ),);
  }
}
