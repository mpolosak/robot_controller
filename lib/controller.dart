import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:control_pad/control_pad.dart';

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
      body: OrientationBuilder(
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
}