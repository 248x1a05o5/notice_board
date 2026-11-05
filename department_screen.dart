import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/notice.dart';
import '../services/notice_store.dart';

class DepartmentScreen extends StatelessWidget {
  const DepartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<NoticeStore>();
    return Scaffold(
      appBar: AppBar(title: const Text('Departments')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _DepartmentTile(
              icon: Icons.all_inclusive,
              name: 'All departments',
              count: store.totalCount,
              selected: store.selectedDepartment == null,
              onTap: () {
                store.selectDepartment(null);
                Navigator.pop(context);
              },
            ),
            for (final name in Departments.names) ...[
              const SizedBox(height: 8),
              _DepartmentTile(
                icon: Departments.iconFor(name),
                name: name,
                count: store.countFor(name),
                selected: store.selectedDepartment == name,
                onTap: () {
                  store.selectDepartment(name);
                  Navigator.pop(context);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DepartmentTile extends StatelessWidget {
  const _DepartmentTile({
    required this.icon,
    required this.name,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String name;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: selected ? scheme.primaryContainer : null,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon),
        title: Text(name),
        trailing: Text(
          count == 1 ? '1 notice' : '$count notices',
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
