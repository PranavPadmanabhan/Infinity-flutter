import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
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
    final _scaffoldKey = GlobalKey<ScaffoldState>();


 _imgFromCamera() async {
  var image = await imagePicker.getImage(
    source: ImageSource.camera, imageQuality: 50
  )as File;

  setState(() {
    // ignore: unnecessary_null_comparison
    _image = (image==null?img:image) ;
  });
}

_imgFromGallery() async {
  var image = await  imagePicker.getImage(
      source: ImageSource.gallery, imageQuality: 50,
  ) as File;

  setState(() {
    _image = (image==null?img:image)  ;
  });
}

  void uploadImage()async{
     firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
     try {
       firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
      .ref('ProfilePics/${firebaseauth.currentUser!.uid}/')
      .putFile(_image);
       
        firebase_storage.TaskSnapshot snapshot = await task;
    print('Uploaded ${snapshot.bytesTransferred} bytes.');

    var url;
    task.whenComplete(() => {
      url = task.snapshot.ref.getDownloadURL(),
      print(url)
    });

    firebaseauth.currentUser!.updatePhotoURL(url);
        
     } catch (e) {
       _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(e.toString())));

     }
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
      key: _scaffoldKey,
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
              onTap: (){
                uploadImage();
              },
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