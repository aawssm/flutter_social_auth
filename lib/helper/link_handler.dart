import '../cmn.dart';

class LinkHandler {
  final void Function(String link) onLink;
  // StreamSubscription<String?>? _subscription;
  StreamSubscription<Uri>? _subscription;
  late AppLinks _appLinks;
  LinkHandler({required this.onLink});

  Future<void> init() async {
    if (_subscription != null) return;
    _appLinks = AppLinks();

    // Check initial link if app was in cold state (terminated)
    try {
      final appLink = await _appLinks.getInitialAppLink();
      if (appLink != null) {
        _onLink(appLink);
      }
    } on PlatformException {
      // if (kDebugMode)
      if (kDebugMode) print('Failed to get initial link.');
    }
    // Handle link when app is in warm state (front or background)
    _subscription = _appLinks.uriLinkStream.listen((data) => _onLink(data));
  }

  void _onLink(Uri? link) {
    // if (kDebugMode)
    var linkss = "";
    if (kIsWeb) {
      linkss = link.toString().replaceFirst(domain(), '');
    } else {
      linkss = link.toString().replaceFirst("$kWindowsScheme://$kWindowshost", '');
    }
    if (kDebugMode) print("_onLink $linkss");
    onLink(linkss);
  }

  void dispose() => _subscription!.cancel();
}
