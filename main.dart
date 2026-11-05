import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/notice_list_screen.dart';
import 'services/notice_service.dart';
import 'services/notice_store.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const NoticeBoardApp());
}

class NoticeBoardApp extends StatelessWidget {
  const NoticeBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoticeStore(NoticeService())..load(),
      child: MaterialApp(
        title: 'Campus Notice Board',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const NoticeListScreen(),
      ),
    );
  }
}
