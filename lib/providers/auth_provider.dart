import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;

  /// GIẢ LẬP ĐĂNG NHẬP
  Future<bool> login(String user, String password) async {
    // Trong thực tế, bạn sẽ gọi API ở đây
    await Future.delayed(const Duration(seconds: 1)); // Hiệu ứng chờ

    if (user.isNotEmpty && password.length >= 6) {
      _isLoggedIn = true;
      _username = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// ĐĂNG XUẤT
  void logout() {
    _isLoggedIn = false;
    _username = null;
    notifyListeners();
  }
}
