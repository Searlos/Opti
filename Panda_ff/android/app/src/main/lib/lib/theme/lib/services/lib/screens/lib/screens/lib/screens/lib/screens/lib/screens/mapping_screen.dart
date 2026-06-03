import 'package:flutter/material.dart';
import 'dart:convert';
import '../theme/app_theme.dart';
import '../widgets/panda_top_bar.dart';
import '../widgets/settings_card.dart';
import '../main.dart';

class MappingButton {
  String id;
  String label;
  String action;
  double x;
  double y;
  bool isPhysical;
  String physicalKey;

  MappingButton({
    required this.id,
    required this.label,
    required this.action,
    this.x = 0.5,
    this.y = 0.5,
    this.isPhysical = false,
    this.physicalKey = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'label': label, 'action': action,
    'x': x, 'y': y, 'isPhysical': isPhysical, 'physicalKey': physicalKey,
  };

  factory MappingButton.fromJson(Map<String, dynamic> j) => MappingButton(
    id: j['id'], label: j['label'], action: j['action'],
    x: j['x'], y: j['y'],
    isPhysical: j['isPhysical'], physicalKey: j['physicalKey'],
  );
}

class MappingScreen extends StatefulWidget {
  const MappingScreen({super.key});
  @override
  State<MappingScreen> createState() => _MappingScreenState();
}

class _MappingScreenState extends State<MappingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<MappingButton> _buttons = [];
  bool _hudEnabled = false;

  final _actions = [
    'Disparar', 'Agacharse', 'Saltar', 'Recargar', 'Scope/Mira',
    'Mapa', 'Inventario', 'Usar ítem', 'Sprint', 'Lanzar granada',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _hudEnabled = settings.hudEnabled;
    _loadMappings();
  }

  void _loadMappings() {
    try {
      final raw = settings.mappingsJson;
      final list = jsonDecode(raw) as List;
      setState(() {
        _buttons = list.map((e) => MappingButton.fromJson(e)).toList();
      });
    } catch (_) {
      _buttons = _defaultButtons();
    }
  }

  List<MappingButton> _defaultButtons() => [
    MappingButton(id: '1', label: 'Disparar', action: 'Disparar', x: 0.8, y: 0.6),
    MappingButton(id: '2', label: 'Agachar',  action: 'Agacharse', x: 0.7, y: 0.75),
    MappingButton(id: '3', label: 'Saltar',   action: 'Saltar',   x: 0.85, y: 0.75),
  ];

