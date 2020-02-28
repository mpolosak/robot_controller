import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  bool isBluetoothEnabled = false;
  var results = List<BluetoothDiscoveryResult>();
  bool isDiscovering = false;
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
        turnDiscovering();
      }
    );
  } 
  void checkBluetooth() async
  {
    isBluetoothEnabled = await FlutterBluetoothSerial.instance.isEnabled;
    setState(() {
    });
    turnDiscovering();
  }

  void turnDiscovering()
  {
    setState((){
      results.clear();
    });
    if(isBluetoothEnabled){
      setState(() {
        isDiscovering = true;
      });
      _streamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen((r){
        setState((){
          results.add(r);
        });
      });
      _streamSubscription.onDone((){
        setState(() {
          isDiscovering = false;
        });
      });
    }
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
      body: ListView.separated(
        itemBuilder: (context, index){
          var result = results[index];
          return ListTile(
            title: Text(result.device.name),
            subtitle: Text(result.device.type.stringValue),
            trailing: result.device.isBonded
            ? Icon(Icons.link)
            : null,
            onTap: result.device.isBonded
            ?  ()=>null
            : () async {
              try{
                var bonded = await FlutterBluetoothSerial.instance.bondDeviceAtAddress(result.device.address);
                if(bonded){
                  setState(() {
                    results[index] = BluetoothDiscoveryResult(
                      device: BluetoothDevice(
                        name: result.device.name,
                        address: result.device.address,
                        type: result.device.type,
                        bondState: BluetoothBondState.bonded,
                      ), 
                      rssi: result.rssi
                    );
                  });
                }
              } catch(er){
                  if(er is PlatformException){
                    print(er.code+' '+er.message);
                  }
              }
            }
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: results.length,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(5),
          height: 50,
          child: isDiscovering
          ? AspectRatio(
            aspectRatio: 1,
            child:CircularProgressIndicator()
          )
          : IconButton(
            icon: Icon(Icons.bluetooth_searching), 
            onPressed: turnDiscovering,
          ),
        ),
      ),
    );
  }
}
