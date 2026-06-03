import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/panda_top_bar.dart';
import '../widgets/settings_card.dart';
import '../main.dart';

class TouchScreen extends StatefulWidget {
  const TouchScreen({super.key});
  @override
  State<TouchScreen> createState() => _TouchScreenState();
}

class _TouchScreenState extends State<TouchScreen> {
  late bool _touchBoost;
  late bool _noDelay;
  late double _sensLevel;
  late double _touchRate;

  @override
  void initState() {
    super.initState();
    _touchBoost = settings.touchBoost;
    _noDelay    = settings.noDelay;
    _sensLevel  = settings.touchSensLevel;
    _touchRate  = settings.touchRate;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const PandaTopBar(title: 'Touch Optimizer'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  _buildHeader(),
                  SettingsCard(
                    icon: Icons.touch_app_rounded,
                    title: 'Touch Boost',
                    description: 'Aumenta la frecuencia de muestreo del touchscreen para mayor precisión y velocidad de respuesta.',
                    child: Switch(
                      value: _touchBoost,
                      onChanged: (v) {
                        setState(() => _touchBoost = v);
                        settings.setTouchBoost(v);
                      },
                    ),
                  ),
                  SettingsCard(
                    icon: Icons.flash_on_rounded,
                    title: 'Quitar Delay (Sin Retardo)',
                    description: 'Elimina el retardo de entrada del sistema para disparos instantáneos. Recomendado para Free Fire.',
                    child: Switch(
                      value: _noDelay,
                      onChanged: (v) {
                        setState(() => _noDelay = v);
                        settings.setNoDelay(v);
                      },
                    ),
                  ),
                  SettingsCard(
                    icon: Icons.speed_rounded,
                    title: 'Nivel de Sensibilidad',
                    description: 'Ajusta qué tan sensible responde el touch. Valores altos mejoran disparos rápidos.',
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Bajo', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.redDark,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('${_sensLevel.toInt()} / 10',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                            ),
                            const Text('Alto', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                        Slider(
                          value: _sensLevel,
                          min: 1, max: 10, divisions: 9,
                          onChanged: (v) {
                            setState(() => _sensLevel = v);
                            settings.setTouchSensLevel(v);
                          },
                        ),
                      ],
                    ),
                  ),
                  SettingsCard(
                    icon: Icons.timer_rounded,
                    title: 'Touch Rate (Hz)',
                    description: 'Frecuencia de muestreo del touch. Más Hz = más fluido. Recomendado: 120-240 Hz.',
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('60 Hz', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.redDark,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('${_touchRate.toInt()} Hz',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                            ),
                            const Text('240 Hz', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                        Slider(
                          value: _touchRate,
                          min: 60, max: 240, divisions: 6,
                          onChanged: (v) {
                            setState(() => _touchRate = v);
                            settings.setTouchRate(v);
                          },
                        ),
                      ],
                    ),
                  ),
                  _buildApplyButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.redGlow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.redDark),
      ),
      child: const Row(
        children: [
          Text('👆', style: TextStyle(fontSize: 24)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Optimiza el touch de tu celular para Free Fire. Activa Touch Boost y Sin Delay para mejores resultados.',
              style: TextStyle(fontSize: 12, color: Color(0xFFFFAAAA)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _applySettings,
          icon: const Icon(Icons.check_circle_rounded),
          label: const Text('APLICAR CONFIGURACIÓN',
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

  void _applySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Text('¡Configuración de Touch aplicada!'),
        ]),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
