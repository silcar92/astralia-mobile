import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import '../l10n/app_localizations.dart';
import 'common/theme/astralia_theme.dart';
import 'core/i18n/locale_service.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class AstraliaApp extends StatelessWidget {
  const AstraliaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocaleService>().locale;
    // Obx: al cambiar el idioma, la app se reconstruye sola con los nuevos textos (sin perder la pantalla actual)
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => AppLocalizations.of(context).appName,
        theme: buildAstraliaTheme(),
        themeMode: ThemeMode.dark,
        locale: locale.value,
        supportedLocales: LocaleService.supported,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: AppRoutes.splash,
        getPages: AppPages.routes,
      ),
    );
  }
}
