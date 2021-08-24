
import 'dart:ui';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:infinity/components/ProfileSetup.dart';
import 'package:infinity/screens/HomeScreen.dart';
import 'package:sms_autofill/sms_autofill.dart';

void main()async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(MaterialApp(
      home: ProfileSetup(),
      debugShowCheckedModeBanner: false,
    ));
}

enum AuthState {
  MOBILE_NUMBER_ENTRY,
  OTP_ENTRY
}
// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool phoneSignin = false;
  bool otpsent = false;
  double opacity = 1;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
   late String verificationId;
  final SmsAutoFill _autoFill = SmsAutoFill();
  AuthState currentState = AuthState.MOBILE_NUMBER_ENTRY;
  final  firebaseAuth = FirebaseAuth.instance;

 verifyPhonenumber(phonenumber) async {
   await firebaseAuth.verifyPhoneNumber(
     // ignore: unnecessary_brace_in_string_interps
     phoneNumber: "+91${phonenumber}", 
     verificationCompleted: (PhoneAuthCredential credential)async{

     }, 
     verificationFailed: (verificationfailed)async{
       // ignore: deprecated_member_use
       _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(verificationfailed.message.toString())));
     }, 
     codeSent: (verificationId, resendtoken)async{
        setState(() {
          otpsent = true;
          this.verificationId = verificationId;
        });
        print("sms sent");
     }, 
     codeAutoRetrievalTimeout: (verificationId)async{

     });
}

  Future<void>signIn( smsCode)async{
     AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    await firebaseAuth.signInWithCredential(credential);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: Colors.black54,
            image: DecorationImage(
                image: AssetImage("assets/images/b1.jpg"),
                fit: BoxFit.fitHeight)),
        child: Center(
            child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Opacity(
                opacity: opacity,
                child: Container(
                  height: height * 0.35,
                  width: width,
                  child: Center(
                    child: Image(
                      image: AssetImage("assets/images/infinity.png"),
                      width: width * 0.6,
                    ),
                  ),
                ),
              ),
            ),
            
            Positioned(
              top: height * 0.28,
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: width,
                  child: Center(
                    child: Text(
                      "INFINITY",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.transparent,
                height: height * 0.65,
                width:  width ,
                child: phoneSignin?GestureDetector(
                  child: Container(
                    height: height * 0.4,
                    width: width * 0.85,
                    decoration: BoxDecoration(
                    color: Color.fromRGBO(52, 82, 105, 0.7),
                    borderRadius: BorderRadius.circular(15)
                    ),
                    margin: EdgeInsets.only(bottom: height * 0.2,left: height * 0.05,right: height * 0.05,top: 30 ),
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        Positioned(
                          top: -40,
                          left: -5,
                          child: Container(
                            width: width * 0.8,
                            height: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(child: Center(child: Image(image: AssetImage("assets/images/authentication.jpg"),width: height * 0.1,height: 100,))),
                                SizedBox(width: 5,),
                                Text("Login with Phone",style: TextStyle(
                                  color: Color.fromRGBO(250, 250, 250, 0.8),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),)
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: -10,
                          top: -10,
                          child: GestureDetector(
                            onTap: (){setState(() {
                              phoneSignin = false;
                              otpsent = false;
                            });},
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle
                              ),
                              child: Center(child: Icon(Icons.close,color: Colors.white,))),
                          ),
                        ),
                        Positioned(
                          top: height * 0.15,
                          left: width * 0.06,
                          right: width * 0.06,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 60,
                                  width: width * 0.7,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        child: otpsent?Container(
                                          width: 20,
                                        ):Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                          color: Color.fromRGBO(250, 250, 250, 0.4),
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15))
                                          ),
                                          child: Center(child: Text("+91",style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 0.8),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18
                                          ),),),                                        
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        width: width * 0.515,
                                        decoration: BoxDecoration(
                                        color: Colors.black38,
                                          borderRadius:otpsent?BorderRadius.circular(15) :BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15))
                                        ),    
                                        child: Center(
                                          child: otpsent?TextFormField(
                                            style: TextStyle(
                                              color: Colors.white
                                            ),
                                            keyboardType:TextInputType.number ,
                                            controller: _smsController,
                                            decoration: InputDecoration(
                                              hintText: " O T P",
                                              hintStyle: TextStyle(color: Colors.grey),
                                              contentPadding: EdgeInsets.only(left: 15),
                                              border: InputBorder.none,

                                            ),
                                          ):TextFormField(
                                            style: TextStyle(
                                              color: Colors.white
                                            ),
                                            keyboardType:TextInputType.number ,
                                            controller: _phoneNumberController,
                                            
                                            decoration: InputDecoration(
                                              hintText: "0 0 0 0 0 0 0 0 0 0",
                                              hintStyle: TextStyle(color: Colors.grey),
                                              contentPadding: EdgeInsets.only(left: 15),
                                              border: InputBorder.none,

                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: ()async{
                                    if(phoneSignin == true && otpsent == false){
                                      final phone = _phoneNumberController.text.trim();
                                      await verifyPhonenumber(phone);
                                      _phoneNumberController.clear();
                                    }
                                    else if(phoneSignin == true && otpsent == true){
                                      final otp = _smsController.text.trim();
                                      final smsCode = _autoFill.listenForCode;
                                      await signIn(otp);
                                      _smsController.clear();
                                      setState(() {
                                        otpsent = false;
                                        phoneSignin = false;
                                      });
                                    }
                                  },
                                  child: Container(
                                  height: 50,
                                  width: width * 0.25,
                                  margin: EdgeInsets.only(top: 20),
                                  decoration: BoxDecoration(
                                    color:  Color.fromRGBO( 255, 92, 28, 0.55),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomRight: Radius.circular(15))
                                  ),
                                  child: Center(
                                    child: Icon(Icons.arrow_forward,color: Colors.white70,size: 24,),
                                  ),
                                ),)
                              ],
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                ): Stack(
                  children: [
                    
            Positioned(
                bottom: 30,
                child: SizedBox(
                  width: width,
                  child: Center(
                    child: Container(
                      width: width * 0.85,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(150, 255, 92, 28),
                          borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Login with Google",style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                                ),),
                                
                              ],
                            ),
                          
                          ),
                    ),
                  ),
                )),
            Positioned(
              bottom: 80,
              child: SizedBox(
                width: width,
                child: Center(
                  child: GestureDetector(
                    onTap: (){ setState(() {
                      phoneSignin = true;
                    });},
                    child: Container(
                      width: width * 0.85,
                      height: 50,
                      margin: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(120, 250, 250, 250),
                          borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text("Login with Phone",style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),),
                          ),
                    ),
                  ),
                ),
              ),
            ),
            
                  ],
                ),
              ),
            )

          ],
        )),
      ),
    );
  }
}
