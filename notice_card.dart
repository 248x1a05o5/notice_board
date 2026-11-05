import 'package:flutter/material.dart';

import '../models/notice.dart';
import 'formatters.dart';

class NoticeCard extends StatelessWidget {
  const NoticeCard({super.key, required this.notice, required this.onTap});

  final Notice notice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Chip(
                    avatar: Icon(Departments.iconFor(notice.department),
                        size: 16),
                    label: Text(notice.department),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: scheme.secondaryContainer,
                  ),
                  const Spacer(),
                  Text(formatDate(notice.date),
                      style: theme.textTheme.labelMedium),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notice.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                notice.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
