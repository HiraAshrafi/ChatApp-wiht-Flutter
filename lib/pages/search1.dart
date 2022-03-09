
import 'package:chatapp/main.dart';
import 'package:chatapp/models/chatmodels.dart';
import 'package:chatapp/models/chatroompage.dart';
import 'package:chatapp/models/usermodels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SearchPage extends StatefulWidget {


  final Usermodel usermodel;
  final User firebaseauth;

  const SearchPage({Key? key, required this.usermodel, required this.firebaseauth}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController = TextEditingController();
  Future<Chatmodels?> getChatroomModel(Usermodel targetUser) async{
    Chatmodels?chatRoom;


    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("chatrooms").where("participants.${widget.usermodel.uid}", isEqualTo: true).where("participants.${targetUser.uid}", isEqualTo: true).get();

    if(snapshot.docs.length>0){
      var docdata=snapshot.docs[0].data();
      Chatmodels existingchatroom=Chatmodels.fromMap(docdata as Map<String,dynamic>);
      chatRoom=existingchatroom;


      print("chat room is already created");

    }
    else{
     Chatmodels newchatmodle=Chatmodels(
       chatuid: uuid.v1(),
       lastmsg: "",
       participants: {
         widget.usermodel.uid.toString():true,
         targetUser.uid.toString():true,

       }

     );
     await FirebaseFirestore.instance.collection("chatrooms").doc(
       newchatmodle.chatuid
     ).set(newchatmodle.toMap());
     chatRoom=newchatmodle;
     print("New chat room created");

    }
    return chatRoom;


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [

              TextField(
                controller: searchController,
                decoration: InputDecoration(
                    labelText: "Email Address"
                ),
              ),

              SizedBox(height: 20,),

              CupertinoButton(
                onPressed: () {
                  setState(() {});
                },
                color: Theme.of(context).colorScheme.secondary,
                child: Text("Search"),
              ),

              SizedBox(height: 20,),

              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("User").where("email", isEqualTo: searchController.text).where("email",isNotEqualTo: widget.usermodel.email).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.active) {
                      if(snapshot.hasData) {
                        QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                        if(dataSnapshot.docs.length > 0) {
                          Map<String, dynamic> userMap = dataSnapshot.docs[0].data() as Map<String, dynamic>;

                          Usermodel searchedUser = Usermodel.fromMap(userMap);

                          return ListTile(
                            onTap: ()async{
                              Chatmodels ?chatmodels=await getChatroomModel(searchedUser);
                              if(chatmodels!=null){
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context)=>ChatPage(
                                    targetuser: searchedUser,
                                    user: widget.usermodel,
                                    firebaseuser: widget.firebaseauth,
                                    chatroom: chatmodels,
                                  )
                                ));

                              }


                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(searchedUser.profilepic!),
                              backgroundColor: Colors.grey,
                            ),



                            title: Text(searchedUser.fullname!),
                            subtitle: Text(searchedUser.email!),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          );
                        }
                        else {
                          return Text("No results found!");
                        }

                      }
                      else if(snapshot.hasError) {
                        return Text("An error occured!");
                      }
                      else {
                        return Text("No results found!");
                      }
                    }
                    else {
                      return CircularProgressIndicator();
                    }
                  }
              ),

            ],
          ),
        ),
      ),
    );
  }
}