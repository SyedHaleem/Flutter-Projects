import 'package:flutter/material.dart';
import 'dart:convert';

class FoodResultScreen extends StatelessWidget {
  final Map<String, dynamic> debugSnapshot;
  final Map<String, dynamic> summary; // compact computed values to show at top

  const FoodResultScreen({super.key, required this.debugSnapshot, required this.summary});

  @override
  Widget build(BuildContext context) {
    final logs = (debugSnapshot['logs'] as List?)?.cast<String>() ?? const <String>[];
    final responses = (debugSnapshot['responses'] as Map?)?.cast<String, dynamic>() ?? const <String, dynamic>{};

    return Scaffold(
      appBar: AppBar(title: const Text('AI Debug & Responses')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Summary', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...summary.entries.map((e) => Text('${e.key}: ${e.value}')),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Logs', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...logs.map((l) => Text(l, style: TextStyle(color: Colors.grey[700], fontFamily: 'monospace', fontSize: 12))),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Raw & Parsed Responses', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...responses.entries.map((e) => _kv(e.key, e.value)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, dynamic v) {
    final pretty = _pretty(v);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(k, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.all(8),
          child: Text(pretty, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
        )
      ]),
    );
  }

  String _pretty(dynamic v) {
    try {
      return const JsonEncoder.withIndent('  ').convert(v);
    } catch (_) {
      return v.toString();
    }
  }
}
