
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:infinity/main.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

  final firebaseauth = FirebaseAuth.instance;

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          firebaseauth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
        },      
      ),
      body: Container(
        height: height,
        width: width,
        child: Center(child: Text("Home"),),
      ),
    );
  }
}