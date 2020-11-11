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
    final storyExampleJSON = r'''
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
    final commentExampleJSON = r'''
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

  test('Ask with example JSON works', () {
    final askExampleJSON = r'''
{
  "by" : "tel",
  "descendants" : 16,
  "id" : 121003,
  "kids" : [ 121016, 121109, 121168 ],
  "score" : 25,
  "text" : "<i>or</i> HN: the Next Iteration<p>I get the impression that with Arc being released a lot of people who never had time for HN before are suddenly dropping in more often. (PG: what are the numbers on this? I'm envisioning a spike.)<p>Not to say that isn't great, but I'm wary of Diggification. Between links comparing programming to sex and a flurry of gratuitous, ostentatious  adjectives in the headlines it's a bit concerning.<p>80% of the stuff that makes the front page is still pretty awesome, but what's in place to keep the signal/noise ratio high? Does the HN model still work as the community scales? What's in store for (++ HN)?",
  "time" : 1203647620,
  "title" : "Ask HN: The Arc Effect",
  "type" : "story"
}
  ''';

    final ask = Item.fromJson(jsonDecode(askExampleJSON));

    expect(ask.id, 121003);
    expect(ask.by, "tel");
    expect(ask.descendants, 16);
    expect(ask.kids, [121016, 121109, 121168]);
    expect(ask.score, 25);
    expect(ask.title, "Ask HN: The Arc Effect");
    expect(ask.type, ItemType.Story);
    expect(ask.time, DateTime.utc(2008, 2, 22, 2, 33, 40));
    expect(ask.text,
        "<i>or</i> HN: the Next Iteration<p>I get the impression that with Arc being released a lot of people who never had time for HN before are suddenly dropping in more often. (PG: what are the numbers on this? I'm envisioning a spike.)<p>Not to say that isn't great, but I'm wary of Diggification. Between links comparing programming to sex and a flurry of gratuitous, ostentatious  adjectives in the headlines it's a bit concerning.<p>80% of the stuff that makes the front page is still pretty awesome, but what's in place to keep the signal/noise ratio high? Does the HN model still work as the community scales? What's in store for (++ HN)?");
  });

  test('Job with example JSON works', () {
    final jobExampleJSON = r'''
{
  "by" : "justin",
  "id" : 192327,
  "score" : 6,
  "text" : "Justin.tv is the biggest live video site online. We serve hundreds of thousands of video streams a day, and have supported up to 50k live concurrent viewers. Our site is growing every week, and we just added a 10 gbps line to our colo. Our unique visitors are up 900% since January.<p>There are a lot of pieces that fit together to make Justin.tv work: our video cluster, IRC server, our web app, and our monitoring and search services, to name a few. A lot of our website is dependent on Flash, and we're looking for talented Flash Engineers who know AS2 and AS3 very well who want to be leaders in the development of our Flash.<p>Responsibilities<p><pre><code>    * Contribute to product design and implementation discussions\n    * Implement projects from the idea phase to production\n    * Test and iterate code before and after production release \n</code></pre>\nQualifications<p><pre><code>    * You should know AS2, AS3, and maybe a little be of Flex.\n    * Experience building web applications.\n    * A strong desire to work on website with passionate users and ideas for how to improve it.\n    * Experience hacking video streams, python, Twisted or rails all a plus.\n</code></pre>\nWhile we're growing rapidly, Justin.tv is still a small, technology focused company, built by hackers for hackers. Seven of our ten person team are engineers or designers. We believe in rapid development, and push out new code releases every week. We're based in a beautiful office in the SOMA district of SF, one block from the caltrain station. If you want a fun job hacking on code that will touch a lot of people, JTV is for you.<p>Note: You must be physically present in SF to work for JTV. Completing the technical problem at <a href=\"http://www.justin.tv/problems/bml\" rel=\"nofollow\">http://www.justin.tv/problems/bml</a> will go a long way with us. Cheers!",
  "time" : 1210981217,
  "title" : "Justin.tv is looking for a Lead Flash Engineer!",
  "type" : "job",
  "url" : ""
}
  ''';

    final job = Item.fromJson(jsonDecode(jobExampleJSON));

    expect(job.by, "justin");
    expect(job.id, 192327);
    expect(job.score, 6);
    expect(job.url, "");
    expect(job.type, ItemType.Job);
    expect(job.title, "Justin.tv is looking for a Lead Flash Engineer!");
    expect(job.time, DateTime.utc(2008, 5, 16, 23, 40, 17));
    expect(job.text,
        '''Justin.tv is the biggest live video site online. We serve hundreds of thousands of video streams a day, and have supported up to 50k live concurrent viewers. Our site is growing every week, and we just added a 10 gbps line to our colo. Our unique visitors are up 900% since January.<p>There are a lot of pieces that fit together to make Justin.tv work: our video cluster, IRC server, our web app, and our monitoring and search services, to name a few. A lot of our website is dependent on Flash, and we're looking for talented Flash Engineers who know AS2 and AS3 very well who want to be leaders in the development of our Flash.<p>Responsibilities<p><pre><code>    * Contribute to product design and implementation discussions\n    * Implement projects from the idea phase to production\n    * Test and iterate code before and after production release \n</code></pre>\nQualifications<p><pre><code>    * You should know AS2, AS3, and maybe a little be of Flex.\n    * Experience building web applications.\n    * A strong desire to work on website with passionate users and ideas for how to improve it.\n    * Experience hacking video streams, python, Twisted or rails all a plus.\n</code></pre>\nWhile we're growing rapidly, Justin.tv is still a small, technology focused company, built by hackers for hackers. Seven of our ten person team are engineers or designers. We believe in rapid development, and push out new code releases every week. We're based in a beautiful office in the SOMA district of SF, one block from the caltrain station. If you want a fun job hacking on code that will touch a lot of people, JTV is for you.<p>Note: You must be physically present in SF to work for JTV. Completing the technical problem at <a href=\"http://www.justin.tv/problems/bml\" rel=\"nofollow\">http://www.justin.tv/problems/bml</a> will go a long way with us. Cheers!''');
  });

  test('Poll with example JSON works', () {
    final pollExampleJSON = r'''
{
  "by" : "pg",
  "descendants" : 54,
  "id" : 126809,
  "kids" : [ 126822, 126823, 126993, 126824, 126934, 127411, 126888, 127681, 126818, 126816, 126854, 127095, 126861, 127313, 127299, 126859, 126852, 126882, 126832, 127072, 127217, 126889, 127535, 126917, 126875 ],
  "parts" : [ 126810, 126811, 126812 ],
  "score" : 46,
  "text" : "",
  "time" : 1204403652,
  "title" : "Poll: What would happen if News.YC had explicit support for polls?",
  "type" : "poll"
}
  ''';

    final poll = Item.fromJson(jsonDecode(pollExampleJSON));

    expect(poll.by, "pg");
    expect(poll.descendants, 54);
    expect(poll.id, 126809);
    expect(poll.score, 46);
    expect(poll.text, "");
    expect(poll.title,
        "Poll: What would happen if News.YC had explicit support for polls?");
    expect(poll.type, ItemType.Poll);
    expect(poll.time, DateTime.utc(2008, 3, 1, 20, 34, 12));
    expect(poll.parts, [126810, 126811, 126812]);
    expect(poll.kids, [
      126822,
      126823,
      126993,
      126824,
      126934,
      127411,
      126888,
      127681,
      126818,
      126816,
      126854,
      127095,
      126861,
      127313,
      127299,
      126859,
      126852,
      126882,
      126832,
      127072,
      127217,
      126889,
      127535,
      126917,
      126875
    ]);
  });

  test('Pollopt with example JSON works', () {
    final polloptExampleJSON = r'''
{
  "by" : "pg",
  "id" : 160705,
  "poll" : 160704,
  "score" : 335,
  "text" : "Yes, ban them; I'm tired of seeing Valleywag stories on News.YC.",
  "time" : 1207886576,
  "type" : "pollopt"
}
  ''';

    final pollopt = Item.fromJson(jsonDecode(polloptExampleJSON));

    expect(pollopt.by, "pg");
    expect(pollopt.id, 160705);
    expect(pollopt.poll, 160704);
    expect(pollopt.score, 335);
    expect(pollopt.text,
        "Yes, ban them; I'm tired of seeing Valleywag stories on News.YC.");
    expect(pollopt.type, ItemType.PollOpt);
    expect(pollopt.time, DateTime.utc(2008, 4, 11, 4, 2, 56));
  });
}
