import 'dart:async';

import 'package:drivers/AppLocalization.dart';
import 'package:drivers/constants/colors.dart';
import 'package:drivers/constants/constants.dart';
import 'package:drivers/provider/GeneralProvider.dart';
import 'package:drivers/views/orders/CurrentOrders.dart';
import 'package:drivers/views/orders/PreviousOrders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  static int currentOrdersLength = 0;
  @override
  _Orders createState() => _Orders();

}

class _Orders extends State<Orders> {
  PageController controller;

  List<Widget> list = [CurrentOrders(), PreviousOrders()];
  StreamController<int> _countController = StreamController<int>();

  static TextStyle tabTitleStyle = TextStyle(
      fontFamily: NEO_SANS_FONT_FAMILY, color: bluee, fontSize: 36.ssp);

  List<String> titlesList;

  int currentTab;
  Widget appBarTitle;
  int countOrders = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage: 0, keepPage: false);
    currentTab = 0;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    countOrders = CurrentOrders.currentOrdersLength;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, allowFontScaling: true);
    appBarTitle =
        Text(getTranslated(context, 'Orders'), style: appBarTitleStyle);

    titlesList = [
      getTranslated(context, 'Current_Orders'),
      getTranslated(context, 'Previous_Orders')
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: offwhite,
        appBar: buildBar(),
        body: Column(
          children: <Widget>[
            customTabBar(),
            pagy(),
          ],
        ),
      ),
    );
  }

  Widget buildBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: appBarTitle,
      backgroundColor: primaryColor,
      automaticallyImplyLeading: false,
    );
  }

  Widget customTabBar() {
    return Container(
      color: white,
      height: 135.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          tab1(0),
          Container(
            alignment: AlignmentDirectional.centerEnd,
            height: 60.h,
            child: VerticalDivider(color: gray00, thickness: 1.2),
          ),
          tab2(1)
        ],
      ),
    );
  }

  Widget tab1(int i) {
    return Container(
      height: 135.h,
      width: MediaQuery.of(context).size.width * 1.3 / 3,
      decoration: i == currentTab
          ? BoxDecoration(
          border:
          Border(bottom: BorderSide(width: 9.w, color: primaryColor)))
          : BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 9.w, color: Colors.transparent))),
      child: FlatButton(
        onPressed: () {
          setState(() {
            currentTab = i;
            controller.jumpToPage(currentTab);
          });
        },
        child: Row(
          children: <Widget>[
            Text(titlesList[i], style: tabTitleStyle),
            SizedBox(width: 15.w),
            currentOrdersNum1(i),
          ],
        ),
      ),
    );
  }

  Widget tab2(int i) {
    return Container(
      height: 135.h,
      width: MediaQuery.of(context).size.width * 1.3 / 3,
      decoration: i == currentTab
          ? BoxDecoration(
          border:
          Border(bottom: BorderSide(width: 9.w, color: primaryColor)))
          : BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 9.w, color: Colors.transparent))),
      child: FlatButton(
        onPressed: () {
          setState(() {
            currentTab = i;
            controller.jumpToPage(currentTab);
          });
        },
        child: Row(
          children: <Widget>[
            Text(titlesList[i], style: tabTitleStyle),
            SizedBox(width: 15.w),
          ],
        ),
      ),
    );
  }

  Widget pagy() {
    return Container(
      height: MediaQuery.of(context).size.height * 2 / 3,
      child: PageView(
        controller: controller,
        onPageChanged: (pageId) {
          setState(() {
            currentTab = pageId;
          });
        },
        children: <Widget>[CurrentOrders(), PreviousOrders()],
      ),
    );
  }

  Widget currentOrdersNum1(int i) {
    return  CircleAvatar(
      backgroundColor: primaryColor,
      radius: 40.w,
      child: Center(
        child: StreamBuilder<Object>(
            initialData: 0,
            stream: _someData(),
            builder: (context, snapshot) {
            return Text(snapshot.data.toString()??"00",
                textAlign: TextAlign.center,
                style: (TextStyle(
                    fontFamily: NEO_SANS_FONT_FAMILY,
                    color: white,
                    fontSize: 32.ssp,
                    fontWeight: FontWeight.w300)));;
          }
        ),
      ),
    );
  }

  Stream<int> _someData() async*{
    yield* Stream.periodic(Duration(seconds: 1), (int a){
      print("a = "+CurrentOrders.currentOrdersLength.toString());
      a = CurrentOrders.currentOrdersLength;
      setState(() {

      });
      return a;
    });
  }
}
