import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
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
  bool isBluetoothEnabled;
  @override
  void initState()
  {
    super.initState();
    checkBluetooth();
    FlutterBluetoothSerial.instance.onStateChanged().listen(
      (state){
        setState(() {
          isBluetoothEnabled = state.isEnabled;
        });
      }
    );
  } 
  void checkBluetooth() async
  {
    isBluetoothEnabled = await FlutterBluetoothSerial.instance.isEnabled;
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Switch(
            value: isBluetoothEnabled,
            onChanged: (value){
              if(value)
                FlutterBluetoothSerial.instance.requestEnable();
              else
                FlutterBluetoothSerial.instance.requestDisable();
            },
          ),
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
