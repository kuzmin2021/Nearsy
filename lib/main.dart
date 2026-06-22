import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'auth/supabase_auth/supabase_user_provider.dart';
import 'auth/supabase_auth/auth_util.dart';

import '/backend/supabase/supabase.dart';
import '/floter/floter_theme.dart';
import '/services/i18n/app_labels.dart';
import '/services/i18n/app_labels_delegate.dart';
import '/services/notification_service.dart';
import 'floter/floter_util.dart';
import 'floter/internationalization.dart';
import 'floter/nav/nav.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await SupaFlow.initialize();

  await FloterTheme.initialize();

  await AppLabels.initialize();
  await AppLabels.loadTranslations(
    AppLabels.getStoredLocale()?.toString() ??
        _localeCode(PlatformDispatcher.instance.locale),
  );

  final appState = FTAppState(); // Initialize FTAppState
  await appState.initializePersistedState();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}

String _localeCode(Locale locale) {
  if (locale.scriptCode != null && locale.scriptCode!.isNotEmpty) {
    return '${locale.languageCode}_${locale.scriptCode}';
  }
  if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
    return '${locale.languageCode}_${locale.countryCode}';
  }
  return locale.languageCode;
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale? _locale = AppLabels.getStoredLocale();

  static Locale _resolveLocale(String language) => language.contains('_')
      ? _localeFromParts(language.split('_').first, language.split('_').last)
      : Locale(language);

  static Locale _localeFromParts(String languageCode, String localePart) {
    if (localePart.length == 4) {
      return Locale.fromSubtags(
        languageCode: languageCode,
        scriptCode: localePart,
      );
    }
    return Locale(languageCode, localePart);
  }

  ThemeMode _themeMode = FloterTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.path;
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<BaseAuthUser> userStream;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = nearsySupabaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });
    jwtTokenStream.listen((_) {});
    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );

    NotificationService().initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      NotificationService().checkUnseenMatches();
    }
  }

  void setLocale(String language) {
    safeSetState(() => _locale = _resolveLocale(language));
    AppLabels.storeLocale(language);
    AppLabels.loadTranslations(language);
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FloterTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Nearsy',
      localizationsDelegates: [
        AppLabelsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
        Locale('hi'),
        Locale('es'),
        Locale('fr'),
        Locale('ar'),
        Locale('bn'),
        Locale('ru'),
        Locale('pt'),
        Locale('pt', 'BR'),
        Locale('it'),
        Locale('ur'),
        Locale('id'),
        Locale('de'),
        Locale('ja'),
        Locale('pcm'),
        Locale('ar', 'EG'),
        Locale('mr'),
        Locale('te'),
        Locale('tr'),
        Locale('ta'),
        Locale('yue'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
        fontFamilyFallback: const ['NotoColorEmoji'],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
        fontFamilyFallback: const ['NotoColorEmoji'],
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
