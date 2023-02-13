import '../cmn.dart';

class ProAppSettings extends ChangeNotifier {
  bool isLoggedIn = false;
  String _token = "";
  final ProSharedPref _pref = ProSharedPref();
  ThemeMode themeMode = ThemeMode.dark;

  ProAppSettings() {
    asyncInit();
  }
  asyncInit() async {
    await getThemeMode();
    await getToken();
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<ThemeMode> setThemeMode([ThemeMode? theme = ThemeMode.system, bool shouldNotify = true]) async {
    themeMode = theme ?? ThemeMode.dark;
    _pref.setToPref("appTheme", str: themeModeToString(themeMode));
    notilistner(shouldNotify);
    return themeMode;
  }

  Future<ThemeMode> getThemeMode({bool shouldNotify = true}) async {
    themeMode = themeModeFromString(await _pref.getfromoPref("appTheme"));
    notilistner(shouldNotify);
    return themeMode;
  }

  ThemeMode themeModeFromString([String? str]) {
    if (str == null || str.isEmpty) return ThemeMode.dark;
    switch (str) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String themeModeToString([ThemeMode? theme]) {
    if (theme == null) return "system";
    switch (theme) {
      case ThemeMode.light:
        return "light";
      case ThemeMode.dark:
        return "dark";
      default:
        return "system";
    }
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<String> getToken({bool shouldNotify = true}) async {
    isLoggedIn = _token.isNotEmpty;
    if (_token.isNotEmpty) {
      notilistner(shouldNotify);
      return _token;
    }
    _token = await _pref.getfromoPref("token");
    isLoggedIn = _token.isNotEmpty;
    notilistner(shouldNotify);
    return _token;
  }

  Future<String> setToken(String tok, {bool shouldNotify = true}) async {
    if (tok.isEmpty) {
      notilistner(shouldNotify);
      return _token;
    }
    bool bl = await _pref.setToPref("token", str: tok);
    if (bl) _token = tok;
    isLoggedIn = _token.isNotEmpty;
    notilistner(shouldNotify);
    return _token;
  }

  Future<bool> logout({bool shouldNotify = true}) async {
    SharedPreferences sh = await _pref.getPref();
    await sh.remove("token");
    _token = "";
    await getToken(shouldNotify: shouldNotify);

    return isLoggedIn;
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////

  notilistner([bool shouldNotify = false]) {
    if (kDebugMode) print("ProAppSettings notilistner $shouldNotify $isLoggedIn");
    if (shouldNotify) notifyListeners();
  }
}
