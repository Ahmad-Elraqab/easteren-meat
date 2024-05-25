import 'package:drivers/constants/colors.dart';
import 'package:drivers/provider/GeneralProvider.dart';
import 'package:drivers/views/bank_accounts/Account.dart';
import 'package:drivers/views/notifications/Notifications.dart';
import 'package:drivers/views/orders/Orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' ;
import 'package:provider/provider.dart';



class HomeScreen extends StatefulWidget {
  int index ;
  HomeScreen(this.index);
  @override
  _HomeScreen createState() => new _HomeScreen(index);
}

class _HomeScreen extends State<HomeScreen> {
  int index;
  _HomeScreen(this.index);

  //int _currentIndex = 0;

  static final List<String> iconsName = [
    "assets/images/surface.svg",
    "assets/images/notif.svg",
    "assets/images/account.svg"
  ];

  final List<Widget> iconsTaps = [
    SvgPicture.asset(iconsName[0]),
    SvgPicture.asset(iconsName[1]),
    SvgPicture.asset(iconsName[2]),
  ];

  final List<Widget> activeIconsTaps = [
      SvgPicture.asset(iconsName[0], color: white),
      SvgPicture.asset(iconsName[1], color: white),
      SvgPicture.asset(iconsName[2], color: white),
  ];

  final List<Widget> _children = [
    Orders(),
    Notifications(),
    Account(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context, allowFontScaling: false);

    // TODO: implement build
    return WillPopScope(
      onWillPop: onBack,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: white,
          bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped,
            elevation: 20,
            currentIndex: index,
            backgroundColor: white,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  icon: iconsTaps[0],
                  title:  Container(height: 20.h,),
                  activeIcon: myActiveIcon(activeIconsTaps[0])),
              BottomNavigationBarItem(
                  icon: iconsTaps[1],
                  title:  Container(height: 20.h,),
                  activeIcon: myActiveIcon(activeIconsTaps[1])),
              BottomNavigationBarItem(
                  icon: iconsTaps[2],
                  title: Container(height: 20.h,),
                  activeIcon: myActiveIcon(activeIconsTaps[2])),
            ],
          ),
          body: _children[index],
        ),
      ),
    );
  }

  Future<bool> onBack(){
    return index > 0? Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          child: HomeScreen(0),
          create: (context) => GeneralProvider(),
        )
    ))?? false: SystemNavigator.pop();
  }

  Widget myActiveIcon(Widget activeIconTap) {
    return Container(
      width: 150.w,
      height: 150.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0), color: primaryColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[activeIconTap],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      this.index = index;
    });

  }
}
