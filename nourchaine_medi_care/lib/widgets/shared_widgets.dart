import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Blinking dot (used in landing page "Live" badge)
// ─────────────────────────────────────────────────────────────────────────────

class BlinkingDot extends StatefulWidget {
  final Color color;
  final double size;
  const BlinkingDot({super.key, required this.color, this.size = 8});

  @override
  State<BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<BlinkingDot>
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
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: widget.color)),
          ));
}

// ─────────────────────────────────────────────────────────────────────────────
// Pulsing dot (used in session list "live" row)
// ─────────────────────────────────────────────────────────────────────────────

class PulseDot extends StatefulWidget {
  const PulseDot({super.key});

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot>
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

// ─────────────────────────────────────────────────────────────────────────────
// Live camera badge
// ─────────────────────────────────────────────────────────────────────────────

class LiveBadge extends StatefulWidget {
  const LiveBadge({super.key});

  @override
  State<LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<LiveBadge>
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

// ─────────────────────────────────────────────────────────────────────────────
// Feature card (landing page)
// ─────────────────────────────────────────────────────────────────────────────

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color bgColor;
  final bool highlighted;

  const FeatureCard({
    super.key,
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

// ─────────────────────────────────────────────────────────────────────────────
// Metric card (user dashboard score/perf)
// ─────────────────────────────────────────────────────────────────────────────

class MetricCard extends StatelessWidget {
  final String label;
  final Widget child;

  const MetricCard({super.key, required this.label, required this.child});

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

// ─────────────────────────────────────────────────────────────────────────────
// Error / empty state widget
// ─────────────────────────────────────────────────────────────────────────────

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorStateWidget(
      {super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_rounded,
                  color: Color(0xFFEF4444), size: 36),
            ),
            const SizedBox(height: 16),
            const Text('Connection Error',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A3A5C))),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF8AAAC8), height: 1.5)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B9EE8),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ]),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Painters
// ─────────────────────────────────────────────────────────────────────────────

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

class CornerPainter extends CustomPainter {
  final Color color;
  final double thickness;

  const CornerPainter({required this.color, required this.thickness});

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
  bool shouldRepaint(CornerPainter old) => false;
}

class ChartPainter extends CustomPainter {
  final List<double> points;
  final double progress;
  final Color lineColor;
  final Color fillColor;
  final Color gridColor;

  const ChartPainter({
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
  bool shouldRepaint(ChartPainter old) => old.progress != progress;
}
