import 'package:shared_preferences/shared_preferences.dart';

class TrainingAccessService {
  static const String _urlKey = 'training_access_url';
  static const String _defaultUrl = 'https://example.com';

  // Récupérer l'URL configurée
  static Future<String> getUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_urlKey) ?? _defaultUrl;
  }

  // Sauvegarder l'URL configurée
  static Future<void> setUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_urlKey, url);
  }

  // Réinitialiser à l'URL par défaut
  static Future<void> resetUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_urlKey);
  }
}
