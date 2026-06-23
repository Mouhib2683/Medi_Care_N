import 'package:flutter/material.dart';
import '../models/user_data.dart';
import '../models/session_record.dart';
import '../widgets/shared_widgets.dart';
import 'Landing_page.dart';
import '../services/evaluation_store.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Admin Dashboard
// ─────────────────────────────────────────────────────────────────────────────

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  void _logout() => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LandingPage()),
      (_) => false);

  List<UserAccount> get _users => kUserAccounts.values.toList();

  double get _overallAvg {
    final allRecords = _users.expand((u) => u.records).toList();
    if (allRecords.isEmpty) return 0;
    return allRecords.fold(0.0, (a, r) => a + r.scoreValue) /
        allRecords.length;
  }

  // ── Send-evaluation bottom sheet ───────────────────────────────────────────

  void _showSendEvaluation(BuildContext context, UserAccount account) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SendEvaluationSheet(
        account: account,
        controller: controller,
        onSend: (msg) {
          EvaluationStore.instance.send(
            toEmail: account.email,
            message: msg,
          );
          if (mounted) setState(() {}); // refresh badge counts on cards
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FF),
      body: Column(children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildSummaryRow(),
              const SizedBox(height: 28),
              Row(children: [
                const Text('Staff Members',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A3A5C))),
                const Spacer(),
                Text('${_users.length} users',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF8AAAC8))),
              ]),
              const SizedBox(height: 12),
              ..._users.map((u) => _UserCard(
                    account: u,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AdminUserDetailPage(account: u)),
                    ),
                    onSendEval: () => _showSendEvaluation(context, u),
                  )),
            ]),
          ),
        ),
      ]),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

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
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:
                      const Row(mainAxisSize: MainAxisSize.min, children: [
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
            child: Text('Monitor staff performance and session data',
                style: TextStyle(color: Colors.white70, fontSize: 12.5)),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              _StatChip(
                  icon: Icons.people_outline,
                  value: '${_users.length}',
                  label: 'Staff'),
              const SizedBox(width: 12),
              _StatChip(
                  icon: Icons.assignment_outlined,
                  value:
                      '${_users.fold(0, (a, u) => a + u.records.length)}',
                  label: 'Sessions'),
              const SizedBox(width: 12),
              _StatChip(
                  icon: Icons.bar_chart_rounded,
                  value: '${_overallAvg.toStringAsFixed(0)}%',
                  label: 'Avg Score'),
            ]),
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  // ── Summary row ────────────────────────────────────────────────────────────

  Widget _buildSummaryRow() {
    final best =
        _users.reduce((a, b) => a.avgScore > b.avgScore ? a : b);
    return Row(children: [
      Expanded(
          child: _SummaryCard(
              icon: Icons.emoji_events_outlined,
              label: 'Top Performer',
              value: best.name.split(' ').last,
              sub: '${best.avgScore.toStringAsFixed(0)}% avg',
              color: const Color(0xFFF59E0B))),
      const SizedBox(width: 12),
      Expanded(
          child: _SummaryCard(
              icon: Icons.show_chart_rounded,
              label: 'Overall Avg',
              value: '${_overallAvg.toStringAsFixed(1)}%',
              sub: 'across all staff',
              color: const Color(0xFF3B9EE8))),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Send Evaluation Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _SendEvaluationSheet extends StatefulWidget {
  final UserAccount account;
  final TextEditingController controller;
  final void Function(String) onSend;

  const _SendEvaluationSheet({
    required this.account,
    required this.controller,
    required this.onSend,
  });

  @override
  State<_SendEvaluationSheet> createState() => _SendEvaluationSheetState();
}

class _SendEvaluationSheetState extends State<_SendEvaluationSheet> {
  bool _sending = false;

  void _submit() async {
    final msg = widget.controller.text.trim();
    if (msg.isEmpty) return;
    setState(() => _sending = true);
    await Future.delayed(const Duration(milliseconds: 300));
    widget.onSend(msg);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text('Evaluation sent to ${widget.account.name.split(' ').first}'),
          ]),
          backgroundColor: const Color(0xFF0D9E8A),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      margin: EdgeInsets.fromLTRB(12, 0, 12, bottom + 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, -4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0EAF5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Recipient row
          Row(children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF3B9EE8).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(widget.account.avatarInitials,
                    style: const TextStyle(
                        color: Color(0xFF3B9EE8),
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text('Send Evaluation',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A3A5C))),
                Text('To: ${widget.account.name}',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF8AAAC8))),
              ]),
            ),
          ]),
          const SizedBox(height: 18),

          // Text field
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFDCEAF8)),
            ),
            child: TextField(
              controller: widget.controller,
              maxLines: 5,
              minLines: 3,
              autofocus: true,
              style: const TextStyle(
                  fontSize: 13.5, color: Color(0xFF1A3A5C), height: 1.5),
              decoration: const InputDecoration(
                hintText: 'Write your feedback here…',
                hintStyle:
                    TextStyle(color: Color(0xFFB0C8E0), fontSize: 13.5),
                contentPadding: EdgeInsets.all(14),
                border: InputBorder.none,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 16),

          // Send button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: (widget.controller.text.trim().isEmpty || _sending)
                  ? null
                  : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B9EE8),
                disabledBackgroundColor:
                    const Color(0xFF3B9EE8).withOpacity(0.35),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: _sending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send_rounded,
                            size: 16, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Send Evaluation',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Admin User Detail Page
