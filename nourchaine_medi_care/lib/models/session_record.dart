import 'package:flutter/material.dart' show Color;

class SessionRecord {
  final String objectStatus;
  final String gripperAngle;
  final String scissorAngle;
  final String scorePercent;
  final String timestamp;

  const SessionRecord({
    required this.objectStatus,
    required this.gripperAngle,
    required this.scissorAngle,
    required this.scorePercent,
    this.timestamp = '',
  });

  factory SessionRecord.fromJson(Map<String, dynamic> json) {
    return SessionRecord(
      objectStatus: json['object_status']?.toString() ?? '—',
      gripperAngle: json['gripper_angle']?.toString() ?? '—',
      scissorAngle: json['scissor_angle']?.toString() ?? '—',
      scorePercent: json['score_percent']?.toString() ?? '—',
      timestamp: json['timestamp']?.toString() ?? '',
    );
  }

  double get scoreValue {
    final cleaned = scorePercent.replaceAll('%', '').trim();
    return double.tryParse(cleaned) ?? 0.0;
  }

  Color get scoreColor {
    final s = scoreValue;
    if (s >= 85) return const Color(0xFF22C55E);
    if (s >= 70) return const Color(0xFF3B9EE8);
    return const Color(0xFFF59E0B);
  }
}
