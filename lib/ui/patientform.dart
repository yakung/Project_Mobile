import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/usermanagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientForm extends StatefulWidget {
  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _formkey =GlobalKey<FormState>();
  TextEditingController emailcontrol =TextEditingController();
  TextEditingController passcontrol =TextEditingController();
  TextEditingController passconfcontrol =TextEditingController();
  TextEditingController name =TextEditingController();
  TextEditingController symptom =TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

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
                  IconButton(
                    icon: Icon(Icons.accessibility),
                    onPressed: () {
                      Firestore.instance.collection('/Doctor');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.pan_tool),
                    onPressed: () {
                      Firestore.instance.collection('/Pantial');
                    },)
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
                decoration:InputDecoration(labelText: "Symptom"),
                controller: symptom,
                validator: (value){
                  if(value.isEmpty) return "Symptom is required";
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
                              Firestore.instance.collection('/users').add({
                                'email': user.email,
                                'uid': user.uid,
                                'role': "Patient",
                                'Name': name.text,
                                'Symptom': symptom.text
                              }).then((value) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacementNamed('/homepage');
                              }).catchError((e) {
                                print(e);
                              });                   
                          }).catchError((e) {
                            print(e);
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