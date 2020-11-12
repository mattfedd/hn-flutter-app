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
      margin: EdgeInsets.only(bottom: 1.0),
      padding: EdgeInsets.symmetric(vertical: 1.0),
      child: Material(
        color: Colors.orange[100],
        child: InkWell(
          onTap: () => child.url != null ? _launchURL(child.url) : {},
          child: Container(
            constraints: BoxConstraints(minHeight: 48),
            margin: EdgeInsets.symmetric(vertical: 4.0),
            padding: EdgeInsets.symmetric(vertical: 4.0),
            alignment: Alignment.centerLeft,
            // color: Colors.grey,
            // color: Colors.orange[300],
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
                Container(
                  // alignment: Alignment.centerLeft,
                  constraints: BoxConstraints(maxWidth: 350),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                  // height: 60,
                  // color: Colors.white70,
                  child: Text(
                    child.title ?? "",
                    style: TextStyle(fontSize: 18),
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
      child: Text('${child.score} ^'),
    );
  }

  Widget _buildCommentTextDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      margin: EdgeInsets.only(left: 3.0),
      width: 50,
      alignment: Alignment.center,
      child: Text('${child.descendants} c'),
    );
  }
}
