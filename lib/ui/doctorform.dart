import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorForm extends StatefulWidget {
  @override
  _DoctorFormState createState() => _DoctorFormState();
}

class _DoctorFormState extends State<DoctorForm> {
  final _formkey =GlobalKey<FormState>();
  TextEditingController emailcontrol =TextEditingController();
  TextEditingController passcontrol =TextEditingController();
  TextEditingController passconfcontrol =TextEditingController();
  TextEditingController name =TextEditingController();
  TextEditingController department =TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  File sampleImage;
 
  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
 
    setState(() {
      sampleImage = tempImage;
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register New Account"),
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.add_a_photo), onPressed: () {
                    getImage();
                  },
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                controller: emailcontrol,
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if(value.isEmpty) return "Email is required";
                }
              ),
              TextFormField(
                decoration:InputDecoration(labelText: "Password"),
                obscureText: true,
                controller: passcontrol,
                validator: (value){
                  if(value.isEmpty) return "Password is required";
                  else if(value.length < 8) return "Password much more than 8";
                }
              ),
              TextFormField(
                decoration:InputDecoration(labelText: "Password"),
                obscureText: true,
                controller: passconfcontrol,
                validator: (value){
                  if(value.isEmpty) return "Password is required";
                  else if(passcontrol.text != passconfcontrol.text) return "Password Not Same";
                }
              ),
              TextFormField(
                decoration:InputDecoration(labelText: "Name"),

                controller: name,
                validator: (value){
                  if(value.isEmpty) return "Name is required";
                }
              ),
              TextFormField(
                decoration:InputDecoration(labelText: "Department"),

                controller: department,
                validator: (value){
                  if(value.isEmpty) return "Department is required";
                }
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      child: Text("Register"),
                      onPressed: () {
                            auth.createUserWithEmailAndPassword(
                            email: emailcontrol.text, password: passcontrol.text).then((user) {
                              Firestore.instance.collection('/users').document(user.uid).setData({
                                'email': user.email,
                                'uid': user.uid,
                                'role': "Doctor",
                                'Name': name.text,
                                'Department': department.text,
                                'Photourl':'https://firebasestorage.googleapis.com/v0/b/projecmobile-ab028.appspot.com/o/test.jpg?alt=media&token=55aafcc7-dd2c-4754-84c9-d24adad591d1'
                              }).then((value) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacementNamed('/home');
                              }).catchError((e) {
                                print(e);
                              });                                           
                        });                  
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}

