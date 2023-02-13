import '../cmn.dart';

class ProUser extends ChangeNotifier {
  //if token is Empty then user not Loggedin
  final ApiDio _dio = ApiDio();
  final ProSharedPref _pref = ProSharedPref();
  final ProAppSettings _proAppSetting = ProAppSettings();
  List<String> _serverProviders = [];
  MoUserProfile? moUser;
  List<bool> isLoadingLS = [];
  ProUser() {
    asyncInit();
  }

  asyncInit({bool shouldNotify = true}) async {
    await readListOfProvider();
    await readMoUser();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////
  /*
  Login
  logout
  Register
  add provider
  forgot password
   */
  List<String> get serverProviders => _serverProviders;
  Future<List<String>> readListOfProvider({bool canFromServer = true, bool shouldNotify = true}) async {
    if (_serverProviders.isNotEmpty) {
      notilistner(shouldNotify);
      return _serverProviders;
    }
    try {
      List temp = await _pref.getfromoPref("getfromoPref", []);
      if (temp.isEmpty) {
        if (temp.isEmpty && canFromServer) await getListOfProvider();
      } else {
        if (kDebugMode) print("getfromoPref  getfromoPref length ${temp.length}");
        _serverProviders = List<String>.from(temp);
      }
    } catch (e) {
      if (kDebugMode) print(e);
      await getListOfProvider();
    }

    notilistner(shouldNotify);
    return _serverProviders;
  }

  Future<List<String>> saveListOfProvider([List<String> providers = const []]) async {
    bool bl = await _pref.setToPref("serverProviders", strLS: providers);
    if (bl) _serverProviders = providers;
    return _serverProviders;
  }

  Future<List<String>> getListOfProvider({bool shouldNotify = false, bool isForce = false}) async {
    if (_serverProviders.isNotEmpty && !isForce) return _serverProviders;
    isLoadingLS.add(true);
    try {
      MoResponse ms = await _dio.getAsync("api/providers");
      if (ms.status != "ok" || ms.success == false || ms.result == null || ms.result!.isEmpty) {
        //print(ms.status);print(ms.success);print(ms.result);
        if (isLoadingLS.isNotEmpty) isLoadingLS.removeAt(0);
        return [];
      }
      await saveListOfProvider(serverProviderFromJson(ms.result![0]));
    } catch (e) {
      if (kDebugMode) print(e);
    }

    if (isLoadingLS.isNotEmpty) isLoadingLS.removeAt(0);
    return _serverProviders;
  }

  List<String> serverProviderFromJson(dynamic data) {
    if (data == null) return [];
    return List<String>.from(data["providers"]);
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  Future<MoUserProfile?> readMoUser({bool canFromServer = true, bool shouldNotify = true}) async {
    if (moUser != null) {
      notilistner(shouldNotify);
      return moUser;
    }
    try {
      String tep = await _pref.getfromoPref("moUser");
      if (tep.isEmpty) {
        String tok = await _proAppSetting.getToken(shouldNotify: shouldNotify);
        if (canFromServer && tok.isNotEmpty) await tokenMe(tok, shouldNotify: shouldNotify);
      } else {
        Map<String, dynamic> moo = jsonDecode(tep);
        moUser = MoUserProfile.fromJson(moo);
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    }
    notilistner(shouldNotify);
    return moUser;
  }

  Future<MoUserProfile?> saveMoUser(MoUserProfile? moSave) async {
    if (moUser == null) return null;
    bool bl = await _pref.setToPref("moUser", str: jsonEncode(moSave!.toJson()));
    if (bl) {
      moUser = moSave;
      (moUser!.providers ?? []).forEach((element) {
        print(element.provider);
      });
    }
    return moUser;
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////
  oAuthLogIn(String provider, {bool shouldNotify = true}) async {
    Uri uri = Uri.parse("${baseDiol[0]}auth/$provider");
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication, webOnlyWindowName: "_self")) {
      throw Exception('Could not launch $uri');
    }
  }

  Future<String> tokenMe(String token, {bool shouldNotify = true, ProAppSettings? proApp}) async {
    if (token.isEmpty) return "";
    isLoadingLS.add(true);
    _dio.xAccessToken = token;
    MoResponse ms = await _dio.getAsync("me");
    if (ms.status != "ok" || ms.success == false || ms.result == null || ms.result!.isEmpty) {
      //print(ms.status);print(ms.success);print(ms.result);
      _dio.xAccessToken = "";
      if (isLoadingLS.isNotEmpty) isLoadingLS.removeAt(0);
      return "";
    }
    moUser = MoUserProfile.fromJson(ms.result![0]);
    saveMoUser(moUser);
    String tk = await (proApp ?? _proAppSetting).setToken(moUser?.token ?? "", shouldNotify: shouldNotify);
    if (isLoadingLS.isNotEmpty) isLoadingLS.removeAt(0);
    notilistner(shouldNotify);
    return tk;
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////

  notilistner([bool shouldNotify = false]) {
    if (shouldNotify) notifyListeners();
  }
}
