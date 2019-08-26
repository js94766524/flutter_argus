import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_argus/flutter_argus.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterArgus plugin;

  @override
  void initState() {
    super.initState();
    FlutterArgus.getInstance(project: "water").then((v) {
      setState(() {
        plugin = v;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: RaisedButton(
            child: Text("test"),
            onPressed: () => plugin?.event("test_event", params: {
              "test_event_key": "test_event_value",
            }),
          ),
        ),
      ),
    );
  }
}
