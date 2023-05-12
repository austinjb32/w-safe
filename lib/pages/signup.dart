import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_finance_app/pages/home_page.dart';
import 'package:flutter_finance_app/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'login_page.dart';





class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  TextEditingController _name =
  TextEditingController();
  TextEditingController _gender = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _image= TextEditingController();
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
    return SingleChildScrollView(
      child: SafeArea(
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
                          image: NetworkImage(
                              "https://images.unsplash.com/photo-1531256456869-ce942a665e80?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTI4fHxwcm9maWxlfGVufDB8fDB8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60"),
                          fit: BoxFit.cover)),
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
                            "Name",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff67727d)),
                          ),
                          TextField(
                            controller: _name,
                            cursorColor: black,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: black),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                prefixIconColor: black,
                                hintText: "Name",
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
                            "E-Mail",
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
                ),Container(
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
                            "Age",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff67727d)),
                          ),
                          TextField(
                            controller: _age,
                            cursorColor: black,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: black),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.numbers_outlined),
                                prefixIconColor: Colors.black,
                                hintText: "Age",
                                border: InputBorder.none),
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 20,),
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
                            "Gender",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff67727d)),
                          ),
                          TextField(
                            controller: _gender,
                            cursorColor: black,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: black),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_outline_outlined),
                                prefixIconColor: Colors.black,
                                hintText: "Gender",
                                border: InputBorder.none),
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 20,),
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
                            "Image Link",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff67727d)),
                          ),
                          TextField(
                            controller: _image,
                            cursorColor: black,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: black),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.link),
                                prefixIconColor: black,
                                hintText: "Link",
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
                            obscureText: true,
                            controller: _password,
                            cursorColor: black,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: black),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline_rounded),
                                prefixIconColor: Colors.black,
                                suffixIcon: Icon(Icons.remove_red_eye_outlined),
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
                            "Confirm Password",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff67727d)),
                          ),
                          TextField(
                            obscureText: true,
                            cursorColor: black,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: black),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline_rounded),
                                prefixIconColor: Colors.black,
                                suffixIcon: Icon(Icons.remove_red_eye_outlined),
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
                    FirebaseAuth _auth = FirebaseAuth.instance;
                    FirebaseFirestore _firestore = FirebaseFirestore.instance;
                    try {
                      // Call Firebase to sign in with email and password
                      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _email.text,
                        password: _password.text,
                      );

                      print("Account created Successful");

                      userCredential.user!.updateDisplayName(_name.text);

                      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
                        "name": _name.text,
                        "image":_image.text.toLowerCase(),
                        "email": _email.text,
                        "status": "Unavailable",
                        "longitude":null,
                        "latitude":null,
                        "gender":_gender.text.toLowerCase(),
                        "age":_age.text,
                        "role":"User",
                        "uid": _auth.currentUser!.uid,
                      });

                      // Navigate to the home page if sign-in is successful
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
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
                        "Sign Up",
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap:()=>{Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        )},
                        child: Text(
                          "Login",
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
          )),
    );
  }
}
