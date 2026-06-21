import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:supabase_flutter/supabase_flutter.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pvevfyytqvolnjrusgcs.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB2ZXZmeXl0cXZvbG5qcnVzZ2NzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE4ODE2OTcsImV4cCI6MjA5NzQ1NzY5N30.bk_xwuNOIfBC1B3yOmZ-rcucuAK5mX2vmZPVMiPMheo',
  );

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

class MediCareApp extends StatelessWidget {
  const MediCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediCare Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),
      home: const LandingScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 1 — LANDING (MedAssist)
// ═══════════════════════════════════════════════════════════════════════════════

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _waveController = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 700;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isWide
          ? Row(children: [
              Expanded(flex: 45, child: _buildLeft()),
              Expanded(flex: 55, child: _buildRight()),
            ])
          : SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: 300, child: _buildLeft()),
                _buildRight(),
              ]),
            ),
    );
  }

  Widget _buildLeft() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A6BAA), Color(0xFF0D9E8A)],
        ),
      ),
      child: Stack(children: [
        Center(
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (_, child) =>
                Transform.scale(scale: _pulseAnimation.value, child: child),
            child: Stack(alignment: Alignment.center, children: [
              _ring(240, 0.15),
              _ring(190, 0.20),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: Stack(alignment: Alignment.center, children: [
                  Positioned(
                    bottom: 35,
                    left: 10,
                    right: 10,
                    child: AnimatedBuilder(
                      animation: _waveController,
                      builder: (_, __) => CustomPaint(
                        size: const Size(120, 30),
                        painter: ECGPainter(
                            progress: _waveController.value,
                            color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                  ),
                  const Icon(Icons.add, color: Colors.white, size: 56),
                ]),
              ),
            ]),
          ),
        ),
        Positioned(
          top: 80,
          right: 40,
          child: _floatingBadge(
              Row(mainAxisSize: MainAxisSize.min, children: [
            const _BlinkingDot(color: Colors.red),
            const SizedBox(width: 6),
            const Text('Live',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A3A5C))),
          ])),
        ),
        Positioned(
          bottom: 80,
          left: 30,
          child: _floatingBadge(
              Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.bar_chart, color: Color(0xFF1A6BAA), size: 16),
            const SizedBox(width: 6),
            const Text('AI',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A3A5C))),
          ])),
        ),
      ]),
    );
  }

  Widget _ring(double size, double opacity) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: Colors.white.withOpacity(opacity), width: 1),
        ),
      );

  Widget _floatingBadge(Widget child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)
          ],
        ),
        child: child,
      );

  Widget _buildRight() {
    return Container(
      color: const Color(0xFFF5F9FF),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFDDE8F5)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFF22C55E))),
              const SizedBox(width: 8),
              const Text('Healthcare Platform powered by Nourchaine',
                  style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF4A6FA5),
                      fontWeight: FontWeight.w500)),
            ]),
          ),
          const SizedBox(height: 20),
          const Text('MedAssist',
              style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A3A5C),
                  letterSpacing: -1,
                  height: 1.1)),
          const SizedBox(height: 8),
          const Text('Intelligent Medical Monitoring & Scoring System',
              style: TextStyle(fontSize: 15, color: Color(0xFF6B8BAE))),
          const SizedBox(height: 28),
          // About card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A6BAA).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.show_chart_rounded,
                    color: Color(0xFF1A6BAA), size: 24),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('About MedAssist',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A3A5C))),
                      SizedBox(height: 6),
                      Text(
                          'An advanced clinical decision-support platform leveraging machine learning for real-time patient monitoring, automated severity scoring, and predictive health analytics.',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B8BAE),
                              height: 1.5)),
                    ]),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          // Feature cards
          Row(children: [
            Expanded(
                child: _FeatureCard(
                    icon: Icons.monitor_heart_outlined,
                    label: 'Real-time\nMonitoring',
                    iconColor: const Color(0xFF1A6BAA),
                    bgColor: const Color(0xFFEBF3FC))),
            const SizedBox(width: 12),
            Expanded(
                child: _FeatureCard(
                    icon: Icons.psychology_outlined,
                    label: 'AI Scoring',
                    iconColor: const Color(0xFF0D9E8A),
                    bgColor: const Color(0xFFE8F7F4))),
            const SizedBox(width: 12),
            Expanded(
                child: _FeatureCard(
                    icon: Icons.notifications_active_outlined,
                    label: 'Smart\nAlerts',
                    iconColor: const Color(0xFFF59E0B),
                    bgColor: const Color(0xFFFEF3D7),
                    highlighted: true)),
          ]),
          const SizedBox(height: 20),
          // Get Started button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A6BAA), Color(0xFF0D9E8A)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ElevatedButton(
                onPressed: _navigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Get Started',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward,
                          color: Colors.white, size: 18),
                    ]),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: _navigate,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                    color: Color(0xFFB8D0E8), width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Explore Features',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A6BAA))),
            ),
          ),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 2 — LOGIN
