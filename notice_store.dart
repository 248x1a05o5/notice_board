import 'package:flutter/foundation.dart';

import '../models/notice.dart';
import 'notice_service.dart';

enum LoadStatus { loading, error, ready }

/// Provider store shared by the list, detail, form and departments screens.
class NoticeStore extends ChangeNotifier {
  NoticeStore(this._service);

  final NoticeService _service;

  List<Notice> _items = [];
  LoadStatus _status = LoadStatus.loading;
  String? _errorMessage;
  String? _selectedDepartment;

  LoadStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get selectedDepartment => _selectedDepartment;
  bool get hasNotices => _items.isNotEmpty;

  List<Notice> get visibleNotices {
    final dept = _selectedDepartment;
    final list =
        dept == null ? _items : _items.where((n) => n.department == dept);
    return List.unmodifiable(list);
  }

  int countFor(String department) =>
      _items.where((n) => n.department == department).length;

  int get totalCount => _items.length;

  Notice? byId(String id) {
    for (final n in _items) {
      if (n.id == id) return n;
    }
    return null;
  }

  void selectDepartment(String? department) {
    _selectedDepartment = department;
    notifyListeners();
  }

  Future<void> load() async {
    _status = LoadStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _items = await _service.readAll();
      _sort();
      _status = LoadStatus.ready;
    } catch (e) {
      _status = LoadStatus.error;
      _errorMessage = 'Could not load notices.';
    }
    notifyListeners();
  }

  Future<void> add({
    required String title,
    required String department,
    required String body,
    required String postedBy,
    required DateTime date,
  }) async {
    final now = DateTime.now();
    final notice = Notice(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      department: department,
      body: body,
      postedBy: postedBy,
      date: date,
      createdAt: now,
    );
    final updated = [..._items, notice];
    await _service.writeAll(updated);
    _items = updated;
    _sort();
    notifyListeners();
  }

  Future<void> remove(String id) async {
    final updated = _items.where((n) => n.id != id).toList();
    await _service.writeAll(updated);
    _items = updated;
    notifyListeners();
  }

  void _sort() {
    _items.sort((a, b) {
      final byDate = b.date.compareTo(a.date);
      return byDate != 0 ? byDate : b.createdAt.compareTo(a.createdAt);
    });
  }
}
