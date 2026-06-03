import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/panda_top_bar.dart';
import '../widgets/settings_card.dart';
import '../main.dart';

class GyroScreen extends StatefulWidget {
  const GyroScreen({super.key});
  @override
  State<GyroScreen> createState() => _GyroScreenState();
}

class _GyroScreenState extends State<GyroScreen>
    with SingleTickerProviderStateMixin {
  late bool   _gyroEnabled;
  late double _sensX;
  late double _sensY;
  late AnimationController _animController;
  late Animation<double>   _rotAnim;

  @override
  void initState() {
    super.initState();
    _gyroEnabled = settings.gyroEnabled;
    _sensX = settings.gyroSensX;
    _sensY = settings.gyroSensY;
    _animController = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
    _rotAnim = Tween(begin: -0.1, end: 0.1).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const PandaTopBar(title: 'Giroscopio'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  _buildGyroVisual(),
                  SettingsCard(
                    icon: Icons.screen_rotation_rounded,
                    title: 'Activar Giroscopio',
                    description: 'Usa el giroscopio del celular para controlar la mira inclinando el dispositivo. Ideal para Free Fire.',
                    child: Switch(
                      value: _gyroEnabled,
                      onChanged: (v) {
                        setState(() => _gyroEnabled = v);
                        settings.setGyroEnabled(v);
                      },
                    ),
                  ),
                  if (_gyroEnabled) ...[
                    SettingsCard(
                      icon: Icons.swap_horiz_rounded,
                      title: 'Sensibilidad Horizontal (X)',
                      description: 'Controla qué tan rápido se mueve la mira al inclinar el celular de lado.',
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Suave', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              _sensLabel(_sensX),
                              const Text('Rápido', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            ],
                          ),
                          Slider(
                            value: _sensX, min: 1, max: 10, divisions: 9,
                            onChanged: (v) {
                              setState(() => _sensX = v);
                              settings.setGyroSensX(v);
                            },
                          ),
                        ],
                      ),
                    ),
                    SettingsCard(
                      icon: Icons.swap_vert_rounded,
                      title: 'Sensibilidad Vertical (Y)',
                      description: 'Controla qué tan rápido sube o baja la mira al inclinar adelante/atrás.',
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Suave', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              _sensLabel(_sensY),
                              const Text('Rápido', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            ],
                          ),
                          Slider(
                            value: _sensY, min: 1, max: 10, divisions: 9,
                            onChanged: (v) {
                              setState(() => _sensY = v);
                              settings.setGyroSensY(v);
                            },
                          ),
                        ],
                      ),
                    ),
                    _buildPresets(),
                  ],
                  _buildApplyButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGyroVisual() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: AnimatedBuilder(
        animation: _rotAnim,
        builder: (_, __) => Center(
          child: Transform(
            transform: Matrix4.identity()
              ..rotateZ(_gyroEnabled ? _rotAnim.value : 0)
              ..rotateX(_gyroEnabled ? _rotAnim.value * 0.5 : 0),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_android_rounded,
                    size: 60,
                    color: _gyroEnabled ? AppColors.red : AppColors.textMuted),
                const SizedBox(height: 8),
                Text(
                  _gyroEnabled ? '🔴 Giroscopio ACTIVO' : '⚪ Giroscopio INACTIVO',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _gyroEnabled ? AppColors.red : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sensLabel(double v) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.redDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('${v.toInt()} / 10',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildPresets() {
    final presets = [
      {'label': 'Principiante', 'x': 3.0, 'y': 3.0},
      {'label': 'Intermedio',   'x': 5.0, 'y': 5.0},
      {'label': 'Pro',          'x': 8.0, 'y': 7.0},
      {'label': 'Sniper',       'x': 2.0, 'y': 4.0},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PRESETS RÁPIDOS',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary, letterSpacing: 1.5)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: presets.map((p) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _sensX = p['x'] as double;
                    _sensY = p['y'] as double;
                  });
                  settings.setGyroSensX(_sensX);
                  settings.setGyroSensY(_sensY);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.redDark),
                  ),
                  child: Text(p['label'] as String,
                      style: const TextStyle(fontSize: 13, color: AppColors.red,
                          fontWeight: FontWeight.w600)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Row(children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('¡Giroscopio configurado!'),
              ]),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ));
          },
          icon: const Icon(Icons.check_circle_rounded),
          label: const Text('APLICAR GIROSCOPIO',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 1)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            shadowColor: AppColors.red.withOpacity(0.5),
            elevation: 8,
          ),
        ),
      ),
    );
  }
}
