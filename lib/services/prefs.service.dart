import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static SharedPreferences? preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance().whenComplete(() => print(
        '++++++++++++++++++++++++++++++++++++++++++++++prefrence is initialized+++++++++++++++++++++++++++++++++++++++'));
  }
}
