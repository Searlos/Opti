# 🐼 PANDA — Free Fire Gaming Optimizer

App de optimización gaming para Free Fire. Diseño rojo/negro estilo Free Fire.

## Funciones
| Pantalla | Función |
|----------|---------|
| 🏠 Inicio | Resumen de todas las funciones |
| 👆 Touch | Touch Boost + quitar delay + sensibilidad + Hz |
| 🔄 Giroscopio | Activar, calibrar sensibilidad X/Y, presets |
| 🎮 Mapeo | HUD virtual arrastrable + botones físicos/gamepad |

## Instalar y compilar

### 1. Crear repositorio en GitHub
Sube todos estos archivos respetando la estructura de carpetas.

### 2. Conectar con Codemagic
- Ve a codemagic.io
- Add application → selecciona este repositorio
- Platform: Android | Build: APK
- Start build

### 3. Descargar APK
Cuando el build termine, descarga el APK desde Artifacts en Codemagic.

## Estructura
```
lib/
├── main.dart
├── theme/app_theme.dart
├── services/settings_service.dart
├── screens/
│   ├── main_screen.dart      ← Navegación
│   ├── home_screen.dart      ← Inicio
│   ├── touch_screen.dart     ← Touch Boost / Delay
│   ├── gyro_screen.dart      ← Giroscopio
│   └── mapping_screen.dart   ← Mapeo HUD + Físico
└── widgets/
    ├── panda_top_bar.dart
    ├── settings_card.dart
    └── feature_card.dart
```

## Colores
| Elemento | Color |
|----------|-------|
| Fondo | `#0A0A0A` |
| Superficie | `#1A1A1A` |
| Rojo principal | `#D42A2A` |
| Rojo oscuro | `#8B1A1A` |
