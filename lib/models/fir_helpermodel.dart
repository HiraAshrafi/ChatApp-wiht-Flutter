import 'package:chatapp/models/usermodels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FirebaseHelper{
  static Future<Usermodel?>getusermodelid(String id)async{
    Usermodel?usermodel;
   DocumentSnapshot docsnap=await FirebaseFirestore.instance.collection('User').doc(id).get();
   if(docsnap.data()!=null){
     usermodel=Usermodel.fromMap(docsnap.data() as Map<String,dynamic>);
   }
   return usermodel;


  }
}