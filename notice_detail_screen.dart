import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/notice.dart';
import '../services/notice_store.dart';
import '../widgets/formatters.dart';

class NoticeDetailScreen extends StatelessWidget {
  const NoticeDetailScreen({super.key, required this.noticeId});

  final String noticeId;

  @override
  Widget build(BuildContext context) {
    final notice = context.watch<NoticeStore>().byId(noticeId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice'),
        actions: [
          if (notice != null)
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmDelete(context, notice),
            ),
        ],
      ),
      body: SafeArea(
        child: notice == null
            ? const Center(child: Text('This notice no longer exists.'))
            : _Details(notice: notice),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Notice notice) async {
    final store = context.read<NoticeStore>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete notice?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await store.remove(notice.id);
      navigator.pop();
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not delete. Please try again.')),
      );
    }
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.notice});

  final Notice notice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Chip(
            avatar: Icon(Departments.iconFor(notice.department), size: 18),
            label: Text(notice.department),
            backgroundColor: theme.colorScheme.secondaryContainer,
          ),
        ),
        const SizedBox(height: 12),
        Text(notice.title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Dated ${formatDate(notice.date)}  •  Posted by ${notice.postedBy}',
          style: theme.textTheme.labelLarge,
        ),
        const Divider(height: 32),
        Text(notice.body, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 24),
        Text(
          'Published on ${formatDate(notice.createdAt)}',
          style: theme.textTheme.labelMedium,
        ),
      ],
    );
  }
}
