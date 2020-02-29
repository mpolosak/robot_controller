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
  @override
  void initState() {
    super.initState();
    BluetoothConnection.toAddress(widget.device.address).then((connection){
      _connection = connection;
      setState(() {
        _isConnecting = false;
      });
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
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.chevron_left),
                        onPressed: null,
                        ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(MaterialCommunityIcons.hazard_lights),
                        onPressed:null,
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.chevron_right),
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
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
}