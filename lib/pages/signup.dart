
import 'package:chatapp/models/uihelper.dart';
import 'package:chatapp/models/usermodels.dart';
import 'package:chatapp/pages/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SignUpPages extends StatefulWidget {



  @override
  _SignUpPagesState createState() => _SignUpPagesState();
}

class _SignUpPagesState extends State<SignUpPages> {
  TextEditingController _emailcontroller=TextEditingController();
  TextEditingController _passwordcontroller=TextEditingController();
  TextEditingController _conformcontroller=TextEditingController();


  //all function

  void cheakvalue(){
    String email=_emailcontroller.text.trim();
    String password=_passwordcontroller.text.trim();
    String conform=_conformcontroller.text.trim();
    if(email==""|| password=="" || conform==""){
      print('please all filed input');
      UiHelper.ShowAlert(context, 'Incomplete Data', 'please all filed input');

    }
    else if(password!=conform){
      UiHelper.ShowAlert(context, 'Password Error', "password dont't matach!");
      print("password dont't matach!");
    }
    else{
    SingUp(email, password);
    }
  }
  void SingUp(String email,String password)async{
    UserCredential?usercredential;
    UiHelper.ShowLoadingDiloge(context, 'Create a new User');
    try{
      usercredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);

    }on FirebaseAuthException catch (e){
      Navigator.pop(context);
      UiHelper.ShowAlert(context, 'An Error occuard', e.message.toString());
      print(e.code.toString());
    }
    if(usercredential!=null){
      String uid=usercredential.user!.uid;
      Usermodel newuser=Usermodel(
        uid:uid,
        email:email,
        fullname:'',
        profilepic: ''
      );
      await FirebaseFirestore.instance.collection("User").doc(uid).set
        (newuser.toMap()).then((value){
          print("new user create");
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=>Profile(usermodel: newuser,firebaseauth: usercredential!.user!)
          ));
      });
    }



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Chat APP",
                      style: TextStyle(fontSize: 45,fontWeight:FontWeight.bold,color: Theme.of(context).colorScheme.secondary)),
                  SizedBox(height: 10,),
                  TextField(
                    controller: _emailcontroller,
                    decoration: InputDecoration(
                        labelText: "User Email"
                    ),


                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: _passwordcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "User password",
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: _conformcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Conform password",
                    ),
                  ),
                  SizedBox(height: 20,),
                  CupertinoButton(
                    onPressed: (){
                      cheakvalue();

                    },
                    child: Text('Sign Up'),
                    color: Theme.of(context).colorScheme.secondary,
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          SizedBox(width: 70,),
          Text("Already Create a Account"),
          CupertinoButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text("Login"),
          )
        ],
      ),
    );
  }
}
