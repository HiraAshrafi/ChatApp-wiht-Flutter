import 'dart:io';

import 'package:chatapp/models/uihelper.dart';
import 'package:chatapp/models/usermodels.dart';
import 'package:chatapp/pages/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Profile extends StatefulWidget {
  final Usermodel usermodel;
  final User firebaseauth;

  const Profile({Key? key, required this.usermodel, required this.firebaseauth}) : super(key: key);



  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
   File ?imagefile;
  TextEditingController _fullnamecontroller=TextEditingController();

  void checkvalue(){
    String fullname=_fullnamecontroller.text.trim();
    if(fullname==""||imagefile==null){
      print("please fill all fields");
      UiHelper.ShowAlert(context, 'InComplete Data', 'Please fill all the fields');
    }
    else
      {
        print("Data is Uploading.......");
        uploadData();
      }
  }
  void uploadData()async{
    UiHelper.ShowLoadingDiloge(context, 'Loading Images');
    UploadTask uploadTask=FirebaseStorage.instance.ref("profilepictures").child(widget.usermodel.uid.toString()).putFile(imagefile!);
    TaskSnapshot snapshot=await uploadTask;
    String ?imageurl=await snapshot.ref.getDownloadURL();
    String ?fullname=_fullnamecontroller.text.trim();
    widget.usermodel.fullname=fullname;
    widget.usermodel.profilepic=imageurl;
    await FirebaseFirestore.instance.collection("User").doc(widget.usermodel.uid).set(widget.usermodel.toMap()).then((value){
      print("Data is Uploaded!");
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context)=>Homepages(usermodel: widget.usermodel, firebaseuser:widget.firebaseauth)
      ));
    });



  }

  void selectimage(ImageSource source)async{
    XFile? pickfile=await ImagePicker().pickImage(source: source);
    if(pickfile!=null){
      cropimage(pickfile);
    }




  }
  void cropimage(XFile file )async{
   File? cropimage= await ImageCropper().cropImage(
       sourcePath: file.path,
     aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
     compressQuality: 20
   );
   if(cropimage!=null){
     setState(() {
       imagefile=cropimage;
     });
   }
  }
  void showphoto(){
    showDialog(context: context, builder: (context){
      return AlertDialog(

        title: Text("upload profile picture"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: (){
                Navigator.pop(context);
                selectimage(ImageSource.gallery);
              },
              title: Text("Select from Galary"),
              leading: Icon(Icons.photo_camera_back),
            ),
            ListTile(
              onTap: (){
                Navigator.pop(context);
                selectimage(ImageSource.camera);
              },
              leading: Icon(Icons.camera_alt_outlined),
              title: Text("Select from Camra"),
            ),
          ],
        ),
      );

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              CupertinoButton(
                onPressed: (){
                  showphoto();
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage:(imagefile!=null) ?FileImage(imagefile!):null,
                  child: (imagefile==null)?Icon(Icons.person):null,
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: _fullnamecontroller,
                decoration: InputDecoration(

                  labelText: "full Name"
                ),
              ),
              SizedBox(height: 20,),
              CupertinoButton(
                onPressed: (){
                  checkvalue();
                },
                child: Text('Submit'),
                color:Theme.of(context).colorScheme.secondary,
              )
            ],
          ),
        ),
      ),
    );
  }
}
