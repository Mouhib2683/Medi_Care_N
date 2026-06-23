import 'package:flutter/foundation.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Evaluation model
// ─────────────────────────────────────────────────────────────────────────────

class Evaluation {
  final String message;
  final DateTime sentAt;
  bool isRead;

  Evaluation({
    required this.message,
    required this.sentAt,
    this.isRead = false,
  });

  String get formattedTime {
    final d = sentAt;
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.day}/${d.month}/${d.year}  $h:$m';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Singleton store  –  keyed by user email
// ─────────────────────────────────────────────────────────────────────────────

class EvaluationStore {
  EvaluationStore._();
  static final EvaluationStore instance = EvaluationStore._();

  // email → list of evaluations
  final Map<String, List<Evaluation>> _data = {};

  // Notifier so widgets can listen for changes without a state-management lib
  final ValueNotifier<int> version = ValueNotifier(0);

  // ── Write ──────────────────────────────────────────────────────────────────

  void send({required String toEmail, required String message}) {
    _data.putIfAbsent(toEmail, () => []);
    _data[toEmail]!.insert(
      0,
      Evaluation(message: message, sentAt: DateTime.now()),
    );
    version.value++;
  }

  // ── Read ───────────────────────────────────────────────────────────────────

  List<Evaluation> forUser(String email) =>
      List.unmodifiable(_data[email] ?? []);

  int unreadCount(String email) =>
      (_data[email] ?? []).where((e) => !e.isRead).length;

  void markAllRead(String email) {
    for (final e in _data[email] ?? []) {
      e.isRead = true;
    }
    version.value++;
  }
}