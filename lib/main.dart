import './cmn.dart';
import '../helper/link_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && Platform.isWindows) registerProtocolHandler(kWindowsScheme);
  setPathUrlStrategy();

  runApp(const MyApp());
}

// Log in page route
final loggedOutRoutes = RouteMap(routes: {
  '/': (route) => MaterialPage<void>(
      key: const ValueKey('login'),
      child: LoginScreen(query: route.queryParameters))
});

// Normal after-login routes
final loggedInRoutes = RouteMap(
  onUnknownRoute: (route) => MaterialPage<void>(
      child: Scaffold(
          appBar: AppBar(title: const Text("Not Foudn")),
          body: const Center(child: Text("404 Route Not Found")))),
  routes: {
    '/': (route) => MaterialPage<void>(
          key: const ValueKey('home'),
          child: HomePage(query: route.queryParameters),
        ),
    '/login': (route) => MaterialPage<void>(
        key: const ValueKey('login'),
        child: LoginScreen(query: route.queryParameters))
  },
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final RoutemasterDelegate _routemaster = RoutemasterDelegate(
    routesBuilder: (context) {
      if (Provider.of<ProAppSettings>(context).isLoggedIn) {
        return loggedInRoutes;
      } else {
        return loggedOutRoutes;
      }
    },
  );

  late final LinkHandler _linkHandler =
      LinkHandler(onLink: (link) => _routemaster.push(link));

  @override
  void initState() {
    super.initState();
    _linkHandler.init();
  }

  @override
  void dispose() {
    _linkHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ProAppSettings()),
          ChangeNotifierProvider(create: (context) => ProSharedPref()),
          ChangeNotifierProvider(create: (context) => ProUser()),
        ],
        child: Consumer<ProAppSettings>(builder: (context, theme, child) {
          return MaterialApp.router(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              themeMode: theme.themeMode,
              theme: ThemeData(brightness: Brightness.light),
              darkTheme: ThemeData(brightness: Brightness.dark),
              routeInformationParser: const RoutemasterParser(),
              routerDelegate: _routemaster);
        }));
  }
}
