import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isLoginMode = true; // BIẾN CHUYỂN ĐỔI ĐĂNG NHẬP / ĐĂNG KÝ

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    const Color darkRed = Color(0xFF640D14);
    const Color deepRed = Color(0xFF38040E);
    const Color goldAccent = Color(0xFFD7B18E);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [darkRed, deepRed],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("🐎", style: TextStyle(fontSize: 80)),
                const SizedBox(height: 10),
                Text(
                  _isLoginMode ? "Chúc mừng năm mới 2026" : "Đăng ký tài khoản mới",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: goldAccent,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                
                /// USERNAME
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: goldAccent),
                  decoration: InputDecoration(
                    labelText: "Tên đăng nhập",
                    labelStyle: const TextStyle(color: goldAccent),
                    prefixIcon: const Icon(Icons.person_outline, color: goldAccent),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: goldAccent)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                  ),
                ),
                const SizedBox(height: 20),
                
                /// PASSWORD
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: goldAccent),
                  decoration: InputDecoration(
                    labelText: "Mật khẩu",
                    labelStyle: const TextStyle(color: goldAccent),
                    prefixIcon: const Icon(Icons.lock_outline, color: goldAccent),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: goldAccent)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                  ),
                ),
                const SizedBox(height: 40),
                
                /// ACTION BUTTON
                SizedBox(
                  width: 220,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleAuthAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: goldAccent,
                      foregroundColor: deepRed,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: deepRed, strokeWidth: 2))
                        : Text(
                            _isLoginMode ? "ĐĂNG NHẬP" : "ĐĂNG KÝ NGAY",
                            style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                  ),
                ),

                const SizedBox(height: 25),

                /// TOGGLE MODE BUTTON
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoginMode = !_isLoginMode;
                    });
                  },
                  child: Text(
                    _isLoginMode ? "Bạn chưa có tài khoản? Đăng ký ngay" : "Bạn đã có tài khoản? Đăng nhập",
                    style: const TextStyle(color: goldAccent, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// XỬ LÝ ĐĂNG NHẬP / ĐĂNG KÝ
  void _handleAuthAction() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() => _isLoading = true);

    bool success;
    String message;

    if (_isLoginMode) {
      success = await authProvider.login(_usernameController.text, _passwordController.text);
      message = "Đăng nhập thất bại. Kiểm tra lại thông tin!";
    } else {
      success = await authProvider.register(_usernameController.text, _passwordController.text);
      message = success ? "Đăng ký thành công! Hãy đăng nhập." : "Đăng ký thất bại hoặc tên đã tồn tại!";
      if (success) setState(() => _isLoginMode = true); // Chuyển về login sau khi đăng ký
    }

    setState(() => _isLoading = false);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.black87),
      );
    } else if (success && !_isLoginMode && mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green.shade900),
      );
    }
  }
}
