import 'package:hacker_news/item_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  // TODO mock out http client calls and responses?

  // what happens when non-200 is returned? exception? is that okay?

  // test('Item provider works', () async {
  //   var client = new http.Client();
  //   var ip = ItemProvider(client);

  //   // var item = await ip.getItemFromID(8863);
  //   var items = await ip.getItemListFromIDs([8863, 2921983, 126809]);

  //   // expect(item.by, "dhouston");
  //   expect(items.length, 3);

  //   items.forEach((element) {
  //     print(element);
  //   });
  // });
}
