import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MedAssistApp());
}

class MedAssistApp extends StatelessWidget {
  const MedAssistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedAssist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A6BAA)),
        useMaterial3: true,
      ),
      home: const MedAssistScreen(),
    );
  }
}

class MedAssistScreen extends StatefulWidget {
  const MedAssistScreen({super.key});

  @override
  State<MedAssistScreen> createState() => _MedAssistScreenState();
}

class _MedAssistScreenState extends State<MedAssistScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 700;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isWide
          ? _buildWideLayout(size)
          : _buildNarrowLayout(size),
    );
  }

  Widget _buildWideLayout(Size size) {
    return Row(
      children: [
        // Left panel
        Expanded(
          flex: 45,
          child: _buildLeftPanel(),
        ),
        // Right panel
        Expanded(
          flex: 55,
          child: _buildRightPanel(),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(Size size) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: _buildLeftPanel(),
          ),
          _buildRightPanel(),
        ],
      ),
    );
  }

  Widget _buildLeftPanel() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A6BAA),
            Color(0xFF0D9E8A),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background circle rings
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: child,
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer ring
                  Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                  ),
                  // Middle ring
                  Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  // Inner circle with cross
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // ECG wave behind cross
                        Positioned(
                          bottom: 35,
                          left: 10,
                          right: 10,
                          child: AnimatedBuilder(
                            animation: _waveController,
                            builder: (context, child) {
                              return CustomPaint(
                                size: const Size(120, 30),
                                painter: ECGPainter(
                                  progress: _waveController.value,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              );
                            },
                          ),
                        ),
                        // Plus icon
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 56,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Live badge
          Positioned(
            top: MediaQuery.of(context).size.height * 0.28,
            right: MediaQuery.of(context).size.width * 0.12,
            child: _LiveBadge(),
          ),
          // AI badge
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.28,
            left: MediaQuery.of(context).size.width * 0.08,
            child: _AIBadge(),
          ),
          // Dot decoration
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: MediaQuery.of(context).size.width * 0.05,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      color: const Color(0xFFF5F9FF),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFDDE8F5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF22C55E),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Healthcare Platform powered by Nourchaine',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF4A6FA5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'MedAssist',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A3A5C),
                letterSpacing: -1,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Intelligent Medical Monitoring & Scoring System',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B8BAE),
                fontWeight: FontWeight.w400,
              ),
            ),
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
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A6BAA).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.show_chart_rounded,
                      color: Color(0xFF1A6BAA),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About MedAssist',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A3A5C),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'An advanced clinical decision-support platform leveraging machine learning for real-time patient monitoring, automated severity scoring, and predictive health analytics.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B8BAE),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Feature cards row
            Row(
              children: [
                Expanded(
                  child: _FeatureCard(
                    icon: Icons.monitor_heart_outlined,
                    label: 'Real-time\nMonitoring',
                    iconColor: const Color(0xFF1A6BAA),
                    bgColor: const Color(0xFFEBF3FC),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _FeatureCard(
                    icon: Icons.psychology_outlined,
                    label: 'AI Scoring',
                    iconColor: const Color(0xFF0D9E8A),
                    bgColor: const Color(0xFFE8F7F4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _FeatureCard(
                    icon: Icons.notifications_active_outlined,
                    label: 'Smart\nAlerts',
                    iconColor: const Color(0xFFF59E0B),
                    bgColor: const Color(0xFFFEF3D7),
                    highlighted: true,
                  ),
                ),
              ],
            ),
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
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const SizedBox.shrink(),
                  label: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Explore Features button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFB8D0E8), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Explore Features',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A6BAA),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveBadge extends StatefulWidget {
  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.6, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Opacity(
                opacity: _animation.value,
                child: const Icon(Icons.favorite, color: Colors.red, size: 14),
              );
            },
          ),
          const SizedBox(width: 6),
          const Text(
            'Live',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A3A5C),
            ),
          ),
        ],
      ),
    );
  }
}

class _AIBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bar_chart, color: Color(0xFF1A6BAA), size: 16),
          const SizedBox(width: 6),
          const Text(
            'AI',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A3A5C),
            ),
          ),
        ],
      ),
    );
  }
}

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
  Widget build(BuildContext context) {
    return Container(
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: iconColor,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

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

    final path = Path();
    final w = size.width;
    final h = size.height;
    final mid = h / 2;

    // ECG-like path
    path.moveTo(0, mid);
    path.lineTo(w * 0.15, mid);
    path.lineTo(w * 0.2, mid - h * 0.3);
    path.lineTo(w * 0.25, mid + h * 0.4);
    path.lineTo(w * 0.35, mid - h * 0.8);
    path.lineTo(w * 0.4, mid + h * 0.2);
    path.lineTo(w * 0.45, mid);
    path.lineTo(w * 0.55, mid);
    path.lineTo(w * 0.6, mid - h * 0.2);
    path.lineTo(w * 0.65, mid);
    path.lineTo(w, mid);

    // Animate with dash effect
    final pathMetrics = path.computeMetrics().toList();
    if (pathMetrics.isNotEmpty) {
      final metric = pathMetrics.first;
      final totalLength = metric.length;
      final drawLength = totalLength * progress;
      final extractPath = metric.extractPath(0, drawLength);
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(ECGPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
