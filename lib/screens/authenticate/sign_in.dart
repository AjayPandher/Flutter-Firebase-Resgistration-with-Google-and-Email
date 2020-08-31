import 'dart:ui';
import 'package:alimento/services/Googleauth.dart';
import 'package:alimento/screens/home/home.dart';
import 'package:alimento/services/auth.dart';
import 'package:alimento/shared/constants.dart';
import 'package:alimento/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin {
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

  bool _passwordVisible;

//googleeee////////////////////
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool isLoading = false;

  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    this.setState(() {
      isLoading = false;
    });
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false);
  }

  Future<User> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final User firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;
    print("signed in " + firebaseUser.displayName);

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        FirebaseFirestore.instance.collection('users');
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
    return firebaseUser;
  }

  ////////////////////////////
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
/////////////////////////////////////////////////////
    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
    _offsetAnimation2 = Tween<Offset>(
      begin: const Offset(0, 1.5),
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
              title: SlideTransition(
                position: _offsetAnimation2,
              ),
              actions: <Widget>[],
            ),
            body: Container(
              height: double.infinity,
              decoration: BoxDecoration(color: Color(0xff2F3C51)),
              // height: size.height,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),

                // new lin
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
                        //--------------------------------------------------------//

                        SizedBox(height: 20.0),
                        SlideTransition(
                          position: _offsetAnimation,
                          child: Text(
                            "Sign In",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        //--------------------------------------------------------//
                        Divider(thickness: 1, indent: 40, endIndent: 40),
                        SizedBox(height: 60.0),
                        SlideTransition(
                          position: _offsetAnimation2,
                          child: Column(
                            children: <Widget>[
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
                                        ? (Icons.visibility)
                                        : Icons.visibility_off),
                                  ),
                                ),
                                validator: (val) => val.length < 6
                                    ? 'Enter a password 6+ chars long'
                                    : null,
                                onChanged: (val) {
                                  setState(() => password = val);
                                },
                              ),
                              SizedBox(height: 50.0),
                              Container(
                                child: RaisedButton(
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
                                              tileMode: TileMode.mirror),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Container(
                                          constraints: BoxConstraints(
                                              minWidth: 417, minHeight: 45.0),
                                          child: Center(
                                              child: Text(
                                            "Sign In",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ))),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() => loading = true);
                                        dynamic result = await _auth
                                            .signInWithEmailAndPassword(
                                                email, password);
                                        if (result == null) {
                                          setState(() {
                                            loading = false;
                                            error =
                                                'Incorrect Email or Password';
                                          });
                                        }
                                      }
                                    }),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: double.maxFinite,
                                child: GoogleSignInButton(
                                  borderRadius: 10,
                                  //darkMode: true,
                                  onPressed: _handleSignIn,
                                ),
                              ),
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
                                    text: 'Don\'t have an account?',
                                    style: TextStyle(color: Colors.white),
                                    /*defining default style is optional */
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: ' SignUp now',
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
