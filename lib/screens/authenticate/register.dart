import 'dart:ui';

import 'package:alimento/services/auth.dart';
import 'package:alimento/shared/constants.dart';
import 'package:alimento/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  AnimationController _controller2;
  Animation<Offset> _offsetAnimation2;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String name = '';
  bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..forward();
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutExpo,
    ));
    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
    _offsetAnimation2 = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeOutExpo),
    );
  }

  ///////////////////////////////////////////
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff2F3C51),
              elevation: 0.0,
              actions: <Widget>[],
            ),
            body: Container(
              height: double.infinity,
              decoration: BoxDecoration(color: Color(0xff2F3C51)),
              // height: size.height,
              child: SingleChildScrollView(
                // new lin
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        SlideTransition(
                          position: _offsetAnimation,
                          child: FlutterLogo(size: 200.0),
                        ),

                        SizedBox(height: 20.0),
                        SlideTransition(
                          position: _offsetAnimation,
                          child: Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        //--------------------------------------------------------//
                        Divider(thickness: 1, indent: 40, endIndent: 40),
//--------------------------------------------------------//
                        SizedBox(height: 60.0),

                        SlideTransition(
                            position: _offsetAnimation2,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  decoration: textInputDecoration.copyWith(
                                    labelText: 'Name',
                                    prefixIcon: Icon(Icons.perm_identity),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter Your name' : null,
                                  onChanged: (val) {
                                    setState(() => name = val);
                                  },
                                ),
                                SizedBox(height: 15.0),
                                TextFormField(
                                  decoration: textInputDecoration.copyWith(
                                    labelText: 'email',
                                    prefixIcon: Icon(Icons.mail_outline),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter an email' : null,
                                  onChanged: (val) {
                                    setState(() => email = val);
                                  },
                                ),
                                SizedBox(height: 15.0),
                                TextFormField(
                                  obscureText: !_passwordVisible,
                                  decoration: textInputDecoration.copyWith(
                                    labelText: 'password',
                                    prefixIcon: Icon(Icons.lock_outline),
                                    suffixIcon: GestureDetector(
                                      onLongPress: () {
                                        setState(() {
                                          _passwordVisible = true;
                                        });
                                      },
                                      onLongPressUp: () {
                                        setState(() {
                                          _passwordVisible = false;
                                        });
                                      },
                                      child: Icon(_passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
                                  ),
                                  validator: (val) => val.length < 6
                                      ? ('Enter a password 6+ chars long')
                                      : null,
                                  onChanged: (val) {
                                    setState(() => password = val);
                                  },
                                ),
                                SizedBox(height: 50.0),
                                RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(80.0)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          gradient: RadialGradient(
                                              colors: [
                                                Color(0xff29b6f6),
                                                Color(0xff01579b)
                                              ],
                                              radius: 7,
                                              tileMode: TileMode.mirror
                                              //tileMode: TileMode.mirror,
                                              ),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Container(
                                          constraints: BoxConstraints(
                                              minWidth: 417, minHeight: 50.0),
                                          child: Center(
                                              child: Text(
                                            "Register",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ))),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() => loading = true);
                                        dynamic result = await _auth
                                            .registerWithEmailAndPassword(
                                                email, password);
                                        if (result == null) {
                                          setState(() {
                                            loading = false;
                                            error =
                                                'Please supply a valid email';
                                          });
                                        }
                                      }
                                    }),
                                SizedBox(height: 12.0),
                                Text(
                                  error,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0),
                                ),
                                SizedBox(height: 30.0),
                                FlatButton(
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Already have an account?',
                                      style: TextStyle(color: Colors.white),
                                      /*defining default style is optional */
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: ' SignIn now',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  color: Color(0xff2F3C51),
                                  onPressed: () => widget.toggleView(),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
