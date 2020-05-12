import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future showErrorDialog(BuildContext context, String title, String errorMessage, {bool fatal=false})
{
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(errorMessage),
        actions: <Widget>[
          fatal?
            FlatButton(
              child: Text('Close app'),
              onPressed: () {
                SystemNavigator.pop();
              },
            )
          :
          FlatButton(
            child: Text('Ok'),
            onPressed: (){
              Navigator.of(context).pop();
            }
          )
        ],
      );
    }
  );
}