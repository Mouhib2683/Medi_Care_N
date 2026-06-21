import 'package:flutter/material.dart';

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
      home: const AdminDashboard(),
    );
  }
}

// ── Data models ──────────────────────────────────────────────────────────────

class StaffMember {
  final String name;
  final String role;
  final String email;
  final int score;
  final Color avatarColor;
  final String status; // 'online' | 'offline'

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
  StaffMember(
    name: 'Ali',
    role: 'Dr Physician',
    email: 'ali@hospital.com',
    score: 80,
    avatarColor: const Color(0xFF3B9EE8),
    status: 'online',
  ),
  StaffMember(
    name: 'Sara',
    role: 'Sr Soldier',
    email: 'sara@hospital.com',
    score: 65,
    avatarColor: const Color(0xFF22C55E),
    status: 'offline',
  ),
  StaffMember(
    name: 'Omar',
    role: 'Cardiologist',
    email: 'omar@hospital.com',
    score: 91,
    avatarColor: const Color(0xFFF59E0B),
    status: 'online',
  ),
  StaffMember(
    name: 'Nour',
    role: 'Nurse',
    email: 'nour@hospital.com',
    score: 74,
    avatarColor: const Color(0xFFEC4899),
    status: 'online',
  ),
  StaffMember(
    name: 'Karim',
    role: 'Radiologist',
    email: 'karim@hospital.com',
    score: 88,
    avatarColor: const Color(0xFF8B5CF6),
    status: 'offline',
  ),
];

// ── Main screen ───────────────────────────────────────────────────────────────

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FF),
      body: Column(
        children: [
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header with gradient ────────────────────────────────────────────────────

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top nav row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  const Icon(Icons.add, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  const Text(
                    'MediCare Portal',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.search,
                        color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Admin Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Manage staff and monitor performance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.5,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Stat cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _StatCard(
                    icon: Icons.people_outline,
                    value: '${_staffList.length}',
                    label: 'Members',
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    icon: Icons.circle_outlined,
                    value: '${_staffList.where((s) => s.status == 'online').length}',
                    label: 'Active',
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    icon: Icons.bar_chart_rounded,
                    value: '${(_staffList.map((s) => s.score).reduce((a, b) => a + b) / _staffList.length).round()}',
                    label: 'Avg Score',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Search bar ──────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return TextField(
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
                    color: Color(0xFF8AAAC8), size: 18),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE8F5), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF3B9EE8), width: 1.5),
        ),
      ),
    );
  }

  // ── Staff section ───────────────────────────────────────────────────────────

  Widget _buildStaffSection() {
    final members = _filtered;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${members.length} Staff Members',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A3A5C),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B9EE8).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '→ All Roles',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF3B9EE8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (members.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Text(
                'No staff found.',
                style: TextStyle(color: Color(0xFF8AAAC8)),
              ),
            ),
          )
        else
          ...members.map((s) => _StaffCard(member: s)),
      ],
    );
  }
}

// ── Stat card widget ──────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Staff card widget ─────────────────────────────────────────────────────────

class _StaffCard extends StatelessWidget {
  final StaffMember member;

  const _StaffCard({required this.member});

  Color get _scoreColor {
    if (member.score >= 85) return const Color(0xFF22C55E);
    if (member.score >= 70) return const Color(0xFF3B9EE8);
    return const Color(0xFFF59E0B);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with status dot
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: member.avatarColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    member.name[0],
                    style: TextStyle(
                      color: member.avatarColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
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
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Name & role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A3A5C),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.work_outline,
                        size: 12, color: Color(0xFF8AAAC8)),
                    const SizedBox(width: 4),
                    Text(
                      member.role,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF8AAAC8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  member.email,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFFB0C8E0),
                  ),
                ),
              ],
            ),
          ),

          // Score badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _scoreColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${member.score}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _scoreColor,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                member.status == 'online' ? '● Online' : '● Offline',
                style: TextStyle(
                  fontSize: 11,
                  color: member.status == 'online'
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFCBD5E1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
