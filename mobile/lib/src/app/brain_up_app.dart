import 'package:flutter/material.dart';

import '../data/app_locale_store.dart';
import '../data/family_profile_store.dart';
import '../features/home/family_shell.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import 'app_controller.dart';

class BrainUpApp extends StatefulWidget {
  const BrainUpApp({
    required this.familyProfileStore,
    this.appLocaleStore,
    this.locale,
    super.key,
  });

  final FamilyProfileStore familyProfileStore;
  final AppLocaleStore? appLocaleStore;
  final Locale? locale;

  @override
  State<BrainUpApp> createState() => _BrainUpAppState();
}

class _BrainUpAppState extends State<BrainUpApp> {
  late final AppController _controller;
  Locale _locale = const Locale('ru');

  @override
  void initState() {
    super.initState();
    _locale = widget.locale ?? const Locale('ru');
    _controller = AppController(widget.familyProfileStore)..load();
    _loadSavedLocale();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => context.l10n.appTitle,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildAppTheme(),
      home: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const _LoadingScreen();
          }

          final familyProfile = _controller.familyProfile;
          if (familyProfile == null) {
            return OnboardingScreen(
              onComplete: _controller.completeOnboarding,
            );
          }

          return FamilyShell(
            controller: _controller,
            currentLocale: _locale,
            onLocaleChanged: _changeLocale,
          );
        },
      ),
    );
  }

  Future<void> _loadSavedLocale() async {
    if (widget.locale != null) {
      return;
    }

    final savedLocale = await widget.appLocaleStore?.load();
    if (!mounted || savedLocale == null) {
      return;
    }

    setState(() {
      _locale = savedLocale;
    });
  }

  Future<void> _changeLocale(Locale locale) async {
    if (_locale.languageCode == locale.languageCode) {
      return;
    }

    setState(() {
      _locale = locale;
    });
    await widget.appLocaleStore?.save(locale);
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
