import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static const key = "cart";

  Future<List<String>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data == null) return [];
    return List<String>.from(jsonDecode(data));
  }

  Future<void> add(String item) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getCart();
    list.add(item);
    await prefs.setString(key, jsonEncode(list));
  }

  Future<void> remove(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getCart();
    list.removeAt(index);
    await prefs.setString(key, jsonEncode(list));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}