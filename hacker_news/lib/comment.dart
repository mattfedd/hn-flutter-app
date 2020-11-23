import 'package:hacker_news/item.dart';

class Comment extends Item {
  final Item i;
  final int depth;
  List<int> children = [];
  Comment(this.i, this.depth);

  int get id => i.id;
  bool get deleted => i.deleted;
  ItemType get type => i.type;
  String get by => i.by;
  DateTime get time => i.time;
  String get text => i.text;
  bool get dead => i.dead;
  int get parent => i.parent;
  int get poll => i.poll;
  List<int> get kids => i.kids;
  String get url => i.url;
  int get score => i.score;
  String get title => i.title;
  List<int> get parts => i.parts;
  int get descendants => i.descendants;
}
