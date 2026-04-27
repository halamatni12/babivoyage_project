import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String key = "favorites";

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);

    if (data == null) return [];

    try {
      return List<Map<String, dynamic>>.from(jsonDecode(data));
    } catch (e) {
      await prefs.remove(key);
      return [];
    }
  }

  Future<void> toggle(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getFavorites();

    final index =
        list.indexWhere((e) => e["title"] == item["title"]);

    if (index != -1) {
      list.removeAt(index);
    } else {
      list.add(item);
    }

    await prefs.setString(key, jsonEncode(list));
  }

  Future<bool> isFavorite(String title) async {
    final list = await getFavorites();
    return list.any((e) => e["title"] == title);
  }
}