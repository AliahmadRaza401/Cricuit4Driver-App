import 'package:circuit4driver/constant.dart';
import 'package:circuit4driver/localization/translation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'modules/appPages/app_pages.dart';
import 'modules/initialBinding/initialBinding.dart';
import 'modules/provider/all_providers.dart';
import 'package:google_directions_api/google_directions_api.dart';
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DirectionsService.init('AIzaSyDhAWhuusfBwKiDLM47Oto6pEnNcakn-Ds');
    WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  selectedLanguage() async {}

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: allProvider,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppPages().initial,
        getPages: AppPages.routes,
        navigatorKey: Get.key,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: language == 'ar'
            ? const Locale('ar', 'DZ')
            : const Locale('en', 'US'),
        supportedLocales: const [Locale('en', 'US'), Locale('ar', 'DZ')],
        initialBinding: InitialBinding(),
        fallbackLocale: language == 'ar'
            ? const Locale('ar', 'DZ')
            : const Locale('en', 'US'),
        translations: TranslationService(),
        builder: (context, widget) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget,
          );
        },
      ),
    );
  }
}
