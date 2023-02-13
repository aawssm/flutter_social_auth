import '../cmn.dart';

class HomePage extends StatefulWidget {
  final Map<String, String> query;
  const HomePage({Key? key, this.query = const {}}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  MoUserProfile? _moUserProfile;

  setLoading([bool? val]) {
    _isLoading = val ?? !_isLoading;
    setS();
  }

  setS() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.query.containsKey("token")) {
      if (kDebugMode) print("initState home page query has token");
      checkMe();
    }
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query.containsKey("token") || widget.query.containsKey("token")) {
      if (kDebugMode) print("didUpdateWidget home page query has token");
      checkMe();
    }
  }

  void checkMe({String form = "home.dart"}) async {
    await changeWindowHref("/", redirect: true);
    print("  void checkMe($form)");
    if (widget.query.containsKey("token") && widget.query["token"]!.isNotEmpty) {
      String token = widget.query["token"] ?? "";
      await _proUser!.tokenMe(token, proApp: _appState, shouldNotify: false);
      _moUserProfile = await _proUser!.readMoUser(shouldNotify: false);
      setS();
    }
  }

  ProAppSettings? _appState;
  ProUser? _proUser;

  void _loadProvider(BuildContext ctx) async {
    if (_appState != null && _proUser != null) return;
    setLoading(true);
    _appState ??= Provider.of<ProAppSettings>(ctx);
    _proUser ??= Provider.of<ProUser>(ctx, listen: false);
    _moUserProfile = await _proUser!.readMoUser(shouldNotify: false);
    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    _loadProvider(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page'), actions: [
        !kIsWeb
            ? const SizedBox()
            : IconButton(
                onPressed: () async {
                  String tken = "";
                  if (_appState != null) tken = await _appState!.getToken();
                  if (tken.isNotEmpty) changeLocation("$kWindowsScheme://$kWindowshost/?token=$tken");
                },
                icon: const Icon(Icons.open_in_browser)),
        IconButton(
            onPressed: () async {
              await _appState!.logout();
            },
            icon: const Icon(Icons.lock))
      ]),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : _moUserProfile == null
              ? const Center(child: Text("No data"))
              : Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              cacheNetworkImg(_moUserProfile?.profilePic, radius: 100),
                              Text(_moUserProfile?.name ?? "empty name"),
                              Text(_moUserProfile?.username ?? "empty Username"),
                              Text(_moUserProfile?.email ?? "email"),
                              Text((_moUserProfile?.isVerified ?? false) ? "isVerified" : "Not Verified")
                            ])),
                        Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: (_moUserProfile?.providers ?? [])
                                .map((e) => Column(children: [
                                      Text((e.provider ?? "")),
                                      Text(e.username ?? "empty Username"),
                                      Text(e.email ?? "email"),
                                      Text((e.isVerified ?? false) ? "isVerified" : "Not Verified"),
                                      Text(
                                          _smallString(text: e.accessToken, len: 10, pre: "Access Token : ")),
                                      Text(_smallString(
                                          text: e.refreshToken ?? "", len: 10, pre: "Refresh Token : ")),
                                    ]))
                                .toList())
                      ]))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Routemaster.of(context).replace("/login");
        },
        backgroundColor: Colors.red.shade900,
        child: const Icon(Icons.add),
      ),
    );
  }

  _smallString({String? text = "", int len = 20, String pre = "", String post = ""}) {
    if (text == null || text.isEmpty) return "";
    if (len < 0) return pre + text + post;
    return "$pre${text.length <= len ? text : text.substring(0, len)}$post...";
  }
}
