import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;
  
  // Giả lập cơ sở dữ liệu người dùng (trong thực tế sẽ dùng API/Database)
  final Map<String, String> _users = {
    "admin": "123456",
  };

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;

  /// ĐĂNG KÝ TÀI KHOẢN MỚI
  Future<bool> register(String user, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (user.isEmpty || password.length < 6) return false;
    
    if (_users.containsKey(user)) return false; // User đã tồn tại

    _users[user] = password;
    return true;
  }

  /// ĐĂNG NHẬP
  Future<bool> login(String user, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (_users.containsKey(user) && _users[user] == password) {
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