// ═══════════════════════════════════════════════════════════════════════════════

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;
  bool _loading = false;

  static const _credentials = {
    'admin@test.com': {'password': 'admin123', 'role': 'admin'},
    'user@test.com': {'password': 'user123', 'role': 'user'},
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _errorMessage = null;
      _loading = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;
    final entry = _credentials[email];

    if (entry == null || entry['password'] != password) {
      setState(() {
        _errorMessage = 'Invalid email or password. Please try again.';
        _loading = false;
      });
      return;
    }

    setState(() => _loading = false);

    if (!mounted) return;

    if (entry['role'] == 'admin') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const AdminDashboard()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const UserDashboard()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FF),
      body: Stack(children: [
        Positioned(
            top: -60,
            right: -60,
            child: _decorCircle(220, const Color(0xFF3B9EE8), 0.18)),
        Positioned(
            bottom: -80,
            left: -80,
            child: _decorCircle(260, const Color(0xFF3B9EE8), 0.10)),
        Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF3B9EE8).withOpacity(0.20),
                              blurRadius: 16,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: const Icon(Icons.add,
                          color: Color(0xFF3B9EE8), size: 32),
                    ),
                    const SizedBox(height: 16),
                    const Text('MediCare Portal',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A3A5C),
                            letterSpacing: -0.5)),
                    const SizedBox(height: 4),
                    const Text('Secure Health Management System',
                        style: TextStyle(
                            fontSize: 13, color: Color(0xFF8AAAC8))),
                    const SizedBox(height: 32),
                    // Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 24,
                              offset: const Offset(0, 6))
                        ],
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Welcome Back',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A3A5C))),
                            const SizedBox(height: 4),
                            const Text(
                                'Sign in to access your medical dashboard.',
                                style: TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFF8AAAC8))),
                            const SizedBox(height: 28),
                            // Email
                            _fieldLabel('Email Address'),
                            const SizedBox(height: 8),
                            _textField(
                                controller: _emailController,
                                hint: 'doctor@hospital.com',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress),
                            const SizedBox(height: 20),
                            // Password
                            _fieldLabel('Password'),
                            const SizedBox(height: 8),
                            _passwordField(),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {},
                                child: const Text('Forgot Password?',
                                    style: TextStyle(
                                        fontSize: 12.5,
                                        color: Color(0xFF3B9EE8),
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                            // Error
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
                                  Expanded(
                                      child: Text(_errorMessage!,
                                          style: const TextStyle(
                                              fontSize: 12.5,
                                              color: Color(0xFFB91C1C)))),
                                ]),
                              ),
                            ],
                            const SizedBox(height: 28),
                            // Sign In
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed: _loading ? null : _signIn,
                                icon: _loading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2))
                                    : const Icon(Icons.login_rounded,
                                        color: Colors.white, size: 18),
                                label: Text(
                                    _loading ? 'Signing in...' : 'Sign In',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B9EE8),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Hint
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F6FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text('Test credentials:',
                                        style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF4A6FA5))),
                                    SizedBox(height: 4),
                                    Text(
                                        '👨‍⚕️ Admin: admin@test.com / admin123',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF6B8BAE))),
                                    Text(
                                        '🧑 User:  user@test.com / user123',
                                        style: TextStyle(
                                            fontSize: 11,
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
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(opacity)),
      );

  Widget _fieldLabel(String text) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
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
            onTap: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            child: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF8AAAC8),
                size: 20),
          ),
        ),
      );

  InputDecoration _inputDecoration(
          {required String hint,
          required IconData prefixIcon,
          Widget? suffix}) =>
      InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: Color(0xFFB0C8E0), fontSize: 13.5),
        prefixIcon:
            Icon(prefixIcon, color: const Color(0xFF8AAAC8), size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF5F9FF),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Color(0xFFDDE8F5), width: 1.2)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Color(0xFFDDE8F5), width: 1.2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Color(0xFF3B9EE8), width: 1.5)),
      );
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 3 — ADMIN DASHBOARD
// ═══════════════════════════════════════════════════════════════════════════════

