import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/notice.dart';
import '../services/notice_store.dart';
import '../widgets/notice_card.dart';
import '../widgets/state_views.dart';
import 'department_screen.dart';
import 'notice_detail_screen.dart';
import 'notice_form_screen.dart';

class NoticeListScreen extends StatelessWidget {
  const NoticeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<NoticeStore>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Notice Board'),
        actions: [
          IconButton(
            tooltip: 'Departments',
            icon: const Icon(Icons.apartment),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DepartmentScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(child: _body(context, store)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NoticeFormScreen()),
        ),
        icon: const Icon(Icons.edit),
        label: const Text('Post notice'),
      ),
    );
  }

  Widget _body(BuildContext context, NoticeStore store) {
    switch (store.status) {
      case LoadStatus.loading:
        return const LoadingView();
      case LoadStatus.error:
        return ErrorView(
          message: store.errorMessage ?? 'Something went wrong.',
          onRetry: store.load,
        );
      case LoadStatus.ready:
        if (!store.hasNotices) {
          return const EmptyView(
            title: 'No notices yet',
            hint: 'Tap "Post notice" to publish the first one.',
          );
        }
        final notices = store.visibleNotices;
        return Column(
          children: [
            _FilterBar(store: store),
            Expanded(
              child: notices.isEmpty
                  ? EmptyView(
                      title:
                          'No notices for ${store.selectedDepartment}',
                      hint: 'Choose another department or post a notice.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                      itemCount: notices.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, i) => NoticeCard(
                        notice: notices[i],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                NoticeDetailScreen(noticeId: notices[i].id),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        );
    }
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.store});

  final NoticeStore store;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: store.selectedDepartment == null,
            onSelected: (_) => store.selectDepartment(null),
          ),
          for (final name in Departments.names) ...[
            const SizedBox(width: 8),
            ChoiceChip(
              label: Text(name),
              selected: store.selectedDepartment == name,
              onSelected: (_) => store.selectDepartment(name),
            ),
          ],
        ],
      ),
    );
  }
}
