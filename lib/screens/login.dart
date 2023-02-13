import '../cmn.dart';

class LoginScreen extends StatefulWidget {
  final Map<String, String> query;
  const LoginScreen({Key? key, this.query = const {}}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = true;
  setLoading([bool? val]) {
    _isLoading = val ?? !_isLoading;
    setS();
  }

  setS() {
    if (mounted) setState(() {});
  }

  ProUser? _proUser;
  ProAppSettings? _appSettings;

  @override
  void initState() {
    super.initState();
    changeWindowHref("/");
  }

  @override
  void didUpdateWidget(LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    changeWindowHref("/");
    if (oldWidget.query != widget.query) checkMe();
  }

  void checkMe() async {
    if (widget.query.containsKey("token") && widget.query["token"]!.isNotEmpty) {
      String token = widget.query["token"] ?? "";
      await _proUser!.tokenMe(token, proApp: _appSettings);
    }
  }

  void _loadProvider(BuildContext ctx) async {
    _proUser ??= Provider.of<ProUser>(ctx);
    _appSettings ??= Provider.of<ProAppSettings>(ctx);
  }

  @override
  Widget build(BuildContext context) {
    _loadProvider(context);
    return Consumer<ProUser>(
        builder: (context, proUser, child) => Scaffold(
            body: proUser.isLoadingLS.isNotEmpty
                ? const Center(child: CircularProgressIndicator.adaptive())
                : proUser.serverProviders.isEmpty
                    ? const Center(child: Text("No data"))
                    : SizedBox(
                        width: double.infinity,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: loginProviders.map((e) {
                              bool val = loginProviders.contains(e);
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: strToWidget(
                                      onPressed: !proUser.serverProviders.contains(e)
                                          ? null
                                          : () {
                                              try {
                                                proUser.oAuthLogIn(e);
                                              } catch (e) {
                                                if (kDebugMode) print(e);
                                              }
                                            },
                                      str: e));
                            }).toList()))));
  }

  List<String> loginProviders = ["google", "github", "linkedin", "microsoft", "facebook", "slack", "twitter"];

  Widget strToWidget({Function()? onPressed, String str = ""}) {
    IconData iconData = Icons.facebook;
    Color bgColor = Colors.blue, textColor = Colors.white;
    switch (str) {
      case "google":
        iconData = IonIcons.logo_google;
        bgColor = Colors.blue;
        textColor = Colors.white;
        break;
      case "github":
        iconData = IonIcons.logo_github;
        bgColor = Colors.black87;
        textColor = Colors.white;
        break;
      case "linkedin":
        iconData = IonIcons.logo_linkedin;
        bgColor = Colors.blue.shade700;
        textColor = Colors.white;
        break;
      case "microsoft":
        iconData = IonIcons.logo_microsoft;
        bgColor = Colors.orange.shade800;
        textColor = Colors.white;
        break;
      case "facebook":
        iconData = IonIcons.logo_facebook;
        bgColor = Colors.blue.shade900;
        textColor = Colors.white;
        break;
      case "slack":
        iconData = IonIcons.logo_slack;
        bgColor = Colors.purple.shade800;
        textColor = Colors.white;
        break;
      case "twitter":
        iconData = IonIcons.logo_twitter;
        bgColor = Colors.blue.shade400;
        textColor = Colors.white;
        break;
    }

    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(onPressed == null ? null : bgColor)),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(spacing: 4, runSpacing: 4, children: [
              Icon(iconData, color: onPressed == null ? bgColor : textColor),
              Text("Login In With $str", style: TextStyle(color: onPressed == null ? bgColor : textColor))
            ])));
  }
}