class StaffMember {
  final String name;
  final String role;
  final String email;
  final int score;
  final Color avatarColor;
  final String status;

  const StaffMember({
    required this.name,
    required this.role,
    required this.email,
    required this.score,
    required this.avatarColor,
    required this.status,
  });
}

final _staffList = [
  const StaffMember(
      name: 'Ali',
      role: 'Dr Physician',
      email: 'ali@hospital.com',
      score: 80,
      avatarColor: Color(0xFF3B9EE8),
      status: 'online'),
  const StaffMember(
      name: 'Sara',
      role: 'Sr Soldier',
      email: 'sara@hospital.com',
      score: 65,
      avatarColor: Color(0xFF22C55E),
      status: 'offline'),
  const StaffMember(
      name: 'Omar',
      role: 'Cardiologist',
      email: 'omar@hospital.com',
      score: 91,
      avatarColor: Color(0xFFF59E0B),
      status: 'online'),
  const StaffMember(
      name: 'Nour',
      role: 'Nurse',
      email: 'nour@hospital.com',
      score: 74,
      avatarColor: Color(0xFFEC4899),
      status: 'online'),
  const StaffMember(
      name: 'Karim',
      role: 'Radiologist',
      email: 'karim@hospital.com',
      score: 88,
      avatarColor: Color(0xFF8B5CF6),
      status: 'offline'),
];

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _searchController = TextEditingController();
  String _query = '';

  List<StaffMember> get _filtered => _staffList
      .where((s) =>
          s.name.toLowerCase().contains(_query.toLowerCase()) ||
          s.role.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LandingScreen()),
        (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FF),
      body: Column(children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildStaffSection(),
                ]),
          ),
        ),
      ]),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A6BAA), Color(0xFF3BB8E8)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(children: [
              const Icon(Icons.add, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              const Text('MediCare Portal',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500)),
              const Spacer(),
              GestureDetector(
                onTap: _logout,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.logout, color: Colors.white, size: 14),
                        SizedBox(width: 6),
                        Text('Logout',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ]),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 14),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Admin Dashboard',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Manage staff and monitor performance',
                style: TextStyle(color: Colors.white70, fontSize: 12.5)),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              _StatCard(
                  icon: Icons.people_outline,
                  value: '${_staffList.length}',
                  label: 'Members'),
              const SizedBox(width: 12),
              _StatCard(
                  icon: Icons.circle_outlined,
                  value:
                      '${_staffList.where((s) => s.status == 'online').length}',
                  label: 'Active'),
              const SizedBox(width: 12),
              _StatCard(
                  icon: Icons.bar_chart_rounded,
                  value:
                      '${(_staffList.map((s) => s.score).reduce((a, b) => a + b) / _staffList.length).round()}',
                  label: 'Avg Score'),
            ]),
          ),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  Widget _buildSearchBar() => TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v),
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A3A5C)),
        decoration: InputDecoration(
          hintText: 'Search by name or role...',
          hintStyle:
              const TextStyle(color: Color(0xFFB0C8E0), fontSize: 13.5),
          prefixIcon: const Icon(Icons.search,
              color: Color(0xFF8AAAC8), size: 20),
          suffixIcon: _query.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                  child: const Icon(Icons.close,
                      color: Color(0xFF8AAAC8), size: 18))
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFDDE8F5), width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Color(0xFF3B9EE8), width: 1.5)),
        ),
      );

  Widget _buildStaffSection() {
    final members = _filtered;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('${members.length} Staff Members',
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A3A5C))),
        const Spacer(),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF3B9EE8).withOpacity(0.10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text('→ All Roles',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF3B9EE8),
                  fontWeight: FontWeight.w600)),
        ),
      ]),
      const SizedBox(height: 14),
      if (members.isEmpty)
        const Center(
            child: Padding(
                padding: EdgeInsets.all(40),
                child: Text('No staff found.',
                    style: TextStyle(color: Color(0xFF8AAAC8)))))
      else
        ...members.map((s) => _StaffCard(member: s)),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 4 — USER DASHBOARD
