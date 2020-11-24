import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hacker_news/item.dart';
import 'package:hacker_news/item_list_card.dart';
import 'package:hacker_news/item_provider.dart';
import 'package:http/http.dart' as http;

class ItemList extends StatefulWidget {
  ItemList({Key key, this.filter}) : super(key: key);
  final ListFilter filter;

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final ItemProvider _source = ItemProvider(http.Client());

  final ScrollController _scrollController = new ScrollController();

  List<Future<List<Item>>> _pageCache = [];

  void refreshCallback() {}

  Future<List<Item>> _fetchPage(int pageIndex, int pageSize) async {
    if (_pageCache.length > pageIndex) {
      return _pageCache[pageIndex];
    }

    int lo = pageIndex * pageSize;
    int hi = lo + pageSize;
    _pageCache.insert(
        pageIndex, _source.getItemsInRange(widget.filter, lo, hi));
    return _pageCache[pageIndex];
  }

  Widget _buildPage(List page) {
    return ListView(
        shrinkWrap: true,
        primary: false,
        children: page.map((card) => ItemListCard(child: card)).toList());
  }

  @override
  Widget build(BuildContext context) {
    print("building item list for filter ${widget.filter}");
    return ListView.builder(
      controller: _scrollController,
      itemCount: (500 / 20).round() + 1,
      itemBuilder: (context, pageNumber) {
        return pageNumber > (500 / 20).round() - 1
            ? _buildEndTile(context)
            : FutureBuilder<List<Item>>(
                future: _fetchPage(pageNumber, 20),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
                  if (snapshot.hasData) {
                    return _buildPage(snapshot.data);
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}',
                        style: Theme.of(context).textTheme.headline4);
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: CircularProgressIndicator()),
                      ),
                    );
                  }
                },
              );
      },
    );
  }

  Widget _buildEndTile(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "You've reached the end! \n",
                style: Theme.of(context).textTheme.button,
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Back to the top?',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _scrollController.animateTo(0.0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
