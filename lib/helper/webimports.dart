import 'dart:html';

Future<void> changeWindowHref(String newPath, {bool redirect = false, int mils = 1000}) async {
  print("changeWindowHref $newPath");
  Uri n = Uri.parse(window.location.href);

  if (redirect && n.queryParameters.containsKey("token")) {
    print("containsKey toekn ");
    checkAgent();
  }
  await Future.delayed(Duration(milliseconds: mils));
  return window.history.replaceState(null, "", newPath);
}

checkAgent() {
  String userAgent = window.navigator.userAgent;
  print(userAgent);
  List<String> schemeA = ['Windows', 'Android', 'iPhone', 'iPad'];
  String temp = window.location.href;
  bool found = schemeA.any((word) => userAgent.contains(word));

  if (found) {
    try {
      changeLocation(temp.replaceAll(domain(), "sample://sample.com"));
    } catch (e) {
      print(e);
    }
  } else {
    print('Browser is running on an unknown operating system');
  }
}

changeLocation(String str) {
  window.location.href = str;
}

domain() {
  String temp = "${window.location.protocol}//${window.location.host}";
  print(temp);
  return temp;
}
