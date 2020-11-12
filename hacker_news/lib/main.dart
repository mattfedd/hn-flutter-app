import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hacker_news/item.dart';
import 'package:hacker_news/item_list_card.dart';
import 'package:hacker_news/item_provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News Reader',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Hacker News'),
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

  ItemProvider itemSource = new ItemProvider(http.Client());
  Future<List<Item>> itemFutures;

  @override
  void initState() {
    super.initState();
    itemFutures = itemSource.getItems(ListFilter.Top);
    // _getInitialStoryIds();
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

  Widget makeListView(List<Item> itemList) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ItemListCard(key: Key(index.toString()), child: itemList[index]);
      },
      itemCount: itemList.length < 25 ? itemList.length : 25,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Item>>(
          future: itemFutures, // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
            if (snapshot.hasData) {
              return makeListView(snapshot.data);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Text('Awaiting result...');
            }
          },
        ),
      ),
    );
  }
}
