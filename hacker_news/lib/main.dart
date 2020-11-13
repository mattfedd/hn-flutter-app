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
      theme: ThemeData.dark().copyWith(accentColor: Colors.orange),
      home: MyHomePage(title: 'HN'),
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
        title: Row(
          children: <Widget>[
            Text(widget.title),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<String>(
                style: Theme.of(context).textTheme.headline6,
                isDense: true,
                value: "Top",
                onChanged: (String newValue) {},
                items: <String>['Top', 'New', 'Jobs', 'Ask']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _refreshData,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {},
            ),
          ),
        ],
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
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
