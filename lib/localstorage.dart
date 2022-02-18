import 'dart:developer';

import 'package:interval_timer/workout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    log("LocalStorage init $_prefs");
  }

  static void save(WorkOut data) {
    _prefs?.setInt("time", data.time.inSeconds);
    _prefs?.setInt("rep", data.reps);

    log("LocalStorage save $_prefs, $data");
  }

  static WorkOut read() {
    final sec = _prefs?.getInt("time");
    final rep = _prefs?.getInt("rep");

    log("LocalStorage read $_prefs, $sec");

    if (sec != null && rep != null) {
      return WorkOut(Duration(seconds: sec), rep);
    }
    return WorkOut(const Duration(seconds: 5), 2);
  }
}
