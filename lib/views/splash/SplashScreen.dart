import 'package:drivers/constants/colors.dart';
import 'package:drivers/constants/routes.dart';
import 'package:drivers/provider/GeneralProvider.dart';
import 'package:drivers/singleton/AppSharedPreferences.dart';
import 'package:drivers/singleton/dio.dart';
import 'package:drivers/views/home/HomeScreen.dart';
import 'package:drivers/views/login/Login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    if(getIt<AppSharedPreferences>().getUserToken() != null)
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            child: HomeScreen(0),
            create: (context) => GeneralProvider(),
          )
      ));
    else
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            child: Login(),
            create: (context) => GeneralProvider(),
          )
      ));
  }

  @override
  void initState() {
    super.initState();
    iniFCM();
    startTime();
  }

  Future<void> iniFCM() async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
      },
      onLaunch: (Map<String, dynamic> message) async {
      },
      onResume: (Map<String, dynamic> message) async {
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, allowFontScaling: true);
    return Scaffold(
      appBar: null,
      backgroundColor: primaryColor,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height/4),
                Image.asset("assets/images/logo1.png", width: 800.w,),
                SizedBox(
                  height: 200.h,
                ),
                Container(
                  width: 100.w,
                  child: LoadingIndicator(indicatorType: Indicator.ballScaleRippleMultiple,
                    color: Colors.white,),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
