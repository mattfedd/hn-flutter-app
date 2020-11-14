import 'package:flutter/material.dart';
import 'package:hacker_news/comment_list_card.dart';
import 'package:hacker_news/comments_provider.dart';
import 'package:hacker_news/item.dart';
import 'package:hacker_news/item_list_card.dart';
import 'package:hacker_news/item_provider.dart';
import 'package:http/http.dart' as http;

class CommentsPage extends StatefulWidget {
  CommentsPage({Key key, this.parentItem}) : super(key: key);
  final Item parentItem;

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  CommentsProvider _commentSource =
      CommentsProvider(ItemProvider(http.Client()));
  Future<List<WithDepth<Item>>> _commentFutures;

  @override
  void initState() {
    super.initState();
    _commentFutures = _commentSource.getAllComments(widget.parentItem.id, 10);
  }

  Future<void> _refreshData() async {
    setState(() {
      _commentFutures = _commentSource.getAllComments(widget.parentItem.id, 10);
    });
  }

  Widget makeListView(List<WithDepth<Item>> itemList) {
    return RefreshIndicator(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return CommentListCard(
            key: Key(index.toString()),
            child: itemList[index].value,
            depth: itemList[index].depth,
          );
        },
        itemCount: itemList.length,
      ),
      onRefresh: _refreshData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<WithDepth<Item>>>(
        future: _commentFutures,
        builder: (BuildContext context,
            AsyncSnapshot<List<WithDepth<Item>>> snapshot) {
          if (snapshot.hasData) {
            return makeListView(snapshot.data);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}',
                style: Theme.of(context).textTheme.headline4);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
