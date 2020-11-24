import 'package:hacker_news/comment.dart';
import 'package:hacker_news/item.dart';
import 'package:hacker_news/item_provider.dart';

class WithDepth<T> {
  T value;
  int depth;

  WithDepth(this.value, this.depth);
}

class CommentsProvider {
  final ItemProvider ip;

  CommentsProvider(this.ip);

  Future<List<Comment>> getAllComments(int parentId, int limit) async {
    List<WithDepth<int>> idsToCheck = [WithDepth<int>(parentId, 0)];
    List<Comment> itemsToReturn = [];

    while (idsToCheck.isNotEmpty) {
      if (itemsToReturn.length > limit + 2) {
        break;
      }
      // get first item from queue
      var id = idsToCheck.removeAt(0);

      Comment item = Comment(await ip.getItemFromID(id.value), id.depth);

      // corner case to catch some invalid comments
      if (item.by == null) {
        continue;
      }

      itemsToReturn.add(item);

      // prepend next ids to the front of the queue (DFS)
      if (!(item.kids == null || item.kids.isEmpty || id.depth >= 10)) {
        item.kids.reversed.forEach((element) {
          idsToCheck.insert(0, WithDepth<int>(element, id.depth + 1));
        });
      }
    }

    // remove first item (parent) before returning
    itemsToReturn.removeAt(0);

    // determine children
    for (var i = 0; i < itemsToReturn.length; i++) {
      innerloop:
      for (var j = i + 1; j < itemsToReturn.length; j++) {
        if (itemsToReturn[j].depth <= itemsToReturn[i].depth) {
          break innerloop;
        }
        itemsToReturn[i].children.add(itemsToReturn[j].id);
      }
    }

    return itemsToReturn;
  }
}
