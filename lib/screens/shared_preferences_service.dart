import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<void> markStoryAsViewed(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('story_$index', true);
  }

  static Future<bool> isStoryViewed(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('story_$index') ?? false;
  }
}
