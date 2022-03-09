class Chatmodels{
  String ?chatuid;
  Map<String,dynamic>?participants;
  String ?lastmsg;
  Chatmodels({this.chatuid,this.participants,this.lastmsg});



  Chatmodels.fromMap(Map<String,dynamic>map){
    chatuid=map['chatuid'];
    participants=map['participants'];
    lastmsg=map['lastmsg'];
  }
  Map<String,dynamic> toMap(){
    return{
      'chatuid':chatuid,
      'participants':participants,
      'lastmsg':lastmsg

    };
  }
}