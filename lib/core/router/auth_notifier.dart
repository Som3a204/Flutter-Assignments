import 'package:flutter/foundation.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void markLoggedIn() => _set(true);

  void markLoggedOut() => _set(false);

  void _set(bool value) {
    if (_isLoggedIn == value) return;
    _isLoggedIn = value;
    notifyListeners();
  }
}
