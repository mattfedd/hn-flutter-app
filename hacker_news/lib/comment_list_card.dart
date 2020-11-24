import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hacker_news/comment.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentListCard extends StatelessWidget {
  final Comment child;
  final bool hasCollapsedChildren;
  final bool isCollapsed;
  final Function onTapHandler;

  const CommentListCard(
      {Key key,
      this.child,
      this.isCollapsed,
      this.hasCollapsedChildren,
      this.onTapHandler})
      : super(key: key);

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
  final int _transitionDurationMs = 300;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: _transitionDurationMs),
      reverseDuration: Duration(milliseconds: _transitionDurationMs),
      switchInCurve: Interval(0.1, 1.0),
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SizeTransition(
            sizeFactor: animation,
            axis: Axis.vertical,
            axisAlignment: -1,
            child: child);
      },
      child: isCollapsed
          ? Container(key: Key("empty"))
          : Material(
              key: Key("card"),
              textStyle: Theme.of(context).textTheme.bodyText2,
              color: Theme.of(context).primaryColorDark,
              child: InkWell(
                onTap: onTapHandler ?? () {},
                child: Stack(
                  children: <Widget>[
                    _buildDepthMarker(context, child.depth),
                    Padding(
                      padding: EdgeInsets.only(
                          left: depthBarWidth.toDouble() * (child.depth - 1)),
                      child: _buildMainCard(context),
                    ),
                  ],
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

  Widget _buildMainCard(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Divider(height: 2, color: Colors.grey[800]),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 4, left: 7),
                child: Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        child.by != null ? "${child.by}" : "",
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
                            ? howLongAgo(DateTime.now().toUtc(), child.time)
                            : "",
                        style: Theme.of(context).textTheme.caption,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    hasCollapsedChildren
                        ? _buildCollapsedChildrenCounter(
                            context, child.children.length)
                        : Container()
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
    );
  }

  Widget _buildDepthMarker(BuildContext context, int depth) {
    Widget depthBar = depth > 1
        ? Container(
            width: depthBarWidth.toDouble(),
            color: _depthToColor(depth),
          )
        : Container();

    return Positioned.fill(
      top: 1,
      left: 0,
      right: 0,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: depthBarWidth * 1.0 * (depth - 1)),
            child: depthBar,
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedChildrenCounter(BuildContext context, int numChildren) {
    if (numChildren == 0) {
      return Container();
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              color: Colors.green,
              child: Text("+$numChildren",
                  style: Theme.of(context).textTheme.caption)),
        ),
      ),
    );
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
