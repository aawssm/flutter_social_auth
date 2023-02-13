import '../cmn.dart';

class ProSharedPref extends ChangeNotifier {
  SharedPreferences? _pref;

  ProSharedPref() {
    getPref();
  }

  Future<SharedPreferences> getPref() async {
    return _pref ??= await SharedPreferences.getInstance();
  }

  Future<bool> setLsToPref(String keys, List<String> ls, {double ttl = 0}) async {
    try {
      MoResponse ms = MoResponse(createdAt: DateTime.now().millisecondsSinceEpoch, ttl: ttl, result: ls);
      bool bl = await setToPref(keys, str: json.encode(ms.toJson()));
      return bl;
    } catch (e) {
      if (kDebugMode) print("getToken error : ");
      if (kDebugMode) print(e);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getLSfromoPref(String keys) async {
    List<Map<String, dynamic>> ret = [];
    try {
      String value = await getfromoPref(keys);
      if (value.isEmpty) return ret;
      MoResponse ms = MoResponse.fromJson(json.decode(value));
      for (var element in (ms.result ?? [])) {
        ret.add(json.decode(element));
      }
      return ret;
    } catch (e) {
      if (kDebugMode) print("getToken error : ");
      if (kDebugMode) print(e);
      return ret;
    }
  }

  Future<bool> setToPref(String keys, {String? str, bool? bl, List<String>? strLS}) async {
    try {
      _pref ??= await getPref();
      bool ret = false;
      if (str != null) ret = await _pref!.setString(keys, str);
      if (bl != null) ret = await _pref!.setBool(keys, bl);
      if (strLS != null) ret = await _pref!.setStringList(keys, strLS);
      return ret;
    } catch (e) {
      //if (kDebugMode) print("getToken error : ");
      //if (kDebugMode) print(e);
      return false;
    }
  }

  Future<dynamic> getfromoPref(String keys, [dynamic foo = ""]) async {
    _pref ??= await getPref();

    try {
      switch (foo.runtimeType) {
        case String:
          return _pref!.getString(keys) ?? foo;
        case int:
          return _pref!.getInt(keys) ?? foo;
        case bool:
          return _pref!.getBool(keys) ?? foo;
        case List:
          return _pref!.getStringList(keys) ?? foo;

        default:
          return;
      }
    } catch (e) {
      //if (kDebugMode) print("getToken error : ");
      //if (kDebugMode) print(e);
      return foo;
    }
  }
}
