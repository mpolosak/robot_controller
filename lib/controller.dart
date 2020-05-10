import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:control_pad/control_pad.dart';

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
  @override
  void initState() {
    super.initState();
    BluetoothConnection.toAddress(widget.device.address).then((connection){
      _connection = connection;
      setState(() {
        _isConnecting = false;
      });
      _connection.input.listen(_onData);
    });
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
                            onPressed: ()=>_sendData(ascii.encode('l')),
                            ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(MaterialCommunityIcons.hazard_lights),
                            onPressed: ()=>_sendData(ascii.encode('e')),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(Icons.chevron_right),
                            onPressed: ()=>_sendData(ascii.encode('r')),
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
  void _sendData(Uint8List bytes)
  {
    try{
      _connection.output.add(bytes);
    }
    catch(er) {
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
}