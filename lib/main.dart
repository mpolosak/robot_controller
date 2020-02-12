import 'package:flutter/material.dart';

void main() => runApp(RobotControllerApp());

class RobotControllerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RobotController',
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

    );
  }
}
