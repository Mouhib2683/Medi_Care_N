import 'session_record.dart';

class UserAccount {
  final String name;
  final String email;
  final String password;
  final String role;        // 'surgeon' | 'nurse' | 'therapist'
  final String department;
  final String avatarInitials;
  final List<SessionRecord> records;

  const UserAccount({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.department,
    required this.avatarInitials,
    required this.records,
  });

  // Chart points derived from scores (normalised 0–1)
  List<double> get chartPoints =>
      records.map((r) => (r.scoreValue / 100).clamp(0.0, 1.0)).toList();

  double get avgScore {
    if (records.isEmpty) return 0;
    return records.fold(0.0, (a, r) => a + r.scoreValue) / records.length;
  }

  String get performanceLabel {
    final s = avgScore;
    if (s >= 85) return 'Excellent ✅';
    if (s >= 70) return 'Good ⚠️';
    return 'Low ❌';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Static user database
// ─────────────────────────────────────────────────────────────────────────────

final kUserAccounts = <String, UserAccount>{
  // ── User 1: Dr. Karim — Orthopedic Surgeon ───────────────────────────────
  'karim.mansouri@medicare.com': UserAccount(
    name: 'Karim Mansouri',
    email: 'karim.mansouri@medicare.com',
    password: 'Karim@2024',
    role: 'Etudiant en 3éme année',
    department: '',
    avatarInitials: 'KM',
    records: const [
      SessionRecord(objectStatus: 'Scalpel Detected',    gripperAngle: '42°',  scissorAngle: '18°',  scorePercent: '91%', timestamp: 'Jun 19 · 08:04'),
      SessionRecord(objectStatus: 'Forceps Detected',    gripperAngle: '37°',  scissorAngle: '22°',  scorePercent: '88%', timestamp: 'Jun 19 · 08:17'),
      SessionRecord(objectStatus: 'Scalpel Detected',    gripperAngle: '45°',  scissorAngle: '20°',  scorePercent: '93%', timestamp: 'Jun 19 · 08:31'),
      SessionRecord(objectStatus: 'Retractor Detected',  gripperAngle: '50°',  scissorAngle: '15°',  scorePercent: '87%', timestamp: 'Jun 19 · 08:45'),
      SessionRecord(objectStatus: 'Forceps Detected',    gripperAngle: '39°',  scissorAngle: '24°',  scorePercent: '85%', timestamp: 'Jun 19 · 09:02'),
      SessionRecord(objectStatus: 'Scissors Detected',   gripperAngle: '33°',  scissorAngle: '55°',  scorePercent: '90%', timestamp: 'Jun 19 · 09:18'),
      SessionRecord(objectStatus: 'Scalpel Detected',    gripperAngle: '44°',  scissorAngle: '19°',  scorePercent: '94%', timestamp: 'Jun 19 · 09:33'),
      SessionRecord(objectStatus: 'Retractor Detected',  gripperAngle: '48°',  scissorAngle: '17°',  scorePercent: '89%', timestamp: 'Jun 19 · 09:50'),
      SessionRecord(objectStatus: 'Forceps Detected',    gripperAngle: '36°',  scissorAngle: '23°',  scorePercent: '92%', timestamp: 'Jun 19 · 10:05'),
      SessionRecord(objectStatus: 'Scalpel Detected',    gripperAngle: '41°',  scissorAngle: '21°',  scorePercent: '96%', timestamp: 'Jun 19 · 10:20'),
    ],
  ),

  // ── User 2: Nurse Sara — ICU Nurse ───────────────────────────────────────
  'sara.benlamine@medicare.com': UserAccount(
    name: 'Sara Benlamine',
    email: 'sara.benlamine@medicare.com',
    password: 'Sara@2024',
    role: 'Etudiante en 4éme année',
    department: '',
    avatarInitials: 'SB',
    records: const [
      SessionRecord(objectStatus: 'Syringe Detected',    gripperAngle: '28°',  scissorAngle: '10°',  scorePercent: '20%', timestamp: 'Jun 19 · 07:15'),
      SessionRecord(objectStatus: 'IV Bag Detected',     gripperAngle: '31°',  scissorAngle: '08°',  scorePercent: '70%', timestamp: 'Jun 19 · 07:40'),
      SessionRecord(objectStatus: 'Syringe Detected',    gripperAngle: '25°',  scissorAngle: '12°',  scorePercent: '78%', timestamp: 'Jun 19 · 08:00'),
      SessionRecord(objectStatus: 'Bandage Detected',    gripperAngle: '22°',  scissorAngle: '09°',  scorePercent: '65%', timestamp: 'Jun 19 · 08:20'),
      SessionRecord(objectStatus: 'IV Bag Detected',     gripperAngle: '30°',  scissorAngle: '11°',  scorePercent: '10%', timestamp: 'Jun 19 · 08:45'),
      SessionRecord(objectStatus: 'Syringe Detected',    gripperAngle: '27°',  scissorAngle: '13°',  scorePercent: '76%', timestamp: 'Jun 19 · 09:10'),
      SessionRecord(objectStatus: 'Bandage Detected',    gripperAngle: '20°',  scissorAngle: '07°',  scorePercent: '63%', timestamp: 'Jun 19 · 09:30'),
      SessionRecord(objectStatus: 'IV Bag Detected',     gripperAngle: '33°',  scissorAngle: '10°',  scorePercent: '7%', timestamp: 'Jun 19 · 09:55'),
      SessionRecord(objectStatus: 'Syringe Detected',    gripperAngle: '26°',  scissorAngle: '14°',  scorePercent: '75%', timestamp: 'Jun 19 · 10:15'),
      SessionRecord(objectStatus: 'Bandage Detected',    gripperAngle: '24°',  scissorAngle: '08°',  scorePercent: '68%', timestamp: 'Jun 19 · 10:40'),
    ],
  ),

  // ── User 3: Dr. Amira — Physical Therapist ───────────────────────────────
  'amira.hadj@medicare.com': UserAccount(
    name: 'Amira Hadj',
    email: 'amira.hadj@medicare.com',
    password: 'Amira@2024',
    role: 'Etudiante en 5éme année',
    department: '',
    avatarInitials: 'AH',
    records: const [
      SessionRecord(objectStatus: 'Grip Tool Detected',  gripperAngle: '60°',  scissorAngle: '30°',  scorePercent: '82%', timestamp: 'Jun 19 · 09:00'),
      SessionRecord(objectStatus: 'Resistance Band',     gripperAngle: '55°',  scissorAngle: '28°',  scorePercent: '79%', timestamp: 'Jun 19 · 09:20'),
      SessionRecord(objectStatus: 'Grip Tool Detected',  gripperAngle: '62°',  scissorAngle: '33°',  scorePercent: '85%', timestamp: 'Jun 19 · 09:40'),
      SessionRecord(objectStatus: 'Splint Detected',     gripperAngle: '40°',  scissorAngle: '20°',  scorePercent: '71%', timestamp: 'Jun 19 · 10:00'),
      SessionRecord(objectStatus: 'Resistance Band',     gripperAngle: '58°',  scissorAngle: '31°',  scorePercent: '83%', timestamp: 'Jun 19 · 10:20'),
      SessionRecord(objectStatus: 'Grip Tool Detected',  gripperAngle: '63°',  scissorAngle: '34°',  scorePercent: '87%', timestamp: 'Jun 19 · 10:40'),
      SessionRecord(objectStatus: 'Splint Detected',     gripperAngle: '42°',  scissorAngle: '22°',  scorePercent: '74%', timestamp: 'Jun 19 · 11:00'),
      SessionRecord(objectStatus: 'Resistance Band',     gripperAngle: '57°',  scissorAngle: '29°',  scorePercent: '81%', timestamp: 'Jun 19 · 11:20'),
      SessionRecord(objectStatus: 'Grip Tool Detected',  gripperAngle: '65°',  scissorAngle: '35°',  scorePercent: '88%', timestamp: 'Jun 19 · 11:40'),
      SessionRecord(objectStatus: 'Splint Detected',     gripperAngle: '44°',  scissorAngle: '25°',  scorePercent: '76%', timestamp: 'Jun 19 · 12:00'),
    ],
  ),
};