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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Gam màu từ ảnh (Đỏ trầm và Vàng đồng/Kem)
    const Color darkRed = Color(0xFF640D14);
    const Color deepRed = Color(0xFF38040E);
    const Color goldAccent = Color(0xFFD7B18E); // Màu nút "Gửi thông tin" trong ảnh

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              darkRed,
              deepRed,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon hình con ngựa cho năm Bính Ngọ 2026
                const Text(
                  "🐎",
                  style: TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Chúc mừng năm mới 2026",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: goldAccent,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Serif', // Tạo cảm giác truyền thống hơn
                  ),
                ),
                const SizedBox(height: 40),
                
                // Ô nhập liệu Tên đăng nhập
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: goldAccent),
                  decoration: InputDecoration(
                    labelText: "Tên đăng nhập",
                    labelStyle: const TextStyle(color: goldAccent),
                    hintText: "Nhập tên của bạn",
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.person_outline, color: goldAccent),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: goldAccent),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Ô nhập liệu Mật khẩu
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: goldAccent),
                  decoration: InputDecoration(
                    labelText: "Mật khẩu",
                    labelStyle: const TextStyle(color: goldAccent),
                    hintText: "Nhập mật khẩu",
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.lock_outline, color: goldAccent),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: goldAccent),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                
                // Nút Đăng nhập kiểu dáng giống nút trong ảnh
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() => _isLoading = true);
                            bool success = await authProvider.login(
                              _usernameController.text,
                              _passwordController.text,
                            );
                            setState(() => _isLoading = false);

                            if (!success && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Đăng nhập thất bại. Kiểm tra lại thông tin!"),
                                  backgroundColor: Colors.black87,
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: goldAccent,
                      foregroundColor: deepRed,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Nút vuông giống ảnh
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: deepRed, strokeWidth: 2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "ĐĂNG NHẬP",
                                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