// ─────────────────────────────────────────────────────────────────────────────

class AdminUserDetailPage extends StatefulWidget {
  final UserAccount account;
  const AdminUserDetailPage({super.key, required this.account});

  @override
  State<AdminUserDetailPage> createState() => _AdminUserDetailPageState();
}

class _AdminUserDetailPageState extends State<AdminUserDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _chartController;
  late Animation<double> _chartAnim;

  @override
  void initState() {
    super.initState();
    _chartController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..forward();
    _chartAnim =
        CurvedAnimation(parent: _chartController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _chartController.dispose();
    super.dispose();
  }

  void _showSendEvaluation() {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SendEvaluationSheet(
        account: widget.account,
        controller: controller,
        onSend: (msg) {
          EvaluationStore.instance.send(
            toEmail: widget.account.email,
            message: msg,
          );
          if (mounted) setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final account = widget.account;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A6BAA),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(account.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          Text(account.role,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.75), fontSize: 11)),
        ]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Send evaluation action button
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              onPressed: _showSendEvaluation,
              icon: const Icon(Icons.rate_review_outlined,
                  color: Colors.white, size: 16),
              label: const Text('Evaluate',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildBanner(account),
          const SizedBox(height: 20),
          _buildScoreRow(account),
          const SizedBox(height: 20),
          _buildDistribution(account),
          const SizedBox(height: 20),
          _sectionLabel('Performance Trend'),
          const SizedBox(height: 10),
          _buildChart(account),
          const SizedBox(height: 20),
          _sectionLabel('Session Records'),
          const SizedBox(height: 4),
          Text('${account.records.length} sessions · ${account.department}',
              style: const TextStyle(
                  fontSize: 11.5, color: Color(0xFFB0C8E0))),
          const SizedBox(height: 10),
          ...account.records.asMap().entries
              .map((e) => _RecordRow(record: e.value, index: e.key)),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _sectionLabel(String t) => Text(t,
      style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A3A5C)));

  Widget _buildBanner(UserAccount account) => Container(
        padding: const EdgeInsets.all(18),
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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withOpacity(0.4), width: 2),
            ),
            child: Center(
                child: Text(account.avatarInitials,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700))),
          ),
          const SizedBox(width: 14),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(account.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(account.role,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 12.5)),
                Text(account.department,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 11.5)),
              ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${account.avgScore.toStringAsFixed(0)}%',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800)),
            Text('avg score',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7), fontSize: 11)),
          ]),
        ]),
      );

  Widget _buildScoreRow(UserAccount account) => Row(children: [
        Expanded(
            child: _DetailCard(
                label: 'Total Sessions',
                value: '${account.records.length}',
                icon: Icons.assignment_outlined,
                color: const Color(0xFF3B9EE8))),
        const SizedBox(width: 12),
        Expanded(
            child: _DetailCard(
                label: 'Performance',
                value: account.performanceLabel,
                icon: Icons.insights_rounded,
                color: const Color(0xFF0D9E8A))),
      ]);

  Widget _buildDistribution(UserAccount account) {
    final high =
        account.records.where((r) => r.scoreValue >= 85).length;
    final mid = account.records
        .where((r) => r.scoreValue >= 70 && r.scoreValue < 85)
        .length;
    final low =
        account.records.where((r) => r.scoreValue < 70).length;
    final total = account.records.length;

    return Container(
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
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Score Distribution',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A3A5C))),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
              child: _DistBar(
                  label: '≥ 85%',
                  count: high,
                  total: total,
                  color: const Color(0xFF22C55E))),
          const SizedBox(width: 8),
          Expanded(
              child: _DistBar(
                  label: '70–84%',
                  count: mid,
                  total: total,
                  color: const Color(0xFF3B9EE8))),
          const SizedBox(width: 8),
          Expanded(
              child: _DistBar(
                  label: '< 70%',
                  count: low,
                  total: total,
                  color: const Color(0xFFF59E0B))),
        ]),
      ]),
    );
  }

  Widget _buildChart(UserAccount account) => Container(
        width: double.infinity,
        height: 190,
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
// Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _UserCard extends StatelessWidget {
  final UserAccount account;
  final VoidCallback onTap;
  final VoidCallback onSendEval;

  const _UserCard({
    required this.account,
    required this.onTap,
    required this.onSendEval,
  });

  static const _avatarColors = [
    Color(0xFF3B9EE8),
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
  ];

  Color get _avatarColor {
    final idx = kUserAccounts.keys.toList().indexOf(account.email) %
        _avatarColors.length;
    return _avatarColors[idx];
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = account.avgScore >= 85
        ? const Color(0xFF22C55E)
        : account.avgScore >= 70
            ? const Color(0xFF3B9EE8)
            : const Color(0xFFF59E0B);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
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
        child: Column(children: [
          Row(children: [
            // Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _avatarColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                  child: Text(account.avatarInitials,
                      style: TextStyle(
                          color: _avatarColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700))),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(account.name,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A3A5C))),
                  const SizedBox(height: 3),
                  Row(children: [
                    const Icon(Icons.work_outline,
                        size: 12, color: Color(0xFF8AAAC8)),
                    const SizedBox(width: 4),
                    Text(account.role,
                        style: const TextStyle(
                            fontSize: 12.5, color: Color(0xFF8AAAC8))),
                  ]),
                  const SizedBox(height: 2),
                  Text(account.email,
                      style: const TextStyle(
                          fontSize: 11.5, color: Color(0xFFB0C8E0))),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: account.avgScore / 100,
                      minHeight: 5,
                      backgroundColor: scoreColor.withOpacity(0.12),
                      valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                    ),
                  ),
                ])),
            const SizedBox(width: 14),
            // Right side
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20)),
                child: Text('${account.avgScore.toStringAsFixed(0)}%',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: scoreColor)),
              ),
              const SizedBox(height: 6),
              Text('${account.records.length} sessions',
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFFB0C8E0))),
              const SizedBox(height: 6),
              const Row(children: [
                Text('View',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF3B9EE8),
                        fontWeight: FontWeight.w600)),
                SizedBox(width: 3),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 11, color: Color(0xFF3B9EE8)),
              ]),
            ]),
          ]),

          // ── Send evaluation button ────────────────────────────────────────
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F6FF)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onSendEval,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFF3B9EE8).withOpacity(0.07),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color(0xFF3B9EE8).withOpacity(0.18)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rate_review_outlined,
                      size: 14, color: Color(0xFF3B9EE8)),
                  SizedBox(width: 6),
                  Text('Send Evaluation',
                      style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3B9EE8))),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _RecordRow extends StatelessWidget {
  final SessionRecord record;
  final int index;

  const _RecordRow({required this.record, required this.index});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(children: [
          Row(children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF3B9EE8).withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Center(
                  child: Text('${index + 1}',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3B9EE8)))),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Session ${index + 1}',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A3A5C))),
                  if (record.timestamp.isNotEmpty)
                    Text(record.timestamp,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFFB0C8E0))),
                ])),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: record.scoreColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(record.scorePercent,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: record.scoreColor)),
            ),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: _field(
                    Icons.category_outlined, 'Object', record.objectStatus)),
            const SizedBox(width: 8),
            Expanded(
                child: _field(
                    Icons.pan_tool_outlined, 'Gripper', record.gripperAngle)),
            const SizedBox(width: 8),
            Expanded(
                child: _field(Icons.content_cut_outlined, 'Scissor',
                    record.scissorAngle)),
          ]),
        ]),
      );

  Widget _field(IconData icon, String label, String value) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F9FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, size: 12, color: const Color(0xFF8AAAC8)),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF8AAAC8),
                    fontWeight: FontWeight.w500)),
          ]),
          const SizedBox(height: 3),
          Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A3A5C))),
        ]),
      );
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatChip(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: Column(children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
          ]),
        ),
      );
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String sub;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
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
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8AAAC8),
                        fontWeight: FontWeight.w500)),
                Text(value,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: color)),
                Text(sub,
                    style: const TextStyle(
                        fontSize: 10.5, color: Color(0xFFB0C8E0))),
              ])),
        ]),
      );
}

class _DetailCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _DetailCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF8AAAC8),
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: color)),
              ])),
        ]),
      );
}

class _DistBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _DistBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : count / total;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Text(label,
          style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF8AAAC8),
              fontWeight: FontWeight.w500)),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: pct,
          minHeight: 8,
          backgroundColor: color.withOpacity(0.12),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
      const SizedBox(height: 4),
      Text('$count / $total',
          style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: color)),
    ]);
  }
}