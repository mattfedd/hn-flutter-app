import 'package:hacker_news/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum ListFilter {
  Top,
  New,
  Best,
  Ask,
  Job,
  Show,
}

class ItemProvider {
  final http.Client client;

  ItemProvider(this.client);

  final Map<ListFilter, String> endpoints = {
    ListFilter.Top: "topstories",
    ListFilter.New: "newstories",
    ListFilter.Best: "beststories",
    ListFilter.Ask: "askstories",
    ListFilter.Show: "showstories",
    ListFilter.Job: "jobstories",
  };

  final String baseURL = "https://hacker-news.firebaseio.com/v0/";

  String _filterToUrl(ListFilter filter) {
    return baseURL + endpoints[filter] + ".json";
  }

  Future<Item> getItemFromID(int id) async {
    var response = await client
        .get('https://hacker-news.firebaseio.com/v0/item/${id}.json');

    if (response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to get item from server");
    }
  }

  Future<List<Item>> _getItemListFromIDs(List<int> ids) async {
    return await Future.wait(ids.map((id) => this.getItemFromID(id)));
  }

  Future<List<int>> _getIdList(ListFilter filter) async {
    var response = await client.get(_filterToUrl(filter));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body).cast<int>();
      // limit it to 30
      if (result.length > 30) {
        result = result.sublist(0, 29);
      }
      return result;
    } else {
      throw Exception("Failed to get ID list from server");
    }
  }

  Future<List<Item>> getItems(ListFilter filter) async {
    return await _getItemListFromIDs(await _getIdList(filter));
  }
}
