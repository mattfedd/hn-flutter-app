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

  Future<List<WithDepth<Item>>> getAllComments(int parentId, int limit) async {
    List<WithDepth<int>> idsToCheck = [WithDepth<int>(parentId, 0)];
    List<WithDepth<Item>> itemsToReturn = [];

    while (idsToCheck.isNotEmpty) {
      if (itemsToReturn.length > limit + 2) {
        // remove first item (parent) before returning
        itemsToReturn.removeAt(0);
        return itemsToReturn;
      }
      // get first item from queue
      var id = idsToCheck.removeAt(0);

      Item item = await ip.getItemFromID(id.value);

      // corner case to catch some invalid comments
      if (item.by == null) {
        continue;
      }

      itemsToReturn.add(WithDepth<Item>(item, id.depth));

      // prepend next ids to the front of the queue (DFS)
      if (!(item.kids == null || item.kids.isEmpty || id.depth >= 10)) {
        item.kids.reversed.forEach((element) {
          idsToCheck.insert(0, WithDepth<int>(element, id.depth + 1));
        });
      }
    }

    // remove first item (parent) before returning
    itemsToReturn.removeAt(0);
    return itemsToReturn;
  }
}
