import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _touchBoost     = 'touch_boost';
  static const _noDelay        = 'no_delay';
  static const _gyroEnabled    = 'gyro_enabled';
  static const _gyroSensX      = 'gyro_sens_x';
  static const _gyroSensY      = 'gyro_sens_y';
  static const _touchSensLevel = 'touch_sens_level';
  static const _touchRate      = 'touch_rate';
  static const _hudEnabled     = 'hud_enabled';
  static const _mappings       = 'mappings';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool   get touchBoost      => _prefs.getBool(_touchBoost)      ?? false;
  bool   get noDelay         => _prefs.getBool(_noDelay)         ?? false;
  double get touchSensLevel  => _prefs.getDouble(_touchSensLevel)?? 5.0;
  double get touchRate       => _prefs.getDouble(_touchRate)     ?? 60.0;

  Future<void> setTouchBoost(bool v)       => _prefs.setBool(_touchBoost, v);
  Future<void> setNoDelay(bool v)          => _prefs.setBool(_noDelay, v);
  Future<void> setTouchSensLevel(double v) => _prefs.setDouble(_touchSensLevel, v);
  Future<void> setTouchRate(double v)      => _prefs.setDouble(_touchRate, v);

  bool   get gyroEnabled => _prefs.getBool(_gyroEnabled) ?? false;
  double get gyroSensX   => _prefs.getDouble(_gyroSensX) ?? 5.0;
  double get gyroSensY   => _prefs.getDouble(_gyroSensY) ?? 5.0;

  Future<void> setGyroEnabled(bool v) => _prefs.setBool(_gyroEnabled, v);
  Future<void> setGyroSensX(double v) => _prefs.setDouble(_gyroSensX, v);
  Future<void> setGyroSensY(double v) => _prefs.setDouble(_gyroSensY, v);

  bool get hudEnabled => _prefs.getBool(_hudEnabled) ?? false;
  Future<void> setHudEnabled(bool v) => _prefs.setBool(_hudEnabled, v);

  String get mappingsJson => _prefs.getString(_mappings) ?? '[]';
  Future<void> setMappingsJson(String v) => _prefs.setString(_mappings, v);
}
