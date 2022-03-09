class MsgModel{
  String ?msgid;
  String ?send;
  String ?text;
  bool ?seen;
  DateTime ?createon;

  MsgModel({this.msgid,this.send, this.text, this.seen, this.createon});
  MsgModel.fromMap(Map<String,dynamic>map){
    msgid=map['msgid'];
    send=map['send'];
    text=map['text'];
    seen=map['seen'];
    createon=map['createon'].toDate();

  }
  Map<String,dynamic> toMap(){
    return{
      "msgid":msgid,
      "sender":send,
      "text":text,
      "seen":seen,
      "createon":createon,


    };
  }

}