// ═══════════════════════════════════════════════════════════════════════════════

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard>
    with TickerProviderStateMixin {
  late AnimationController _chartController;
  late AnimationController _pulseController;
  late Animation<double> _chartAnim;
  late Animation<double> _pulseAnim;

  final List<double> _dataPoints = [
    0.6, 0.55, 0.5, 0.58, 0.52, 0.48, 0.42, 0.38, 0.45,
    0.50, 0.55, 0.60, 0.58, 0.62, 0.65, 0.70, 0.68, 0.72,
    0.75, 0.70, 0.65, 0.68, 0.72, 0.78, 0.80,
  ];

  @override
  void initState() {
    super.initState();
    _chartController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..forward();
    _chartAnim = CurvedAnimation(
        parent: _chartController, curve: Curves.easeInOut);
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _chartController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LandingScreen()),
        (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('User Dashboard',
            style: TextStyle(
                color: Color(0xFF1A3A5C),
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        actions: [
          GestureDetector(
            onTap: _logout,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF3B9EE8).withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.logout, color: Color(0xFF3B9EE8), size: 14),
                SizedBox(width: 6),
                Text('Logout',
                    style: TextStyle(
                        color: Color(0xFF3B9EE8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE8F0FB), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label('Live Camera'),
          const SizedBox(height: 10),
          _buildCamera(),
          const SizedBox(height: 16),
          _buildScoreRow(),
          const SizedBox(height: 24),
          _label('Performance (Real-time)'),
          const SizedBox(height: 10),
          _buildChart(),
          const SizedBox(height: 24),
          _label('Sessions'),
          const SizedBox(height: 10),
          _buildSessionsList(),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  Widget _buildSessionsList() {
    final sessions = [
      _SessionData(
        title: 'Session 1',
        subtitle: 'Today, 09:00',
        score: 80,
        status: 'completed',
        date: 'Jun 19',
      ),
      _SessionData(
        title: 'Session 2',
        subtitle: 'Today, 11:30',
        score: 65,
        status: 'completed',
        date: 'Jun 19',
      ),
      _SessionData(
        title: 'Session 3',
        subtitle: 'Now · Live',
        score: null,
        status: 'live',
        date: 'Jun 19',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: sessions.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          final isLast = i == sessions.length - 1;
          return _SessionTile(session: s, isLast: isLast);
        }).toList(),
      ),
    );
  }

  Widget _label(String t) => Text(t,
      style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A3A5C)));

  Widget _buildCamera() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 200,
        color: Colors.black,
        child: Stack(alignment: Alignment.center, children: [
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, child) =>
                Transform.scale(scale: _pulseAnim.value, child: child),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle),
                child: const Icon(Icons.videocam_outlined,
                    color: Colors.white54, size: 36),
              ),
              const SizedBox(height: 8),
              const Text('Camera feed loading...',
                  style:
                      TextStyle(color: Colors.white38, fontSize: 12)),
            ]),
          ),
          Positioned(top: 12, left: 12, child: _LiveBadge()),
          ..._corners(),
        ]),
      ),
    );
  }

  List<Widget> _corners() {
    Widget c(AlignmentGeometry a, bool fx, bool fy) =>
        Positioned.fill(
          child: Align(
            alignment: a,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.diagonal3Values(fx ? -1 : 1, fy ? -1 : 1, 1),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CustomPaint(
                      painter: _CornerPainter(
                          color: Colors.white24, thickness: 2)),
                ),
              ),
            ),
          ),
        );
    return [
      c(Alignment.topLeft, false, false),
      c(Alignment.topRight, true, false),
      c(Alignment.bottomLeft, false, true),
      c(Alignment.bottomRight, true, true),
    ];
  }

  Widget _buildScoreRow() => Row(children: [
        Expanded(
            child: _MetricCard(
          label: 'Score',
          child: const Text('85',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
        )),
        const SizedBox(width: 12),
        Expanded(
            child: _MetricCard(
          label: 'Performance',
          child: Row(mainAxisSize: MainAxisSize.min, children: const [
            Text('Good',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            SizedBox(width: 6),
            Text('⚠️', style: TextStyle(fontSize: 20)),
          ]),
        )),
      ]);

  Widget _buildChart() => Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 3))
          ],
        ),
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
        child: AnimatedBuilder(
          animation: _chartAnim,
          builder: (_, __) => CustomPaint(
            painter: _ChartPainter(
              points: _dataPoints,
              progress: _chartAnim.value,
              lineColor: const Color(0xFF3B9EE8),
              fillColor: const Color(0xFF3B9EE8).withOpacity(0.12),
              gridColor: const Color(0xFFE8F0FB),
            ),
          ),
        ),
      );
}

