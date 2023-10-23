// import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;
  static const _keyJson = 'userDetails';
  static const _keyUser = 'user';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setJson(String json) async =>
      await _preferences.setString(_keyJson, json);

  static String? getJson() => _preferences.getString(_keyJson);

  static Future setUser(String uuid) async =>
      await _preferences.setString(_keyUser, uuid);

  static String? getUser() => _preferences.getString(_keyUser);
}
