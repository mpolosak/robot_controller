import 'package:flutter/material.dart';

class ControllerPage extends StatefulWidget
{
  ControllerPage(this.name);
  final String name;
  @override
  _ControllerPageState createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Row(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.chevron_left), onPressed: null,),
                IconButton(icon: Icon(Icons.chevron_right), onPressed: null,),
              ],
            ),
          )
        ],
      ),
    );
  }
}