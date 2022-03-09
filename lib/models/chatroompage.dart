import 'package:chatapp/main.dart';
import 'package:chatapp/models/chatmodels.dart';
import 'package:chatapp/models/msgmodels.dart';
import 'package:chatapp/models/usermodels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
class ChatPage extends StatefulWidget {
  final Usermodel targetuser;
  final Usermodel user;
  final Chatmodels chatroom;
  final User firebaseuser;

  const ChatPage({Key? key, required this.targetuser, required this.user, required this.chatroom, required this.firebaseuser}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController msgcontroller=TextEditingController();

  void sendmsg()async{
    String msg=msgcontroller.text.trim();
    msgcontroller.clear();
    if(msg!=null){
      MsgModel newmsg=MsgModel(
        msgid: uuid.v1(),
        send: widget.user.uid,
        createon: DateTime.now(),
        text: msg,
        seen: false
      );
      FirebaseFirestore.instance.collection('chatrooms').doc(widget.chatroom.chatuid).collection('messages').doc(newmsg.msgid).set(
        newmsg.toMap()
      );
      print("msg send");
      widget.chatroom.lastmsg=msg;
      FirebaseFirestore.instance.collection('chatrooms').doc(
        widget.chatroom.chatuid
      ).set(widget.chatroom.toMap());

    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.targetuser.profilepic.toString()),
              backgroundColor: Colors.grey,
            ),
            SizedBox(width: 10,),
            Text(widget.targetuser.fullname.toString())
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10
                  ),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection(
                     "chatrooms"
                    ).doc(widget.chatroom.chatuid).collection(
                      'messages'
                    ).orderBy('createon',descending: true).snapshots(),
                    builder: (context,snapshot){
                      if(snapshot.connectionState==ConnectionState.active){
                        QuerySnapshot datasnapshot=snapshot.data as QuerySnapshot;
                        return ListView.builder(
                          reverse: true,
                          itemCount: datasnapshot.docs.length,
                          itemBuilder: (context,index){
                            MsgModel currentmsg=MsgModel.fromMap(datasnapshot.docs[index].data() as
                            Map<String,dynamic>);
                             return Row(
                               mainAxisAlignment: (currentmsg.send==widget.user.uid)?
                               MainAxisAlignment.start:MainAxisAlignment.end,
                               children: [
                                 Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: 2,

                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10
                                  ),
                                  decoration: BoxDecoration(
                                    color:(currentmsg.send==widget.user.uid)? Colors.blue:Colors.amberAccent,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                    child: Text
                                      ( currentmsg.text.toString(),
                                    style: TextStyle(color: Colors.black,fontSize: 15),),),

                               ],
                             );
                          },

                        );

                      }
                      else if(snapshot.hasError){
                        return Center(
                          child: Text("please check your internetconnection!"),
                        );

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
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5
                ),
                child: Row(
                  children: [
                    Flexible(
                       child: TextField(
                         controller: msgcontroller,
                         minLines: null,
                         decoration: InputDecoration(
                           hintText: "Enter message"
                         ),
                       ),

                    ),
                    IconButton(
                      onPressed: (){
                        sendmsg();
                      },
                      icon: Icon(Icons.send,color: Theme.of(context).colorScheme.secondary,),
                    )
                  ],
                ),
              )
            ],
          ),

        ),
      ),
    );
  }
}
