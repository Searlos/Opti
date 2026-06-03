import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsCard extends StatelessWidget {
  final IconData icon;
  final String   title;
  final String   description;
  final Widget   child;

  const SettingsCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.redDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.redLight, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ),
              child,
            ],
          ),
          const SizedBox(height: 8),
          Text(description,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4)),
        ],
      ),
    );
  }
}
