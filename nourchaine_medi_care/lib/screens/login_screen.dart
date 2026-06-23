import 'package:flutter/material.dart';
import '../models/user_data.dart';
import 'user_dashboard.dart';
import 'admin_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;
  bool _loading = false;

  static const _adminCredentials = {
    'admin@medicare.com': 'Admin@2024',
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() { _errorMessage = null; _loading = true; });
    await Future.delayed(const Duration(milliseconds: 600));

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    // Check admin
    if (_adminCredentials[email] == password) {
      setState(() => _loading = false);
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const AdminPage()));
      return;
    }

    // Check static users
    final userAccount = kUserAccounts[email];
    if (userAccount != null && userAccount.password == password) {
      setState(() => _loading = false);
      if (!mounted) return;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UserPage(account: userAccount)));
      return;
    }

    setState(() {
      _errorMessage = 'Invalid email or password. Please try again.';
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FF),
      body: Stack(children: [
        Positioned(
            top: -60, right: -60,
            child: _decorCircle(220, const Color(0xFF3B9EE8), 0.18)),
        Positioned(
            bottom: -80, left: -80,
            child: _decorCircle(260, const Color(0xFF3B9EE8), 0.10)),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(
                        color: const Color(0xFF3B9EE8).withOpacity(0.20),
                        blurRadius: 16, offset: const Offset(0, 4))],
                  ),
                  child: const Icon(Icons.add, color: Color(0xFF3B9EE8), size: 32),
                ),
                const SizedBox(height: 16),
                const Text('MediCare Portal',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700,
                        color: Color(0xFF1A3A5C), letterSpacing: -0.5)),
                const SizedBox(height: 4),
                const Text('Secure Health Management System',
                    style: TextStyle(fontSize: 13, color: Color(0xFF8AAAC8))),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 24, offset: const Offset(0, 6))],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Welcome Back',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                            color: Color(0xFF1A3A5C))),
                    const SizedBox(height: 4),
                    const Text('Sign in to access your medical dashboard.',
                        style: TextStyle(fontSize: 12.5, color: Color(0xFF8AAAC8))),
                    const SizedBox(height: 28),
                    _fieldLabel('Email Address'),
                    const SizedBox(height: 8),
                    _textField(controller: _emailController,
                        hint: 'yourname@medicare.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 20),
                    _fieldLabel('Password'),
                    const SizedBox(height: 8),
                    _passwordField(),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: const Text('Forgot Password?',
                            style: TextStyle(fontSize: 12.5,
                                color: Color(0xFF3B9EE8),
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(children: [
                          const Icon(Icons.error_outline,
                              color: Color(0xFFEF4444), size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text(_errorMessage!,
                              style: const TextStyle(
                                  fontSize: 12.5, color: Color(0xFFB91C1C)))),
                        ]),
                      ),
                    ],
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity, height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _loading ? null : _signIn,
                        icon: _loading
                            ? const SizedBox(width: 18, height: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.login_rounded,
                                color: Colors.white, size: 18),
                        label: Text(_loading ? 'Signing in…' : 'Sign In',
                            style: const TextStyle(fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B9EE8),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Credentials hint
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F6FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Test credentials:',
                                style: TextStyle(fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF4A6FA5))),
                            SizedBox(height: 6),
                            Text('🔑 Admin:  admin@medicare.com / Admin@2024',
                                style: TextStyle(fontSize: 11,
                                    color: Color(0xFF6B8BAE))),
                            Divider(height: 10, color: Color(0xFFDDE8F5)),
                            Text('👨‍⚕️ Karim:  karim.mansouri@medicare.com / Karim@2024',
                                style: TextStyle(fontSize: 11,
                                    color: Color(0xFF6B8BAE))),
                            Text('👩‍⚕️ Sara:   sara.benlamine@medicare.com / Sara@2024',
                                style: TextStyle(fontSize: 11,
                                    color: Color(0xFF6B8BAE))),
                            Text('👩‍⚕️ Amira:  amira.hadj@medicare.com / Amira@2024',
                                style: TextStyle(fontSize: 11,
                                    color: Color(0xFF6B8BAE))),
                          ]),
                    ),
                  ]),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _decorCircle(double size, Color color, double opacity) => Container(
        width: size, height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: color.withOpacity(opacity)),
      );

  Widget _fieldLabel(String text) => Text(text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
          color: Color(0xFF1A3A5C)));

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) =>
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A3A5C)),
        decoration: _inputDecoration(hint: hint, prefixIcon: prefixIcon),
      );

  Widget _passwordField() => TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A3A5C)),
        decoration: _inputDecoration(
          hint: 'Enter your password',
          prefixIcon: Icons.lock_outline_rounded,
          suffix: GestureDetector(
            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
            child: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF8AAAC8), size: 20),
          ),
        ),
      );

  InputDecoration _inputDecoration(
          {required String hint,
          required IconData prefixIcon,
          Widget? suffix}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB0C8E0), fontSize: 13.5),
        prefixIcon: Icon(prefixIcon, color: const Color(0xFF8AAAC8), size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF5F9FF),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDDE8F5), width: 1.2)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDDE8F5), width: 1.2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF3B9EE8), width: 1.5)),
      );
}