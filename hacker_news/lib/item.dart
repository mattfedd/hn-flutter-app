enum ItemType {
  None,
  Job,
  Story,
  Comment,
  Poll,
  PollOpt,
}

class Item {
  /// The item's unique id. Required.
  final int id;

  /// true if the item is deleted.
  bool deleted;

  /// The type of item. One of "job", "story", "comment", "poll", or "pollopt".
  ItemType type;

  /// The username of the item's author.
  String by;

  /// Creation date of the item, in Unix Time.
  DateTime time;

  /// The comment, story or poll text. HTML.
  String text;

  /// true if the item is dead.
  bool dead;

  /// The comment's parent: either another comment or the relevant story.
  int parent;

  /// The pollopt's associated poll.
  int poll;

  /// The ids of the item's comments, in ranked display order.
  List<int> kids;

  /// The URL of the story.
  String url;

  /// The story's score, or the votes for a pollopt.
  int score;

  /// The title of the story, poll or job. HTML.
  String title;

  /// A list of related pollopts, in display order.
  List<int> parts;

  /// In the case of stories or polls, the total comment count.
  int descendants;

  Item(
      {this.id,
      this.deleted,
      this.type,
      this.by,
      this.time,
      this.text,
      this.dead,
      this.parent,
      this.poll,
      this.kids,
      this.url,
      this.score,
      this.title,
      this.parts,
      this.descendants});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      deleted: json['deleted'],
      type: json['type'] != null
          ? _getTypeFromString(json['type'] as String)
          : null,
      by: json['by'],
      time:
          json['time'] != null ? _getDateFromUnixTimestamp(json['time']) : null,
      text: json['text'],
      dead: json['dead'],
      parent: json['parent'],
      poll: json['poll'],
      kids: json['kids']?.cast<int>(),
      url: json['url'],
      score: json['score'],
      title: json['title'],
      parts: json['parts']?.cast<int>(),
      descendants: json['descendants'],
    );
  }

  static ItemType _getTypeFromString(String value) {
    switch (value) {
      case "story":
        return ItemType.Story;
      case "comment":
        return ItemType.Comment;
      case "job":
        return ItemType.Job;
      case "poll":
        return ItemType.Poll;
      case "pollopt":
        return ItemType.PollOpt;
      default:
        return ItemType.None;
    }
  }

  static DateTime _getDateFromUnixTimestamp(int ts) {
    return DateTime.fromMillisecondsSinceEpoch(ts * 1000, isUtc: true);
  }

  @override
  String toString() {
    var value = '''
    {
      id: ${this.id},
      deleted: ${this.deleted},
      type: ${this.type},
      by: ${this.by},
      time: ${this.time},
      text: ${this.text},
      dead: ${this.dead},
      parent: ${this.parent},
      poll: ${this.poll},
      kids: ${this.kids},
      url: ${this.url},
      score: ${this.score},
      title: ${this.title},
      parts: ${this.parts},
      descendants: ${this.descendants}
    }''';

    return value;
  }
}
