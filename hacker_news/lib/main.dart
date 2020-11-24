import 'package:flutter/material.dart';
import 'package:hacker_news/item_list.dart';
import 'package:hacker_news/item_provider.dart';
import 'package:hacker_news/settings_page.dart';

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
  ListFilter _currentFilter = ListFilter.Top;
  String _currentFilterString = "Top";

  ItemList _currentItemList;

  Map<ListFilter, ItemList> _itemLists = {
    ListFilter.Top: new ItemList(
        key: Key(ListFilter.Top.toString()), filter: ListFilter.Top),
    ListFilter.New: new ItemList(
        key: Key(ListFilter.New.toString()), filter: ListFilter.New),
    ListFilter.Best: new ItemList(
        key: Key(ListFilter.Best.toString()), filter: ListFilter.Best),
    ListFilter.Ask: new ItemList(
        key: Key(ListFilter.Ask.toString()), filter: ListFilter.Ask),
    ListFilter.Show: new ItemList(
        key: Key(ListFilter.Show.toString()), filter: ListFilter.Show),
    ListFilter.Job: new ItemList(
        key: Key(ListFilter.Job.toString()), filter: ListFilter.Job),
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentItemList = _itemLists[_currentFilter];
    });
  }

  int _refreshCount = 0;
  Future<void> _refreshData() async {
    setState(() {
      _refreshCount++;
      _itemLists[_currentFilter] = new ItemList(
          key: Key(_currentFilter.toString() + _refreshCount.toString()),
          filter: _currentFilter);
      _currentItemList = _itemLists[_currentFilter];
    });
  }

  void _changeListFilter(String newValue) {
    if (_currentFilterString == newValue) {
      return;
    }

    setState(() {
      switch (newValue) {
        case "Top":
          _currentFilter = ListFilter.Top;
          break;
        case "New":
          _currentFilter = ListFilter.New;
          break;
        case "Ask":
          _currentFilter = ListFilter.Ask;
          break;
        case "Jobs":
          _currentFilter = ListFilter.Job;
          break;
      }

      _currentFilterString = newValue;
      _currentItemList = _itemLists[_currentFilter];
    });
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
                value: _currentFilterString,
                onChanged: (String newValue) {
                  _changeListFilter(newValue);
                },
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: _currentItemList,
        ),
      ),
    );
  }
}
