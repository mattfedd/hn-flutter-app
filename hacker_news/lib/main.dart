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
      theme: ThemeData.dark(),
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
  ItemProvider _itemSource = new ItemProvider(http.Client());
  Future<List<Item>> _itemFutures;

  @override
  void initState() {
    super.initState();
    _itemFutures = _itemSource.getItems(ListFilter.Top);
  }

  Future<void> _refreshData() async {
    setState(() {
      _itemFutures = _itemSource.getItems(ListFilter.Top);
    });
  }

  Widget makeListView(List<Item> itemList) {
    return RefreshIndicator(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ItemListCard(
              key: Key(index.toString()), child: itemList[index]);
        },
        itemCount: itemList.length,
      ),
      onRefresh: _refreshData,
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
          future: _itemFutures,
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
