import 'package:flutter/material.dart';

import 'screens/home/home_screen.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.instance.initialize();
  runApp(const CancerCareApp());
}

class CancerCareApp extends StatelessWidget {
  const CancerCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CancerCare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
