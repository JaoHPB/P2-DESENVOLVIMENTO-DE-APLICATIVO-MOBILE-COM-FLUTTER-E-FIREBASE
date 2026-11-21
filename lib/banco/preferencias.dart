import 'package:shared_preferences/shared_preferences.dart';

class Preferencias {
  static const String _chaveTemaEscuro = 'temaEscuro';

  static Future<bool> carregarTemaEscuro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_chaveTemaEscuro) ?? false;
  }

  static Future<void> salvarTemaEscuro(bool escuro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chaveTemaEscuro, escuro);
  }
}
