import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  static const key = "orders";

  Future<List<Map<String, dynamic>>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  Future<void> addOrder(Map<String, dynamic> order) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getOrders();
    list.add(order);
    await prefs.setString(key, jsonEncode(list));
  }
}