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
    List<WithDepth<int>> idsToCheck = [WithDepth<int>(parentId, 1)];
    List<WithDepth<Item>> itemsToReturn = [];

    while (idsToCheck.isNotEmpty) {
      if (itemsToReturn.length >= limit) {
        return itemsToReturn;
      }
      // get first item from queue
      var id = idsToCheck.removeAt(0);

      Item item = await ip.getItemFromID(id.value);
      itemsToReturn.add(WithDepth<Item>(item, id.depth));

      // prepend next ids to the front of the queue (DFS)
      if (!(item.kids == null || item.kids.isEmpty || id.depth >= 10)) {
        item.kids.reversed.forEach((element) {
          idsToCheck.insert(0, WithDepth<int>(element, id.depth + 1));
        });
      }
    }

    return itemsToReturn;
  }
}
