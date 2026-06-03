import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'touch_screen.dart';
import 'gyro_screen.dart';
import 'mapping_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    TouchScreen(),
    GyroScreen(),
    MappingScreen(),
  ];

  final _items = const [
    {'icon': Icons.home_rounded,            'label': 'Inicio'},
    {'icon': Icons.touch_app_rounded,       'label': 'Touch'},
    {'icon': Icons.screen_rotation_rounded, 'label': 'Giroscopio'},
    {'icon': Icons.gamepad_rounded,         'label': 'Mapeo'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_index],
      bottomNavigationBar: _buildNav(),
    );
  }

  Widget _buildNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: List.generate(_items.length, (i) {
          final active = _index == i;
          final item = _items[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _index = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                decoration: BoxDecoration(
                  color: active ? AppColors.red : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: active ? [
                    BoxShadow(
                      color: AppColors.red.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    )
                  ] : [],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item['icon'] as IconData,
                        color: active ? Colors.white : AppColors.textMuted,
                        size: 22),
                    const SizedBox(height: 3),
                    Text(item['label'] as String,
                        style: TextStyle(
                            fontSize: 10,
                            color: active ? Colors.white : AppColors.textMuted,
                            fontWeight: active
                                ? FontWeight.w700
                                : FontWeight.normal)),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
