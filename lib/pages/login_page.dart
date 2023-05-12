import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_finance_app/pages/home_page.dart';
import 'package:flutter_finance_app/pages/signup.dart';
import 'package:flutter_finance_app/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  TextEditingController _email =
      TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    bool _obscureText = false;
    return SafeArea(
        child: Center(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image:AssetImage('lib/assets/images/queen.png')
                    ,fit: BoxFit.cover)),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: grey.withOpacity(0.03),
                      spreadRadius: 10,
                      blurRadius: 3,
                      // changes position of shadow
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 15, bottom: 5, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email Address",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Color(0xff67727d)),
                    ),
                    TextField(
                      controller: _email,
                      cursorColor: black,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: black),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          prefixIconColor: black,
                          hintText: "Email",
                          border: InputBorder.none),
                    ),
                  ],
                ),
              )),
          SizedBox(
            height: 20,
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: grey.withOpacity(0.03),
                      spreadRadius: 10,
                      blurRadius: 3,
                      // changes position of shadow
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 15, bottom: 5, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Password",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Color(0xff67727d)),
                    ),
                    TextField(
                      obscureText: _obscureText,
                      controller: _password,
                      cursorColor: black,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: black),
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          prefixIconColor: Colors.black,
                          suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                          suffixIconColor: Colors.black,
                          hintText: "Password",
                          border: InputBorder.none),
                    ),
                  ],
                ),
              )),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              try {
                // Call Firebase to sign in with email and password
                UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: _email.text.trim(),
                  password: _password.text,
                );

                // Navigate to the home page if sign-in is successful
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  print('Wrong password provided for that user.');
                }
              } catch (e) {
                print(e);
              }
            },
            child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                  color: buttoncolor, borderRadius: BorderRadius.circular(25)),
              child: Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26.0, right: 26.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap:()=>{Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                  )},
                  child: Text(
                    "Signup",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
