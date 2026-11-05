import 'package:flutter/material.dart';

class Departments {
  Departments._();

  static const Map<String, IconData> icons = {
    'CSE': Icons.computer,
    'IT': Icons.lan,
    'ECE': Icons.memory,
    'EEE': Icons.bolt,
    'Mechanical': Icons.precision_manufacturing,
    'Civil': Icons.apartment,
    'General': Icons.campaign,
  };

  static List<String> get names => icons.keys.toList();

  static IconData iconFor(String department) =>
      icons[department] ?? Icons.campaign;
}

class Notice {
  const Notice({
    required this.id,
    required this.title,
    required this.department,
    required this.body,
    required this.postedBy,
    required this.date,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String department;
  final String body;
  final String postedBy;
  final DateTime date;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'department': department,
        'body': body,
        'postedBy': postedBy,
        'date': date.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
        id: json['id'] as String,
        title: json['title'] as String,
        department: json['department'] as String,
        body: json['body'] as String,
        postedBy: json['postedBy'] as String,
        date: DateTime.parse(json['date'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
