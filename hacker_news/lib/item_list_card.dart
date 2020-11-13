import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hacker_news/item.dart';

import 'package:url_launcher/url_launcher.dart';

class ItemListCard extends StatelessWidget {
  final Item child;

  const ItemListCard({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 0.000),
      padding: EdgeInsets.symmetric(vertical: 1.0),
      child: Material(
        color: Theme.of(context).primaryColorDark,
        child: InkWell(
          onTap: () => child.url != null ? _launchURL(child.url) : {},
          child: Container(
            constraints: BoxConstraints(minHeight: 48),
            margin: EdgeInsets.symmetric(vertical: 4.0),
            padding: EdgeInsets.symmetric(vertical: 4.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                child.descendants != null
                    ? Column(
                        children: <Widget>[
                          _buildScoreTextDisplay(),
                          _buildCommentTextDisplay(),
                        ],
                      )
                    : _buildScoreTextDisplay(),
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            child.title ?? "",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
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
                            Text(" - "),
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
                          child: Text(
                            child.url ?? "",
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
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
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildScoreTextDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      margin: EdgeInsets.only(left: 3.0),
      width: 50,
      alignment: Alignment.center,
      child: Text(
        '${child.score}',
        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCommentTextDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      margin: EdgeInsets.only(left: 3.0),
      width: 50,
      alignment: Alignment.center,
      child: Text('${child.descendants}'),
    );
  }

  // TODO: move this into a utility file as a static function or something.
  // TODO: add tests
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
