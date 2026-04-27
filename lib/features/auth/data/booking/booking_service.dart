import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookingService {
  static const key = "bookings";

  Future<List<Map<String, dynamic>>> get() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  Future<void> add(Map<String, dynamic> booking) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await get();
    list.add(booking);
    await prefs.setString(key, jsonEncode(list));
  }

  Future<void> delete(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await get();
    list.removeAt(index);
    await prefs.setString(key, jsonEncode(list));
  }
}