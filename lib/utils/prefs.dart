import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<SharedPreferences> _instance() async {
    return await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await _instance();
    await prefs.setString(key, value);
  }

  static Future<String> getString(String key) async {
    final prefs = await _instance();
    return prefs.getString(key) ?? '';
  }

  static Future<void> setMap(String key, Map<String, dynamic> value) async {
    final prefs = await _instance();
    String jsonString = jsonEncode(value);
    debugPrint('Saving map to prefs with key: $key, value: $jsonString');
    await prefs.setString(key, jsonString);
  }

  static Future<Map<String, dynamic>?> getMap(String key) async {
    final prefs = await _instance();
    String jsonString = prefs.getString(key) ?? '';

    if (jsonString.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(jsonDecode(jsonString));
  }

  static Future<void> remove(String key) async {
    final prefs = await _instance();
    await prefs.remove(key);
  }
}
