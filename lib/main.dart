import 'package:chatapp/models/fir_helpermodel.dart';
import 'package:chatapp/models/usermodels.dart';
import 'package:chatapp/pages/homepage.dart';
import 'package:chatapp/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
var uuid=Uuid();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? currentUser = FirebaseAuth.instance.currentUser;
  if(currentUser != null) {
    // Logged In
    Usermodel? thisUserModel = await FirebaseHelper.getusermodelid(currentUser.uid);
    if(thisUserModel != null) {
      runApp( MyappLogin(usermodel: thisUserModel,firebase: currentUser,));
    }
    else {
      runApp(Myapp());
    }
  }
  else {
    // Not logged in
    runApp(Myapp());
  }
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Login(),
    );
  }
}


class MyappLogin extends StatelessWidget {
  final Usermodel usermodel;
  final User firebase;

  const MyappLogin({Key? key, required this.usermodel, required this.firebase}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepages(usermodel: usermodel,firebaseuser: firebase,),
    );
  }
}
