import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/notice.dart';

/// Reads and writes notices on the device so they survive a restart.
class NoticeService {
  static const String _key = 'notices_v1';

  Future<List<Notice>> readAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => Notice.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> writeAll(List<Notice> notices) async {
    final prefs = await SharedPreferences.getInstance();
    final ok = await prefs.setString(
      _key,
      jsonEncode(notices.map((e) => e.toJson()).toList()),
    );
    if (!ok) {
      throw Exception('Could not save to device storage');
    }
  }
}