// ═══════════════════════════════════════════════════════════════════════════════
// SESSION DATA & TILE
// ═══════════════════════════════════════════════════════════════════════════════

class _SessionData {
  final String title;
  final String subtitle;
  final int? score;
  final String status; // 'completed' | 'live'
  final String date;

  const _SessionData({
    required this.title,
    required this.subtitle,
    required this.score,
    required this.status,
    required this.date,
  });
}

class _SessionTile extends StatelessWidget {
  final _SessionData session;
  final bool isLast;

  const _SessionTile({required this.session, required this.isLast});

  Color get _scoreColor {
    final s = session.score;
    if (s == null) return const Color(0xFF3B9EE8);
    if (s >= 85) return const Color(0xFF22C55E);
    if (s >= 70) return const Color(0xFF3B9EE8);
    return const Color(0xFFF59E0B);
  }

  @override
  Widget build(BuildContext context) {
    final isLive = session.status == 'live';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Icon circle
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isLive
                      ? const Color(0xFF3B9EE8).withOpacity(0.12)
                      : const Color(0xFFF0F6FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLive
                      ? Icons.videocam_outlined
                      : Icons.medical_services_outlined,
                  color: isLive
                      ? const Color(0xFF3B9EE8)
                      : const Color(0xFF8AAAC8),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),

              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A3A5C),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        if (isLive) ...[
                          _PulseDot(),
                          const SizedBox(width: 5),
                        ],
                        Text(
                          session.subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: isLive
                                ? const Color(0xFF3B9EE8)
                                : const Color(0xFF8AAAC8),
                            fontWeight: isLive
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Right side: score badge or live button
              if (isLive)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B9EE8),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B9EE8).withOpacity(0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Text(
                    'View',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _scoreColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${session.score}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _scoreColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      session.date,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFB0C8E0),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: Color(0xFFF0F6FF),
          ),
      ],
    );
  }
}

class _PulseDot extends StatefulWidget {
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Opacity(
          opacity: _anim.value,
          child: Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF3B9EE8),
            ),
          ),
        ),
      );
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color bgColor;
  final bool highlighted;

  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.bgColor,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: highlighted ? const Color(0xFFFEF6E4) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: highlighted
              ? Border.all(color: const Color(0xFFFBD38D), width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 10),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                  height: 1.3)),
        ]),
      );
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: Column(children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500)),
          ]),
        ),
      );
}

class _StaffCard extends StatelessWidget {
  final StaffMember member;

  const _StaffCard({required this.member});

  Color get _scoreColor {
    if (member.score >= 85) return const Color(0xFF22C55E);
    if (member.score >= 70) return const Color(0xFF3B9EE8);
    return const Color(0xFFF59E0B);
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(children: [
          Stack(children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  color: member.avatarColor.withOpacity(0.15),
                  shape: BoxShape.circle),
              child: Center(
                  child: Text(member.name[0],
                      style: TextStyle(
                          color: member.avatarColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700))),
            ),
            Positioned(
                bottom: 1,
                right: 1,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: member.status == 'online'
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFCBD5E1),
                      border:
                          Border.all(color: Colors.white, width: 2)),
                )),
          ]),
          const SizedBox(width: 14),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(member.name,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A3A5C))),
                const SizedBox(height: 3),
                Row(children: [
                  const Icon(Icons.work_outline,
                      size: 12, color: Color(0xFF8AAAC8)),
                  const SizedBox(width: 4),
                  Text(member.role,
                      style: const TextStyle(
                          fontSize: 12.5, color: Color(0xFF8AAAC8))),
                ]),
                const SizedBox(height: 2),
                Text(member.email,
                    style: const TextStyle(
                        fontSize: 11.5, color: Color(0xFFB0C8E0))),
              ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: _scoreColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20)),
              child: Text('${member.score}',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _scoreColor)),
            ),
            const SizedBox(height: 6),
            Text(
                member.status == 'online' ? '● Online' : '● Offline',
                style: TextStyle(
                    fontSize: 11,
                    color: member.status == 'online'
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFCBD5E1),
                    fontWeight: FontWeight.w600)),
          ]),
        ]),
      );
}

