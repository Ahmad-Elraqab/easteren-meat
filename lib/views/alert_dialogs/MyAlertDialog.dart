import 'package:drivers/AppLocalization.dart';
import 'package:drivers/constants/colors.dart';
import 'package:drivers/constants/constants.dart';
import 'package:drivers/constants/routes.dart';
import 'package:drivers/provider/GeneralProvider.dart';
import 'package:drivers/views/home/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MyAlertDialog extends StatelessWidget {
  int i;
  String orderStatus;
  MyAlertDialog(this.i, this.orderStatus);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 50.w, end: 50.w),
      alignment: AlignmentDirectional.center,
      child: Material(
        child: Container(
          height: MediaQuery.of(context).size.height * 1.8 / 3,
          padding: EdgeInsetsDirectional.only(start: 50.w, end: 50.w),
          color: white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  i == 0
                      ? SvgPicture.asset("assets/images/check.svg")
                      : SvgPicture.asset("assets/images/fail.svg"),
                  SizedBox(height: 35.h),
                  myText(context),
                ],
              ),
              myButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget myButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsetsDirectional.only(top: 30.h),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(24.w), color: red),
      child: FlatButton(
        padding: EdgeInsets.all(30.w),
        child: Text(getTranslated(context,'Orders'),
            textAlign: TextAlign.center,
            style: (TextStyle(
              fontFamily: SST_FONT_FAMILY,
              color: white,
              fontSize: 46.ssp,
            ))),
        onPressed: () {
          i == 0 ? Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              child: HomeScreen(0),
              create: (context) => GeneralProvider(),
            )
          )) : null;
        },
      ),
    );
  }

  Widget myText(BuildContext context) {
    return Container(
      width: 450.w,
      alignment: AlignmentDirectional.center,
      child: Text(
          i == 0
              ? "${ getTranslated(context, 'Change_Status')}"+" "+orderStatus
              : getTranslated(context,'Failed_Change'),
          textAlign: TextAlign.center,
          style: (TextStyle(
            fontFamily: SST_FONT_FAMILY,
            color: bluee,
            fontSize: 48.ssp,
          ))),
    );
  }
}
