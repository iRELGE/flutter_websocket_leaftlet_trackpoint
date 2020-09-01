import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:latlong/latlong.dart';
import 'data/model/localisationcar.dart';
import 'zoombuttons_plugin_option.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Web Socket Demo'),
        ),
        body: WebSocketDemo(),
      ),
    );
  }
}

class WebSocketDemo extends StatefulWidget {
  final WebSocketChannel channel =
      IOWebSocketChannel.connect('ws://localhost:1323/ws');

  @override
  _WebSocketDemoState createState() => _WebSocketDemoState(channel: channel);
}

class _WebSocketDemoState extends State<WebSocketDemo> {
  final WebSocketChannel channel;
  // MapController _mapController;
  final inputController = TextEditingController();
  List<LatLng> messageList = [];
  Localisationcar message = new Localisationcar();
  int id;
  @override
  void initState() {
    super.initState();
    // _mapController = MapController();
    if (message.longitude == null && message.latitude == null) {
      message.latitude = -6.2603;
      message.longitude = -0.09;
    }
  }

  _WebSocketDemoState({this.channel}) {
    channel.stream.listen((data) {
      var jsonString = json.decode(data);
      print(jsonString['latitude']);

      setState(() {
        message.id = jsonString['id'];
        message.latitude = jsonString['latitude'];
        message.longitude = jsonString['longitude'];
        print(message);
        var loc = Localisationcar.fromJson(jsonString);
        print(loc.latitude);
        // message.longitude =double.tryParse(jsonString['longitude']);
        messageList.add(LatLng(message.latitude, message.longitude));
        // changeToNewPosition(LatLng(message.latitude, message.longitude));
      });
    });
  }
  // void changeToNewPosition(LatLng position) {
  //   setState(() {
  //     _mapController.move(LatLng(position.latitude, position.longitude), 5.0);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('This is a map that is showing (51.5, -0.9).'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(this.message.latitude, this.message.longitude),
                  zoom: 10.0,
                  plugins: [
                    ZoomButtonsPlugin(),
                  ],
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayerOptions(markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point:
                          LatLng(this.message.latitude, this.message.longitude),
                      builder: (ctx) => Container(
                        child: Icon(Icons.blur_circular),
                      ),
                    ),
                  ]),
                  PolylineLayerOptions(
                    polylines: [
                      Polyline(
                          points: this.messageList,
                          strokeWidth: 4.0,
                          color: Colors.purple),
                    ],
                  ),
                  //PolylineLayerOptions(
                  //   polylines: [
                  //     Polyline(
                  //       points: this.messageList,
                  //       strokeWidth: 4.0,
                  //       gradientColors: [
                  //         Color(0xffE40203),
                  //         Color(0xffFEED00),
                  //         Color(0xff007E2D),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  ZoomButtonsPluginOption(
                      minZoom: 4,
                      maxZoom: 15,
                      mini: true,
                      padding: 10,
                      alignment: Alignment.bottomRight)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ListView getMessageList() {
  //   List<Widget> listWidget = [];

  //   for (String message in messageList) {
  //     listWidget.add(ListTile(
  //       title: Container(
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Text(
  //             this.message.latitude.toString(),
  //             style: TextStyle(fontSize: 22),
  //           ),
  //         ),
  //         color: Colors.teal[50],
  //         height: 60,
  //       ),
  //     ));
  //   }

  //   return ListView(children: listWidget);
  // }

  @override
  void dispose() {
    inputController.dispose();
    widget.channel.sink.close();
    super.dispose();
  }
}
