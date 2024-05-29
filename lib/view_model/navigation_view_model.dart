import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationViewModel {
  static const String _selectedIndexKey = 'navigation_index';
  SharedPreferences? _prefs;
  ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);

  NavigationViewModel() {
    _init();
  }

  void _init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSelectedIndex();
  }

  void _loadSelectedIndex() {
    final index = _prefs?.getInt(_selectedIndexKey) ?? 0;
    selectedIndexNotifier.value = index;
  }

  void saveSelectedIndex(int index) {
    _prefs?.setInt(_selectedIndexKey, index);
    selectedIndexNotifier.value = index;
  }
}
