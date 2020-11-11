import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hacker_news/item.dart';

void main() {
  test('Item initialized with simple ctor works', () {
    final item = Item(id: 123);

    expect(item.id, 123);
  });

  test('Story with example JSON works', () {
    // same example from the api docs
    final storyExampleJSON = '''
{
  "by" : "dhouston",
  "descendants" : 71,
  "id" : 8863,
  "kids" : [ 9224, 8917, 8952, 8958, 8884, 8887, 8869, 8940, 8908, 9005, 8873, 9671, 9067, 9055, 8865, 8881, 8872, 8955, 10403, 8903, 8928, 9125, 8998, 8901, 8902, 8907, 8894, 8870, 8878, 8980, 8934, 8943, 8876 ],
  "score" : 104,
  "time" : 1175714200,
  "title" : "My YC app: Dropbox - Throw away your USB drive",
  "type" : "story",
  "url" : "http://www.getdropbox.com/u/2/screencast.html"
}
''';

    final story = Item.fromJson(jsonDecode(storyExampleJSON));

    expect(story.id, 8863);
    expect(story.type, ItemType.Story);
    expect(story.score, 104);
    expect(story.descendants, 71);
    expect(story.by, "dhouston");
    expect(story.time, DateTime.utc(2007, 4, 4, 19, 16, 40));
    expect(story.title, "My YC app: Dropbox - Throw away your USB drive");
    expect(story.url, "http://www.getdropbox.com/u/2/screencast.html");
    expect(story.kids, [
      9224,
      8917,
      8952,
      8958,
      8884,
      8887,
      8869,
      8940,
      8908,
      9005,
      8873,
      9671,
      9067,
      9055,
      8865,
      8881,
      8872,
      8955,
      10403,
      8903,
      8928,
      9125,
      8998,
      8901,
      8902,
      8907,
      8894,
      8870,
      8878,
      8980,
      8934,
      8943,
      8876
    ]);

    // things that weren't part of the json should be null
    expect(story.poll, null);
    expect(story.parts, null);
    expect(story.dead, null);
    expect(story.deleted, null);
  });

  test('Comment with example JSON works', () {
    final commentExampleJSON = '''
{
  "by" : "norvig",
  "id" : 2921983,
  "kids" : [ 2922097, 2922429, 2924562, 2922709, 2922573, 2922140, 2922141 ],
  "parent" : 2921506,
  "text" : "Aw shucks, guys ... you make me blush with your compliments.<p>Tell you what, Ill make a deal: I'll keep writing if you keep reading. K?",
  "time" : 1314211127,
  "type" : "comment"
}
  ''';

    final comment = Item.fromJson(jsonDecode(commentExampleJSON));

    expect(comment.id, 2921983);
    expect(comment.type, ItemType.Comment);
    expect(comment.score, null);
    expect(comment.descendants, null);
    expect(comment.by, "norvig");
    expect(comment.time, DateTime.utc(2011, 8, 24, 18, 38, 47));
    expect(comment.title, null);
    expect(comment.text,
        "Aw shucks, guys ... you make me blush with your compliments.<p>Tell you what, Ill make a deal: I'll keep writing if you keep reading. K?");
  });
}
