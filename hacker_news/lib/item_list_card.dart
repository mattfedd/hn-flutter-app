import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hacker_news/comments_page.dart';
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CommentsPage(parentItem: child)),
            );
          },
          // onTap: () => child.url != null ? _launchURL(child.url) : {},
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
                          _buildScoreTextDisplay(context),
                          _buildCommentTextDisplay(),
                        ],
                      )
                    : _buildScoreTextDisplay(context),
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
                          margin: EdgeInsets.only(top: 0.0),
                          child: Text(
                            child.url != null ? urlShortener(child.url) : "",
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

  Widget _buildScoreTextDisplay(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      margin: EdgeInsets.only(left: 3.0, bottom: 5.0),
      width: 50,
      alignment: Alignment.center,
      child: Text(
        '${child.score}',
        style: TextStyle(
            color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
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

  // gets the base/domain from an input url
  // TODO: clean this up and add tests
  static String urlShortener(String input) {
    // remove http or https and :// from the start
    int idx = input.indexOf("://");
    String shortUrl = input.substring(idx + 3);

    // check for www
    if (shortUrl.startsWith("www")) {
      // remove it
      shortUrl = shortUrl.substring(4);
    }

    // check for first slash
    idx = shortUrl.indexOf("/");
    if (idx == -1) {
      return shortUrl;
    }

    var shorterUrl = shortUrl.substring(0, idx);

    // special cases: twitter.com --> check for second slash
    if (shortUrl.startsWith("twitter")) {
      idx = shortUrl.indexOf("/");
      if (idx == -1) {
        return shortUrl;
      }

      var second = shortUrl.substring(idx + 1).indexOf("/") + 1;
      if (second - 1 == -1) {
        return shortUrl;
      }

      shorterUrl = shortUrl.substring(0, idx + second);
    }

    // specialer case: github.com --> check for third slash!
    if (shortUrl.startsWith("github.com")) {
      idx = shortUrl.indexOf("/");
      if (idx == -1) {
        return shortUrl;
      }
      var second = shortUrl.substring(idx + 1).indexOf("/") + 1;
      if (second - 1 == -1) {
        return shortUrl;
      }
      var third = shortUrl.substring(idx + 1 + second + 1).indexOf("/") + 2;
      if (third - 2 == -1) {
        return shortUrl;
      }
      shorterUrl = shortUrl.substring(0, idx + second + third);
    }

    return shorterUrl;
  }
}
