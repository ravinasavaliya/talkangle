import 'package:shared_preferences/shared_preferences.dart';

final preferences = PreferenceManager();

class PreferenceManager {
  static SharedPreferences? _preferences;

  init() async {
    _preferences ??= await SharedPreferences.getInstance();

    await _preferences?.reload();
  }

  final String login = "LOGIN";
  final String userName = "USER_NAME";
  final String names = "NAME";
  final String userId = "USER_ID";
  final String userNumber = "USER_NUMBER";
  final String userToken = "USER_TOKEN";
  final String fcmNotificationToken = "FCM_NOTIFICATION_TOKEN";
  final String userDetails = "USER_DETAILS";
  final String roles = "ROLE";
  final String onMessage = "ON_MESSAGE";
  final String callAccept = "CALL_ACCEPT";
  final String callStart = "CALL_START";
  // final String callStartAppDetached = "CALL_START_APP_DETACHED";
  final String callerUserId = "CALLER_USER_ID";
  final String callSecondCount = "CALL_SECOND_COUNT";

  clearUserItem() async {
    _preferences?.clear();
    _preferences = null;
    _preferences?.reload();
    await init();
  }

  logOut() async {
    await _preferences?.remove(login);
    await _preferences?.remove(userName);
    await _preferences?.remove(names);
    await _preferences?.remove(userId);
    await _preferences?.remove(userNumber);
    await _preferences?.remove(userToken);
    await _preferences?.remove(userDetails);
    await _preferences?.remove(roles);
    await _preferences?.remove(onMessage);
    await _preferences?.remove(callAccept);
    await _preferences?.remove(callStart);
    await _preferences?.remove(callerUserId);
    await _preferences?.remove(callSecondCount);
    await _preferences?.reload();
  }

  Future<bool?> setString(String key, String value) async {
    _preferences?.reload();
    return _preferences == null ? null : _preferences?.setString(key, value);
  }

  String? getString(String key, {String defValue = ""}) {
    _preferences?.reload();
    return _preferences == null ? defValue : _preferences?.getString(key) ?? defValue;
  }

  Future<bool?> setInt(String key, int value) async {
    _preferences?.reload();
    return _preferences == null ? null : _preferences?.setInt(key, value);
  }

  int? getInt(String key, {int defValue = 0}) {
    _preferences?.reload();
    return _preferences == null ? defValue : _preferences?.getInt(key) ?? defValue;
  }

  Future<bool?> setDouble(String key, double value) async {
    _preferences?.reload();
    return _preferences == null ? null : _preferences?.setDouble(key, value);
  }

  double getDouble(String key, {double defValue = 0.0}) {
    _preferences?.reload();
    return _preferences == null ? defValue : _preferences?.getDouble(key) ?? defValue;
  }

  Future<bool?> setBool(String key, bool value) async {
    _preferences?.reload();
    return _preferences == null ? null : _preferences?.setBool(key, value);
  }

  bool? getBool(String key, {bool defValue = false}) {
    _preferences?.reload();
    return _preferences == null ? defValue : _preferences?.getBool(key) ?? defValue;
  }
}
