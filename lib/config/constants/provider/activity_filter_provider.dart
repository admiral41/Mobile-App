import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityFilterProvider =
    ChangeNotifierProvider((ref) => ActivityFilterProvider());

class ActivityFilterProvider with ChangeNotifier {
  int _index = 0;
  get index => _index;
  void changeindex(int index) {
    _index = index;
    notifyListeners();
  }
}
