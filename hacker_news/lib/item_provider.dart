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

  final Map<ListFilter, List<int>> _storyIds = {
    ListFilter.Top: [],
    ListFilter.New: [],
    ListFilter.Best: [],
    ListFilter.Ask: [],
    ListFilter.Show: [],
    ListFilter.Job: [],
  };

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
    var response =
        await client.get('https://hacker-news.firebaseio.com/v0/item/$id.json');

    if (response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to get item from server");
    }
  }

  Future<List<int>> _getIdList(ListFilter filter) async {
    var response = await client.get(_filterToUrl(filter));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body).cast<int>();
      return result;
    } else {
      throw Exception("Failed to get ID list from server");
    }
  }

  Future<List<Item>> getItemsInRange(ListFilter filter, int lo, int hi) async {
    if (_storyIds == null || _storyIds[filter].isEmpty) {
      _storyIds[filter] = await _getIdList(filter);
    }

    if (hi > _storyIds[filter].length) {
      // problem
      hi = _storyIds[filter].length;
    }

    if (hi < lo) {
      // a different problem
      // return null?
    }

    return await Future.wait(
        _storyIds[filter].sublist(lo, hi).map((id) => getItemFromID(id)));
  }
}
