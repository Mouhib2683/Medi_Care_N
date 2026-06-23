import 'package:flutter/material.dart';
import '../models/user_data.dart';
import '../models/session_record.dart';
import '../widgets/shared_widgets.dart';
import 'Landing_page.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../services/api_service.dart';

class UserPage extends StatefulWidget {
  final UserAccount account;
  const UserPage({super.key, required this.account});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with TickerProviderStateMixin {
  List<Widget> _corners() {
  Widget c(Alignment a, bool fx, bool fy) => Positioned.fill(
        child: Align(
          alignment: a,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.diagonal3Values(
                fx ? -1 : 1,
                fy ? -1 : 1,
                1,
              ),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CustomPaint(
                  painter: CornerPainter(
                    color: Colors.white24,
                    thickness: 2,
                  ),
                ),
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
  late AnimationController _chartController;
  late AnimationController _pulseController;
  late Animation<double> _chartAnim;
  late Animation<double> _pulseAnim;
  late final Player _player;
  late final VideoController _videoController;
  bool _isPlaying = false;
  Future<void> _loadVideo() async {
  try {
    final email = widget.account.email;

    final url = await ApiService.getUserVideo(email);

    debugPrint("VIDEO URL = $url");

    if (!mounted) return;

    if (url == null || url.isEmpty) return;

    await _player.stop();

    await _player.open(
      Media(url),
      play: true,
    );

    debugPrint("🎬 VIDEO STARTED SUCCESSFULLY");
  } catch (e) {
    debugPrint("❌ VIDEO LOAD ERROR: $e");
  }
}

  @override
  void initState() {
  super.initState();

  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  _player = Player();
  _videoController = VideoController(_player);

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

  // Rebuild whenever playing state changes so the Video widget shows up
  _player.stream.playing.listen((playing) {
    if (mounted) setState(() => _isPlaying = playing);
  });

  _loadVideo();
}

  @override
void dispose() {
  _chartController.dispose();
  _pulseController.dispose();

  _player.dispose();

  super.dispose();
}
  void _logout() => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LandingPage()),
      (_) => false);

  @override
  Widget build(BuildContext context) {
    final account = widget.account;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(account.name,
              style: const TextStyle(
                  color: Color(0xFF1A3A5C),
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          Text(account.role,
              style: const TextStyle(
                  color: Color(0xFF8AAAC8), fontSize: 11)),
        ]),
        actions: [
          GestureDetector(
            onTap: _logout,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF3B9EE8).withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.logout, color: Color(0xFF3B9EE8), size: 14),
                SizedBox(width: 6),
                Text('Logout',
                    style: TextStyle(color: Color(0xFF3B9EE8),
                        fontSize: 12, fontWeight: FontWeight.w600)),
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
          // User info banner
          _buildUserBanner(account),
          const SizedBox(height: 16),
          _sectionLabel('Live Camera'),
          const SizedBox(height: 10),
          _buildCamera(),
          const SizedBox(height: 16),
          _buildScoreRow(account),
          const SizedBox(height: 24),
          _sectionLabel('Performance Trend'),
          const SizedBox(height: 10),
          _buildChart(account),
          const SizedBox(height: 24),
          _sectionLabel('Session Records'),
          const SizedBox(height: 4),
          Text('${account.records.length} recorded sessions · ${account.department}',
              style: const TextStyle(fontSize: 11.5, color: Color(0xFFB0C8E0))),
          const SizedBox(height: 10),
          ...account.records.asMap().entries.map(
              (e) => _RecordCard(record: e.value, index: e.key)),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  // ── User banner ────────────────────────────────────────────────────────────

  Widget _buildUserBanner(UserAccount account) => Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
            ),
            child: Center(
                child: Text(account.avatarInitials,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700))),
          ),
          const SizedBox(width: 14),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(account.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(account.role,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8), fontSize: 12)),
            Text(account.department,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.65), fontSize: 11)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('${account.records.length} sessions',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ),
          ]),
        ]),
      );

  // ── Section label ──────────────────────────────────────────────────────────

  Widget _sectionLabel(String t) => Text(t,
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A3A5C)));

  // ── Camera ─────────────────────────────────────────────────────────────────

  Widget _buildCamera() => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Container(
      width: double.infinity,
      height: 200,
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // =========================
          // VIDEO (media_kit)
          // =========================
          if (_isPlaying)
            Positioned.fill(
              child: Video(
                controller: _videoController,
                fit: BoxFit.cover,
              ),
            )
          else
            AnimatedBuilder(
              animation: _pulseAnim,
              builder: (_, child) =>
                  Transform.scale(scale: _pulseAnim.value, child: child),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.videocam_outlined,
                    color: Colors.white54,
                    size: 36,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Loading video…',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

          const Positioned(top: 12, left: 12, child: LiveBadge()),
          ..._corners(),
        ],
      ),
    ),
  );

  // ── Score row ──────────────────────────────────────────────────────────────

  Widget _buildScoreRow(UserAccount account) => Row(
  children: [
    Expanded(
      child: MetricCard(
        label: 'Avg Score',
        child: Text(
          '${account.avgScore.toStringAsFixed(0)}%',
        ),
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: MetricCard(
        label: 'Performance',
        child: Text(account.performanceLabel),
      ),
    ),
  ],
);

  // ── Chart ──────────────────────────────────────────────────────────────────

  Widget _buildChart(UserAccount account) => Container(
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
            painter: ChartPainter(
              points: account.chartPoints,
              progress: _chartAnim.value,
              lineColor: const Color(0xFF3B9EE8),
              fillColor: const Color(0xFF3B9EE8).withOpacity(0.12),
              gridColor: const Color(0xFFE8F0FB),
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Record card
// ─────────────────────────────────────────────────────────────────────────────

class _RecordCard extends StatelessWidget {
  final SessionRecord record;
  final int index;

  const _RecordCard({required this.record, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF3B9EE8).withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Center(
                child: Text('${index + 1}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3B9EE8)))),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Session ${index + 1}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A3A5C))),
                if (record.timestamp.isNotEmpty)
                  Text(record.timestamp,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFFB0C8E0))),
              ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: record.scoreColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(record.scorePercent,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: record.scoreColor)),
          ),
        ]),
        const SizedBox(height: 14),
        const Divider(height: 1, color: Color(0xFFF0F6FF)),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: _field(Icons.category_outlined,   'Object Status',  record.objectStatus)),
          const SizedBox(width: 10),
          Expanded(child: _field(Icons.speed_outlined,      'Score',          record.scorePercent)),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: _field(Icons.pan_tool_outlined,    'Gripper Angle', record.gripperAngle)),
          const SizedBox(width: 10),
          Expanded(child: _field(Icons.content_cut_outlined, 'Scissor Angle', record.scissorAngle)),
        ]),
      ]),
    );
  }

  Widget _field(IconData icon, String label, String value) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F9FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Icon(icon, size: 16, color: const Color(0xFF8AAAC8)),
          const SizedBox(width: 8),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF8AAAC8),
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A3A5C))),
              ])),
        ]),
      );
}