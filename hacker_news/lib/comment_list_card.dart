import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hacker_news/comments_page.dart';
import 'package:hacker_news/item.dart';

import 'package:url_launcher/url_launcher.dart';

class CommentListCard extends StatelessWidget {
  final Item child;
  final int depth;

  const CommentListCard({Key key, this.child, this.depth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.0),
      child: Material(
        color: Theme.of(context).primaryColorDark,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildDepthMarkers(context),
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              child.by != null ? "by ${child.by}" : "",
                              style: Theme.of(context).textTheme.caption,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                          Text(" · "),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              child.time != null
                                  ? howLongAgo(
                                      DateTime.now().toUtc(), child.time)
                                  : "",
                              style: Theme.of(context).textTheme.caption,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          child.text ?? "",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDepthMarkers(BuildContext context) {
    if (depth > 1) {
      return Container(width: 1, color: Colors.red, child: Text("${depth}"));
    } else {
      return Container();
    }
  }

  String howLongAgo(DateTime now, DateTime then) {
    if (now.isBefore(then)) {
      // problemo: should not be this way
      return "";
    }

    var difference = now.difference(then);

    if (difference.inDays >= 1) {
      return "${difference.inDays}d ago";
    }

    if (difference.inHours >= 1) {
      return "${difference.inHours}h ago";
    }

    if (difference.inMinutes >= 1) {
      return "${difference.inMinutes}m ago";
    }

    if (difference.inSeconds >= 1) {
      return "${difference.inSeconds}s ago";
    }

    return "just now";
  }
}
