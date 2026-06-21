import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MediCareApp());
}

class MediCareApp extends StatelessWidget {
  const MediCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediCare Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),
      home: const UserDashboard(),
    );
  }
}

// ── User Dashboard ────────────────────────────────────────────────────────────

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

  // Simulated real-time performance data points
  final List<double> _dataPoints = [
    0.6, 0.55, 0.5, 0.58, 0.52, 0.48, 0.42, 0.38, 0.45,
    0.50, 0.55, 0.60, 0.58, 0.62, 0.65, 0.70, 0.68, 0.72,
    0.75, 0.70, 0.65, 0.68, 0.72, 0.78, 0.80,
  ];

  final int _score = 85;
  final String _grade = 'Good';

  @override
  void initState() {
    super.initState();

    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();

    _chartAnim = CurvedAnimation(
      parent: _chartController,
      curve: Curves.easeInOut,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _chartController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF3B9EE8)),
        title: const Text(
          'User Dashboard',
          style: TextStyle(
            color: Color(0xFF1A3A5C),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE8F0FB), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Live Camera'),
            const SizedBox(height: 10),
            _buildCameraBox(),
            const SizedBox(height: 16),
            _buildScoreRow(),
            const SizedBox(height: 24),
            _sectionLabel('Performance (Real-time)'),
            const SizedBox(height: 10),
            _buildChart(),
          ],
        ),
      ),
    );
  }

  // ── Section label ────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A3A5C),
      ),
    );
  }

  // ── Live camera box ──────────────────────────────────────────────────────────

  Widget _buildCameraBox() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 200,
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Camera icon
            AnimatedBuilder(
              animation: _pulseAnim,
              builder: (context, child) => Transform.scale(
                scale: _pulseAnim.value,
                child: child,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.videocam_outlined,
                      color: Colors.white54,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Camera feed loading...',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),

            // Live badge top-left
            Positioned(
              top: 12,
              left: 12,
              child: _LiveBadge(),
            ),

            // Corner brackets
            ..._cornerBrackets(),
          ],
        ),
      ),
    );
  }

  List<Widget> _cornerBrackets() {
    const color = Colors.white24;
    const size = 18.0;
    const thick = 2.0;

    Widget corner(AlignmentGeometry alignment, bool flipX, bool flipY) {
      return Positioned.fill(
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.diagonal3Values(
                flipX ? -1 : 1,
                flipY ? -1 : 1,
                1,
              ),
              child: SizedBox(
                width: size,
                height: size,
                child: CustomPaint(
                  painter: _CornerPainter(color: color, thickness: thick),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return [
      corner(Alignment.topLeft, false, false),
      corner(Alignment.topRight, true, false),
      corner(Alignment.bottomLeft, false, true),
      corner(Alignment.bottomRight, true, true),
    ];
  }

  // ── Score + grade row ────────────────────────────────────────────────────────

  Widget _buildScoreRow() {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            label: 'Score',
            child: Text(
              '$_score',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            gradient: const LinearGradient(
              colors: [Color(0xFF1A6BAA), Color(0xFF3BB8E8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            label: 'Performance',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _grade,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                const Text('⚠️', style: TextStyle(fontSize: 20)),
              ],
            ),
            gradient: const LinearGradient(
              colors: [Color(0xFF1A6BAA), Color(0xFF3BB8E8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ],
    );
  }

  // ── Performance chart ────────────────────────────────────────────────────────

  Widget _buildChart() {
    return Container(
      width: double.infinity,
      height: 200,
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
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: AnimatedBuilder(
        animation: _chartAnim,
        builder: (context, _) {
          return CustomPaint(
            painter: _ChartPainter(
              points: _dataPoints,
              progress: _chartAnim.value,
              lineColor: const Color(0xFF3B9EE8),
              fillColor: const Color(0xFF3B9EE8).withOpacity(0.12),
              gridColor: const Color(0xFFE8F0FB),
            ),
          );
        },
      ),
    );
  }
}

// ── Metric card ───────────────────────────────────────────────────────────────

class _MetricCard extends StatelessWidget {
  final String label;
  final Widget child;
  final Gradient gradient;

  const _MetricCard({
    required this.label,
    required this.child,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B9EE8).withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              color: Colors.white.withOpacity(0.75),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

// ── Live badge ────────────────────────────────────────────────────────────────

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
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => Opacity(
              opacity: _anim.value,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEF4444),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'LIVE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Corner bracket painter ────────────────────────────────────────────────────

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

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}

// ── Chart painter ─────────────────────────────────────────────────────────────

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

    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    for (int i = 1; i <= 4; i++) {
      final y = h * i / 5;
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // Build path from data
    final visibleCount = (points.length * progress).ceil().clamp(2, points.length);
    final step = w / (points.length - 1);

    // Smooth bezier path
    final linePath = Path();
    final fillPath = Path();

    Offset _pt(int i) => Offset(
          i * step,
          h - (points[i] * h * 0.85) - h * 0.05,
        );

    fillPath.moveTo(0, h);
    fillPath.lineTo(_pt(0).dx, _pt(0).dy);
    linePath.moveTo(_pt(0).dx, _pt(0).dy);

    for (int i = 1; i < visibleCount; i++) {
      final prev = _pt(i - 1);
      final curr = _pt(i);
      final cpX = (prev.dx + curr.dx) / 2;
      linePath.cubicTo(cpX, prev.dy, cpX, curr.dy, curr.dx, curr.dy);
      fillPath.cubicTo(cpX, prev.dy, cpX, curr.dy, curr.dx, curr.dy);
    }

    // Close fill path
    fillPath.lineTo(_pt(visibleCount - 1).dx, h);
    fillPath.close();

    // Draw fill
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [fillColor, fillColor.withOpacity(0.0)],
        ).createShader(Rect.fromLTWH(0, 0, w, h))
        ..style = PaintingStyle.fill,
    );

    // Draw line
    canvas.drawPath(
      linePath,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Draw end dot
    if (visibleCount > 1) {
      final last = _pt(visibleCount - 1);
      canvas.drawCircle(
        last,
        5,
        Paint()..color = lineColor,
      );
      canvas.drawCircle(
        last,
        3,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(_ChartPainter old) => old.progress != progress;
}
