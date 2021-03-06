import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:control_pad/control_pad.dart';
import 'package:robot_contoller/error_dialog.dart';

enum Indicators{
  none,
  left,
  right,
  emergency
}

class ControllerPage extends StatefulWidget
{
  ControllerPage(this.device);
  final BluetoothDevice device;
  @override
  _ControllerPageState createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage>
{
  BluetoothConnection _connection;
  bool _isConnecting = true;
  var _buffor = List<int>();
  int distance;
  var indicators = Indicators.none;
  @override
  void initState() {
    super.initState();
    _connect();
  }
  @override
  void dispose(){
    if(_connection != null)
    {
      _connection.dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
      ),
      body: _isConnecting
      ? Center(
          child:SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator()
          )
        )
      : OrientationBuilder(
          builder:(BuildContext context, Orientation orientation) => Flex(
            direction: orientation == Orientation.landscape ? Axis.horizontal : Axis.vertical,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      distance.toString()+' cm',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: IconButton(
                            icon: Icon(Icons.chevron_left),
                            onPressed: ()=>_switchIndicators(Indicators.left),
                            ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(MaterialCommunityIcons.hazard_lights),
                            onPressed: ()=>_switchIndicators(Indicators.emergency),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(Icons.chevron_right),
                            onPressed: ()=>_switchIndicators(Indicators.right),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ),
              Expanded(
                child: JoystickView(),
              ),
            ],
          ),
        ),
    );
  }
  void _connect() async
  {
    try{
      _connection = await BluetoothConnection.toAddress(widget.device.address);setState(() {
        _isConnecting = false;
      });
      _connection.input.listen(_onData, onDone: () async {
        await showErrorDialog(context, 'Disconnected', 'Connection ended by host');
        Navigator.of(context).pop();
      });
    }
    catch(er)
    {
      if(er is PlatformException)
      {
        await showErrorDialog(context, 'Failed to connect to device', 'Device unavailble');
        Navigator.of(context).pop();
      }
    }
  }
  void _sendData(Uint8List bytes)
  {
    try{
      _connection.output.add(bytes);
    }
    catch(er) {
      if(er is PlatformException)
      {
        showErrorDialog(context, er.code, er.message);
      }
    }
  }
  void _onData(Uint8List data){
    _buffor.addAll(data);
    while(_buffor.length>2)
    {
      switch(_buffor.removeAt(0)){
        case 100://d
          setState(() {
            distance=_buffor.removeAt(0);
          });
        break;
      }
    }
  }
  void _switchIndicators(Indicators which)
  {
    if(which==indicators)
      indicators=Indicators.none;
    else
      indicators=which;
    switch(indicators)
    {
      case Indicators.none:
        _sendData(ascii.encode('n'));
        break;
      case Indicators.left:
        _sendData(ascii.encode('l'));
        break;
      case Indicators.right:
        _sendData(ascii.encode('r'));
        break;
      case Indicators.emergency:
        _sendData(ascii.encode('e'));
        break;
    }
  }
}