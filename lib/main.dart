import 'package:flutter/material.dart';
import 'controller.dart';

void main() => runApp(RobotControllerApp());

class RobotControllerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robot Controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RobotControllerHomePage(title: 'Robot Controller',),
    );
  }
}

class RobotControllerHomePage extends StatefulWidget {
  RobotControllerHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RobotControllerHomePageState createState() => _RobotControllerHomePageState();
}

class _RobotControllerHomePageState extends State<RobotControllerHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.gamepad),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: ((BuildContext context) => ControllerPage('Here will be robot name'))));
            },
          ),
        ],
      ),
    );
  }
}
