import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PandaTopBar extends StatelessWidget {
  final String title;
  const PandaTopBar({super.key, this.title = 'PANDA'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          const Text('🐼', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.redDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.red.withOpacity(0.5)),
            ),
            child: const Text('Free Fire',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.redLight)),
          ),
        ],
      ),
    );
  }
}