class _MetricCard extends StatelessWidget {
  final String label;
  final Widget child;

  const _MetricCard({required this.label, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF1A6BAA), Color(0xFF3BB8E8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF3B9EE8).withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.white.withOpacity(0.75),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4)),
          const SizedBox(height: 8),
          child,
        ]),
      );
}

class _LiveBadge extends StatefulWidget {
  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          AnimatedBuilder(
              animation: _anim,
              builder: (_, __) => Opacity(
                    opacity: _anim.value,
                    child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFEF4444))),
                  )),
          const SizedBox(width: 6),
          const Text('LIVE',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2)),
        ]),
      );
}

class _BlinkingDot extends StatefulWidget {
  final Color color;
  const _BlinkingDot({required this.color});

  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Opacity(
            opacity: _anim.value,
            child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: widget.color)),
          ));
}

// ── Painters ──────────────────────────────────────────────────────────────────

class ECGPainter extends CustomPainter {
  final double progress;
  final Color color;

  ECGPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;
    final mid = h / 2;

    final path = Path()
      ..moveTo(0, mid)
      ..lineTo(w * 0.15, mid)
      ..lineTo(w * 0.2, mid - h * 0.3)
      ..lineTo(w * 0.25, mid + h * 0.4)
      ..lineTo(w * 0.35, mid - h * 0.8)
      ..lineTo(w * 0.4, mid + h * 0.2)
      ..lineTo(w * 0.45, mid)
      ..lineTo(w * 0.55, mid)
      ..lineTo(w * 0.6, mid - h * 0.2)
      ..lineTo(w * 0.65, mid)
      ..lineTo(w, mid);

    final metrics = path.computeMetrics().toList();
    if (metrics.isNotEmpty) {
      canvas.drawPath(
          metrics.first.extractPath(0, metrics.first.length * progress),
          paint);
    }
  }

  @override
  bool shouldRepaint(ECGPainter old) => old.progress != progress;
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double thickness;

  const _CornerPainter({required this.color, required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(
        Path()
          ..moveTo(0, size.height)
          ..lineTo(0, 0)
          ..lineTo(size.width, 0),
        paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}

class _ChartPainter extends CustomPainter {
  final List<double> points;
  final double progress;
  final Color lineColor;
  final Color fillColor;
  final Color gridColor;

  const _ChartPainter({
    required this.points,
    required this.progress,
    required this.lineColor,
    required this.fillColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final w = size.width;
    final h = size.height;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (int i = 1; i <= 4; i++) {
      canvas.drawLine(Offset(0, h * i / 5), Offset(w, h * i / 5), gridPaint);
    }

    final visible =
        (points.length * progress).ceil().clamp(2, points.length);
    final step = w / (points.length - 1);

    Offset pt(int i) =>
        Offset(i * step, h - (points[i] * h * 0.85) - h * 0.05);

    final line = Path()..moveTo(pt(0).dx, pt(0).dy);
    final fill = Path()
      ..moveTo(0, h)
      ..lineTo(pt(0).dx, pt(0).dy);

    for (int i = 1; i < visible; i++) {
      final p = pt(i - 1);
      final c = pt(i);
      final cx = (p.dx + c.dx) / 2;
      line.cubicTo(cx, p.dy, cx, c.dy, c.dx, c.dy);
      fill.cubicTo(cx, p.dy, cx, c.dy, c.dx, c.dy);
    }

    fill
      ..lineTo(pt(visible - 1).dx, h)
      ..close();

    canvas.drawPath(
        fill,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [fillColor, fillColor.withOpacity(0.0)],
          ).createShader(Rect.fromLTWH(0, 0, w, h))
          ..style = PaintingStyle.fill);

    canvas.drawPath(
        line,
        Paint()
          ..color = lineColor
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round);

    final last = pt(visible - 1);
    canvas.drawCircle(last, 5, Paint()..color = lineColor);
    canvas.drawCircle(last, 3, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_ChartPainter old) => old.progress != progress;
}
