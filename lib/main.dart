import 'package:drivers/AppLocalization.dart';
import 'package:drivers/constants/constants.dart';
import 'package:drivers/constants/routes.dart';
import 'package:drivers/provider/GeneralProvider.dart';
import 'package:drivers/views/bank_accounts/BankAccounts.dart';
import 'package:drivers/views/home/HomeScreen.dart';
import 'package:drivers/views/login/Login.dart';
import 'package:drivers/views/orders/OrderDetails.dart';
import 'package:drivers/views/orders/Orders.dart';
import 'package:drivers/views/splash/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:drivers/singleton/dio.dart' as dio;
import 'package:provider/provider.dart';

import 'provider/LanguagesProvider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dio.init();
  dio.getIt<LanguagesProvider>().fetchLocale();
  runApp(ChangeNotifierProvider(
      create: (_) => dio.getIt<LanguagesProvider>(),
      child:
          Consumer<LanguagesProvider>(builder: (context, applangs, child) {
        return MaterialApp(
            title: 'FluterSplashDemo',
            locale: applangs.appLocal,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.grey,
            ),
            supportedLocales: [
              const Locale(ARABIC, ''),
              const Locale(ENGLISH, COUNTRYCODE),
            ],
            localizationsDelegates: [
              AppLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            /*localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },*/
            home: SplashScreen(),
            routes: <String, WidgetBuilder>{
              SPLASH: (BuildContext context) => SplashScreen(),
              HOME_SCREEN: (BuildContext context) => HomeScreen(0),
              LOGIN_SCREEN: (BuildContext context) => Login(),
              ORDERS_SCREEN: (BuildContext context) => Orders(),
              ORDER_DETAILS_SCREEN: (BuildContext context) => OrderDetails(),
              BANK_ACCOUNTS_SCREEN: (BuildContext context) => BankAccounts()
            });
      })));
}
