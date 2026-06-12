import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app/brain_up_app.dart';
import 'src/data/app_locale_store.dart';
import 'src/data/family_profile_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();

  runApp(
    BrainUpApp(
      appLocaleStore: SharedPreferencesAppLocaleStore(preferences),
      familyProfileStore: SharedPreferencesFamilyProfileStore(preferences),
    ),
  );
}
