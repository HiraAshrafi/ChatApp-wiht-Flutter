
import 'package:chatapp/models/uihelper.dart';
import 'package:chatapp/models/usermodels.dart';
import 'package:chatapp/pages/homepage.dart';
import 'package:chatapp/pages/profile.dart';
import 'package:chatapp/pages/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailcontroller1=TextEditingController();
  TextEditingController _passwordcontroller1=TextEditingController();

  void checkvalue(){
    String email=_emailcontroller1.text.trim();
    String password=_passwordcontroller1.text.trim();
    if(email==""|| password==""){
      UiHelper.ShowAlert(context, "Incomplete Data", "please fill all the field");
    }
    else{
      login(email, password);

    }
  }

  void login(String email,String password)async{
    UserCredential?usercrendtial;
    UiHelper.ShowLoadingDiloge(context, "loggin...");
    try{
      usercrendtial=await FirebaseAuth.instance.signInWithEmailAndPassword
        (email: email, password: password);


    }on FirebaseAuthException catch(e){
      Navigator.pop(context);
      UiHelper.ShowAlert(context, "An error occured", e.message.toString());
      print(e.message.toString());
    }
    if(usercrendtial!=null){
      String uid=usercrendtial.user!.uid;
      DocumentSnapshot userdata=await FirebaseFirestore.instance.collection('User').doc(uid).get();
      Usermodel usermodel=Usermodel.fromMap(userdata.data() as
      Map<String ,dynamic>);
      print("Login Successfull");
      Navigator.popUntil(context, (route) =>route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context)=>Homepages(usermodel: usermodel,firebaseuser: usercrendtial!.user!,)
      ));
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
                    controller: _emailcontroller1,
                    decoration: InputDecoration(
                      labelText: "User Email"
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: _passwordcontroller1,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "User password",
                    ),
                  ),
                  SizedBox(height: 20,),
                  CupertinoButton(
                    onPressed: (){
                      checkvalue();

                    },
                    child: Text('Log In'),
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
          Text("Don't have a Account?"),
          CupertinoButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context)=>SignUpPages()
              ));


            },
            child: Text("Sign Up"),
          )
        ],
      ),
    );
  }
}
