import 'package:flutter/material.dart';

class UiHelper{
  static void ShowLoadingDiloge(BuildContext context, String title){
    AlertDialog loading=AlertDialog(
      content: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 30,),
            Text(title)
          ],
        ),
      ),

    );
    showDialog(
      barrierDismissible: false,
        context: context,builder: (context){
          return loading;
  }

    );

  }
  static void ShowAlert(BuildContext context,String title,String content){
    AlertDialog alertDialog=AlertDialog(

      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        },
        child: Text("ok"),)
      ],

    );

    showDialog(
      context: context,
      builder: (context){
        return alertDialog;
      }
    );

  }
}