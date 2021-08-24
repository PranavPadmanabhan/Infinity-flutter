import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({ Key? key }) : super(key: key);

  @override
  _ProfileSetupState createState() => _ProfileSetupState();
}
   
   final firebaseauth = FirebaseAuth.instance;
   final imagePicker = ImagePicker(); 



class _ProfileSetupState extends State<ProfileSetup> {
  

// ignore: unused_field
late File _image;
   File img = File("assets/images/default.png");
    var def = "https://www.computerhope.com/jargon/g/guest-user.jpg";


 _imgFromCamera() async {
  var image = await imagePicker.pickImage(
    source: ImageSource.camera, imageQuality: 50
  );

  setState(() {
    _image = (image==null?img:image) as File;
  });
}

_imgFromGallery() async {
  var image = await  imagePicker.pickImage(
      source: ImageSource.gallery, imageQuality: 50
  );

  setState(() {
    _image = (image==null?img:image)  as File;
  });
}


  void _showPicker(context) {
  showModalBottomSheet( 
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Gallery'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
}

  @override

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:100),
              child: GestureDetector(
                onTap:(){_showPicker(context);},
                child: CircleAvatar(
                  
                  radius: 100,
                  child: Center(child: Image(fit: BoxFit.cover,image:NetworkImage((firebaseauth.currentUser ==null?def:firebaseauth.currentUser!.photoURL).toString()))),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              width: width * 0.9,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  hintStyle: TextStyle(
                    color: Colors.grey
                  )
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(top: 50),
                width: width * 0.4,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Center(
                  child: Text("Save",style: TextStyle(
                    color: Colors.white
                  ),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}