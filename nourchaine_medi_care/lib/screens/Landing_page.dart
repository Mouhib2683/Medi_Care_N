import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart';
import 'login_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
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

  void _navigate() => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );

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

  // ── Left panel ──────────────────────────────────────────────────────────────

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
          child: _floatingBadge(Row(mainAxisSize: MainAxisSize.min, children: [
            const BlinkingDot(color: Colors.red),
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
          child: _floatingBadge(Row(mainAxisSize: MainAxisSize.min, children: [
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

  // ── Right panel ─────────────────────────────────────────────────────────────

  Widget _buildRight() {
    return Container(
      color: const Color(0xFFF5F9FF),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Status badge
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
          // Feature row
          Row(children: [
            Expanded(
                child: FeatureCard(
                    icon: Icons.monitor_heart_outlined,
                    label: 'Real-time\nMonitoring',
                    iconColor: const Color(0xFF1A6BAA),
                    bgColor: const Color(0xFFEBF3FC))),
            const SizedBox(width: 12),
            Expanded(
                child: FeatureCard(
                    icon: Icons.psychology_outlined,
                    label: 'AI Scoring',
                    iconColor: const Color(0xFF0D9E8A),
                    bgColor: const Color(0xFFE8F7F4))),
            const SizedBox(width: 12),
            Expanded(
                child: FeatureCard(
                    icon: Icons.notifications_active_outlined,
                    label: 'Smart\nAlerts',
                    iconColor: const Color(0xFFF59E0B),
                    bgColor: const Color(0xFFFEF3D7),
                    highlighted: true)),
          ]),
          const SizedBox(height: 20),
          // Get Started
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
                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
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
                side: const BorderSide(color: Color(0xFFB8D0E8), width: 1.5),
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