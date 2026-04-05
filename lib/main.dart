import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_dua/core/constants/app_constants.dart';
import 'package:mobile_dua/core/theme/app_theme.dart';
import 'package:mobile_dua/features/dashboard/presentation/pages/dashboard_page.dart';

void main() {
  // ProviderScope adalah root untuk semua provider Riverpod
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  // Menggunakan super parameters (standard Flutter terbaru)
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Anda bisa ganti ke ThemeMode.system jika ingin otomatis
      home: const DashboardPage(),
    );
  }
}