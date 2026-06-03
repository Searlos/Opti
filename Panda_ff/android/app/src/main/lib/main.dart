import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';
import 'services/settings_service.dart';

final settings = SettingsService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await settings.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const PandaApp());
}

class PandaApp extends StatelessWidget {
  const PandaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PANDA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const MainScreen(),
    );
  }
}
