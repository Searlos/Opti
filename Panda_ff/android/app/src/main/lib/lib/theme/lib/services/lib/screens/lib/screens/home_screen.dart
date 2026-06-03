import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/panda_top_bar.dart';
import '../widgets/feature_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PandaTopBar(),
            _buildBanner(),
            const SizedBox(height: 20),
            _buildSectionTitle('FUNCIONES PRINCIPALES'),
            const SizedBox(height: 10),
            FeatureCard(
              icon: Icons.touch_app_rounded,
              title: 'Touch Boost',
              description: 'Mejora la sensibilidad y velocidad de respuesta del touch para reaccionar más rápido en Free Fire.',
              color: AppColors.red,
            ),
            FeatureCard(
              icon: Icons.flash_on_rounded,
              title: 'Sin Delay',
              description: 'Elimina el retardo de entrada del touchscreen para disparos y movimientos instantáneos.',
              color: AppColors.warning,
            ),
            FeatureCard(
              icon: Icons.screen_rotation_rounded,
              title: 'Giroscopio',
              description: 'Calibra y potencia el giroscopio para mira precisa al inclinar el celular.',
              color: AppColors.success,
            ),
            FeatureCard(
              icon: Icons.gamepad_rounded,
              title: 'Mapeo de Botones',
              description: 'Asigna acciones a botones físicos o crea un HUD virtual personalizado para Free Fire.',
              color: const Color(0xFF9B59B6),
            ),
            const SizedBox(height: 16),
            _buildTip(),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B1A1A), Color(0xFF3A0A0A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.redDark),
        boxShadow: [
          BoxShadow(
            color: AppColors.red.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('🐼 PANDA',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2)),
                SizedBox(height: 6),
                Text('Optimizador Gaming\npara Free Fire',
                    style: TextStyle(
                        fontSize: 14, color: Color(0xFFFFAAAA))),
                SizedBox(height: 12),
                _StatusBadge(),
              ],
            ),
          ),
          const Text('🔥', style: TextStyle(fontSize: 64)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(t,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 1.5)),
    );
  }

  Widget _buildTip() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.redGlow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.redDark),
      ),
      child: const Row(
        children: [
          Text('💡', style: TextStyle(fontSize: 20)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Activa primero Touch Boost y Sin Delay, luego configura el giroscopio y finalmente el mapeo.',
              style: TextStyle(fontSize: 12, color: Color(0xFFFFAAAA)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.success.withOpacity(0.5)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: AppColors.success, size: 8),
          SizedBox(width: 6),
          Text('Sistema listo',
              style: TextStyle(
                  fontSize: 11,
                  color: AppColors.success,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
