import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hacker_news/item.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentListCard extends StatelessWidget {
  final Item child;
  final int depth;

  const CommentListCard({Key key, this.child, this.depth}) : super(key: key);

  Color _depthToColor(int val) {
    List<Color> colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.teal,
      Colors.purple,
      Colors.pink,
    ];
    int index = (val - 2) % colors.length;
    return colors[index];
  }

  final int depthBarWidth = 2;

  @override
  Widget build(BuildContext context) {
    return Material(
      textStyle: Theme.of(context).textTheme.bodyText2,
      color: Theme.of(context).primaryColorDark,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            top: 0,
            left: 0,
            right: 0,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: depthBarWidth * 1.0 * (depth - 1)),
                  child: _buildDepthMarkers(context, depth),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: depthBarWidth * 1.0 * (depth - 1)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Divider(height: 2, color: Colors.grey[900]),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 4, left: 7),
                        child: Row(
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
                      ),
                      Html(
                        data: child.text,
                        onLinkTap: (url) {
                          _launchURL(url);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildDepthMarkers(BuildContext context, int d) {
    if (d > 1) {
      return Container(
        width: depthBarWidth * 1.0,
        color: _depthToColor(d),
      );
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