  void _saveMappings() {
    settings.setMappingsJson(
        jsonEncode(_buttons.map((b) => b.toJson()).toList()));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const PandaTopBar(title: 'Mapeo de Botones'),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildHudTab(), _buildPhysicalTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        tabs: const [
          Tab(text: '📱 HUD Virtual'),
          Tab(text: '🎮 Botón Físico'),
        ],
      ),
    );
  }

  Widget _buildHudTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          SettingsCard(
            icon: Icons.layers_rounded,
            title: 'HUD Virtual',
            description: 'Muestra botones en pantalla mientras juegas Free Fire. Actívalo y personaliza cada botón.',
            child: Switch(
              value: _hudEnabled,
              onChanged: (v) {
                setState(() => _hudEnabled = v);
                settings.setHudEnabled(v);
              },
            ),
          ),
          _buildHudPreview(),
          _buildButtonList(),
          _buildAddButton(),
          _buildApplyBtn('ACTIVAR HUD'),
        ],
      ),
    );
  }

  Widget _buildHudPreview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Stack(
        children: [
          const Center(
            child: Text('Vista previa del HUD',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ),
          ..._buttons.where((b) => !b.isPhysical).map((b) {
            return Positioned(
              left: b.x * (MediaQuery.of(context).size.width - 32) - 24,
              top: b.y * 200 - 20,
              child: GestureDetector(
                onPanUpdate: (d) {
                  final w = MediaQuery.of(context).size.width - 32;
                  setState(() {
                    b.x = ((b.x * w + d.delta.dx) / w).clamp(0.0, 1.0);
                    b.y = ((b.y * 200 + d.delta.dy) / 200).clamp(0.0, 1.0);
                  });
                },
                onPanEnd: (_) => _saveMappings(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.red.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                  ),
                  child: Text(b.label,
                      style: const TextStyle(color: Colors.white,
                          fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildButtonList() {
    return Column(
      children: _buttons.where((b) => !b.isPhysical).map((b) {
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                    color: AppColors.redDark,
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.touch_app_rounded,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.label,
                        style: const TextStyle(fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    DropdownButton<String>(
                      value: b.action,
                      isDense: true,
                      dropdownColor: AppColors.surfaceAlt,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                      underline: const SizedBox(),
                      items: _actions.map((a) =>
                          DropdownMenuItem(value: a, child: Text(a))).toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() { b.action = v; b.label = v; });
                          _saveMappings();
                        }
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded,
                    color: AppColors.textMuted),
                onPressed: () {
                  setState(() => _buttons.remove(b));
                  _saveMappings();
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: OutlinedButton.icon(
        onPressed: () {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          setState(() {
            _buttons.add(MappingButton(
                id: id, label: 'Nuevo', action: 'Disparar',
                x: 0.5, y: 0.5));
          });
          _saveMappings();
        },
        icon: const Icon(Icons.add_rounded, color: AppColors.red),
        label: const Text('Agregar Botón',
            style: TextStyle(
                color: AppColors.red, fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.red),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size(double.infinity, 46),
        ),
      ),
    );
  }

  Widget _buildPhysicalTab() {
    final physButtons = _buttons.where((b) => b.isPhysical).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.redGlow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.redDark),
            ),
            child: const Row(children: [
              Text('🎮', style: TextStyle(fontSize: 24)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Asigna acciones a botones físicos de tu celular o gamepad externo conectado por Bluetooth.',
                  style: TextStyle(fontSize: 12, color: Color(0xFFFFAAAA)),
                ),
              ),
            ]),
          ),
          if (physButtons.isEmpty)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(children: [
                Text('🎮', style: TextStyle(fontSize: 48)),
                SizedBox(height: 12),
                Text('No hay botones físicos asignados',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 14)),
                SizedBox(height: 4),
                Text('Agrega uno con el botón de abajo',
                    style: TextStyle(
                        color: AppColors.textMuted, fontSize: 12)),
              ]),
            )
          else
            ...physButtons.map((b) => _buildPhysRow(b)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: OutlinedButton.icon(
              onPressed: () {
                final id = DateTime.now().millisecondsSinceEpoch.toString();
                setState(() {
                  _buttons.add(MappingButton(
                      id: id, label: 'Botón Físico', action: 'Disparar',
                      isPhysical: true, physicalKey: 'Botón de Volumen +'));
                });
                _saveMappings();
              },
              icon: const Icon(Icons.add_rounded, color: AppColors.red),
              label: const Text('Asignar Botón Físico',
                  style: TextStyle(
                      color: AppColors.red, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.red),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 46),
              ),
            ),
          ),
          _buildApplyBtn('GUARDAR MAPEO'),
        ],
      ),
    );
  }

  Widget _buildPhysRow(MappingButton b) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
                color: AppColors.redDark,
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.gamepad_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  b.physicalKey.isEmpty ? 'Presiona un botón...' : b.physicalKey,
                  style: const TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
                DropdownButton<String>(
                  value: b.action,
                  isDense: true,
                  dropdownColor: AppColors.surfaceAlt,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                  underline: const SizedBox(),
                  items: _actions.map((a) =>
                      DropdownMenuItem(value: a, child: Text(a))).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => b.action = v);
                    _saveMappings();
                  },
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_rounded,
                color: AppColors.textMuted),
            onPressed: () {
              setState(() => _buttons.remove(b));
              _saveMappings();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildApplyBtn(String label) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            _saveMappings();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Row(children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('¡Mapeo guardado!'),
              ]),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ));
          },
          icon: const Icon(Icons.save_rounded),
          label: Text(label,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 1)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            elevation: 8,
            shadowColor: AppColors.red.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
