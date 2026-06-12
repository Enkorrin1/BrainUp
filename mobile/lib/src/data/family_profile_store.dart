import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/family_profile.dart';

abstract interface class FamilyProfileStore {
  Future<FamilyProfile?> load();

  Future<void> save(FamilyProfile profile);

  Future<void> clear();
}

class SharedPreferencesFamilyProfileStore implements FamilyProfileStore {
  SharedPreferencesFamilyProfileStore(this._preferences);

  static const _profileKey = 'brain_up.family_profile.v1';

  final SharedPreferences _preferences;

  @override
  Future<FamilyProfile?> load() async {
    final rawProfile = _preferences.getString(_profileKey);
    if (rawProfile == null) {
      return null;
    }

    final decodedProfile = jsonDecode(rawProfile) as Map<String, Object?>;
    return FamilyProfile.fromJson(decodedProfile);
  }

  @override
  Future<void> save(FamilyProfile profile) async {
    await _preferences.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  @override
  Future<void> clear() async {
    await _preferences.remove(_profileKey);
  }
}
