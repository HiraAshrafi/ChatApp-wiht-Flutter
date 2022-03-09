import 'package:chatapp/models/chatmodels.dart';
import 'package:chatapp/models/chatroompage.dart';
import 'package:chatapp/models/fir_helpermodel.dart';
import 'package:chatapp/models/uihelper.dart';
import 'package:chatapp/models/usermodels.dart';
import 'package:chatapp/pages/loginpage.dart';
import 'package:chatapp/pages/search1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homepages extends StatefulWidget {
  final Usermodel usermodel;
  final User firebaseuser;

  const Homepages({Key? key, required this.usermodel, required this.firebaseuser}) : super(key: key);




  @override
  _HomepagesState createState() => _HomepagesState();
}

class _HomepagesState extends State<Homepages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: ()async{
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=>Login()
              ));
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
        centerTitle: true,
        title: Text("Chat APP"),
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection(
                'chatrooms').where(
                'participants.${widget.usermodel.uid}',isEqualTo: true).snapshots(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.active){
                if(snapshot.hasData){
                  QuerySnapshot chatRoomsnapshot=snapshot.data as QuerySnapshot;
                  return ListView.builder(
                    itemCount: chatRoomsnapshot.docs.length,
                    itemBuilder: (context,index){
                      Chatmodels chatmodels=Chatmodels.fromMap(
                        chatRoomsnapshot.docs[index].data() as Map<String,dynamic>

                      );
                      Map<String,dynamic> participants=chatmodels.participants!;
                      List<String>participantskey=participants.keys.toList();
                      participantskey.remove(widget.usermodel.uid);
                      return FutureBuilder(
                        future: FirebaseHelper.getusermodelid(participantskey[0]),
                        builder: (context,userData){
                          if(userData.connectionState==ConnectionState.done){
                            if(userData!=null){
                              Usermodel targetuser=userData.data as Usermodel;
                              return ListTile(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context)=>ChatPage(
                                      chatroom: chatmodels,
                                      firebaseuser: widget.firebaseuser,
                                      user: widget.usermodel,
                                      targetuser: targetuser,
                                    )
                                  ));
                                },
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(targetuser.profilepic.toString()),

                                ),
                                title: Text(
                                    targetuser.fullname.toString()
                                ),
                                subtitle:(chatmodels.lastmsg.toString()!="")? Text(
                                    chatmodels.lastmsg.toString()
                                ):Text("Say hi to your new friends")

                              );


                            }
                            else{
                              return Container();
                            }

                          }
                          else
                            {
                              return Container();
                            }


                        },
                      );
                    },
                  );

                }
                else if(snapshot.hasError){
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );


                }
                else{
                  return Center(
                    child: Text("no chat found!"),
                  );
                }

              }
              else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),


        ),



      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          Navigator.push(context, MaterialPageRoute(
            builder: (context)=>SearchPage(usermodel: widget.usermodel,firebaseauth: widget.firebaseuser)
          ));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
