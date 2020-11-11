import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List<Text> _items = [];

  @override
  void initState() {
    super.initState();
    _getInitialStoryIds();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _getInitialStoryIds() async {
    var response =
        await http.get('https://hacker-news.firebaseio.com/v0/topstories.json');
    print('Response status: ${response.statusCode}');
    var body = jsonDecode(response.body);
    print('Response body: ${body}');

    setState(() {
      body.forEach((value) {
        _items.add(Text("${value}"));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return _items[index];
          },
          itemCount: _items.length < 25 ? _items.length : 25,
        ),
      ),
    );
  }
}
