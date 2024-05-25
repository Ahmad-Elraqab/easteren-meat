import 'package:drivers/constants/colors.dart';
import 'package:drivers/constants/constants.dart';
import 'package:drivers/provider/GeneralProvider.dart';
import 'package:drivers/provider/LanguagesProvider.dart';
import 'package:drivers/singleton/AppSharedPreferences.dart';
import 'package:drivers/singleton/dio.dart';
import 'package:drivers/views/custom_widgets/MyAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'BankAccounts.dart';

class Account extends StatefulWidget {
  Account({Key key}) : super(key: key);

  @override
  _Account createState() => _Account();
}

class _Account extends State<Account> {
  bool isPress;
  List<bool> isArabic;
  String image;
  String username;
  String carType;
  String carNumber;
  Locale lang;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isPress = false;
    isArabic = [true, false];
    lang = Provider.of<LanguagesProvider>(context, listen: false).appLocal;
    if (lang.languageCode.toLowerCase() == "ar")
      isArabic = [true, false];
    else
      isArabic = [false, true];

    Provider.of<GeneralProvider>(context, listen: false).getMyProfile(context, (){
      setState(() {
        image = Provider.of<GeneralProvider>(context, listen: false).loginModel.image;
        username = Provider.of<GeneralProvider>(context, listen: false).loginModel.name;
        carType = Provider.of<GeneralProvider>(context, listen: false).loginModel.carType;
        carNumber = Provider.of<GeneralProvider>(context, listen: false).loginModel.carNumber;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: offwhite,
        body: Container(
          width: double.infinity,
          child: ListView(
              children: <Widget>[
                MyAppBar(
                  0,
                  image: image != null
                      ? image
                      : "https://easternmeat.techzone.ps/default-user.png",
                ),
                SizedBox(height: 70.h),
                driverDetails(),
                SizedBox(height: 80.h),
                userListDetails()
              ]),
        ),
      ),
    );
  }

  Widget driverDetails() {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 100.h),
      child: Column(
        children: <Widget>[
          companyInfo(getTranslated(context, 'Driver_Name'), username ?? ""),
          SizedBox(height: 30.h),
          companyInfo(getTranslated(context, 'Car_Type'), carType ?? ""),
          SizedBox(height: 30.h),
          companyInfo(getTranslated(context, 'Car_Num'), carNumber ?? ""),
        ],
      ),
    );
  }

  Widget userListDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
            margin:
                EdgeInsetsDirectional.only(end: 24.w, start: 80.w, top: 30.h),
            color: offwhite,
            child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                      child: BankAccounts(),
                      create: (context) => GeneralProvider()))),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset("assets/images/bank.svg"),
                  Container(
                    margin: EdgeInsetsDirectional.only(start: 50.w),
                    child: Text(getTranslated(context, 'Bank_Accounts'),
                        style: (TextStyle(
                          fontFamily: SST_FONT_FAMILY,
                          color: blackgray,
                          fontSize: 43.ssp,
                        ))),
                  ),
                ],
              ),
            )),
        Divider(
          color: offwhite0,
          thickness: 1.2,
        ),
        !isPress ? appLang() : settings(),
        Divider(
          color: offwhite0,
          thickness: 1.2,
        ),
      ],
    );
  }

  Widget companyInfo(perStr, varStr) {
    return Row(
      children: <Widget>[
        Container(
          width: 300.w,
          alignment: AlignmentDirectional.topStart,
          child: Text(perStr,
              textAlign: TextAlign.start,
              style: (TextStyle(
                  fontFamily: NEO_SANS_FONT_FAMILY,
                  color: darkblack,
                  fontSize: 42.ssp))),
        ),
        Container(
          alignment: AlignmentDirectional.topStart,
          child: Text(varStr,
              textAlign: TextAlign.center,
              style: (TextStyle(
                  fontFamily: NEO_SANS_FONT_FAMILY,
                  color: gray0,
                  fontSize: 42.ssp))),
        ),
      ],
    );
  }

  Widget settings() {
    return Column(
      children: <Widget>[
        appLang(),
        Container(
          margin: EdgeInsetsDirectional.only(end: 50.w, start: 50.w),
          color: offwhite,
          child: ListTile(
            title: Text(getTranslated(context, 'Arabic'),
                style: (TextStyle(
                  fontFamily: SST_FONT_FAMILY, color: blackgray,
                  fontSize: 43.ssp,
                  // fontWeight: FontWeight.w500
                ))),
            trailing: radioCircle(0),
            onTap: () {
              setState(() {
                isArabic = [true, false];
                Provider.of<LanguagesProvider>(context, listen: false)
                    .changeLanguage(context, Locale("ar"), "ar", () {
                  print("app language ar successfully");
                });
              });
            },
          ),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(end: 50.w, start: 50.w),
          color: offwhite,
          child: ListTile(
            title: Text(getTranslated(context, 'English'),
                style: (TextStyle(
                  fontFamily: SST_FONT_FAMILY, color: blackgray,
                  fontSize: 43.ssp,
                  // fontWeight: FontWeight.w500
                ))),
            trailing: radioCircle(1),
            onTap: () {
              setState(() {
                isArabic = [false, true];
                Provider.of<LanguagesProvider>(context, listen: false)
                    .changeLanguage(context, Locale("en"), "en", () {
                  print("app language en successfully");
                });
              });
            },
          ),
        ),
      ],
    );
  }

  Widget appLang() {
    return Container(
      margin: EdgeInsetsDirectional.only(end: 24.w, start: 80.w, top: 30.h),
      color: offwhite,
      child: InkWell(
        onTap: () {
          setState(() {
            isPress = !isPress;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                SvgPicture.asset("assets/images/language.svg"),
                Container(
                  margin: EdgeInsetsDirectional.only(start: 50.w),
                  child: Text(getTranslated(context, 'App_Lang'),
                      style: (TextStyle(
                        fontFamily: SST_FONT_FAMILY, color: blackgray,
                        fontSize: 43.ssp,
                        // fontWeight: FontWeight.w500
                      ))),
                ),
              ],
            ),
            Container(
                margin: EdgeInsetsDirectional.only(end: 70.w),
                child: SvgPicture.asset("assets/images/arrow.svg")),
          ],
        ),
      ),
    );
  }

  Widget radioCircle(int i) {
    return Container(
      height: 75.w,
      width: 75.w,
      margin: EdgeInsetsDirectional.only(start: 45.w),
      decoration: BoxDecoration(
        color: white,
        shape: BoxShape.circle,
        border: isArabic[i]
            ? null
            : Border.all(color: white11, width: 4.5.w),
      ),
      child: isArabic[i]
          ? SvgPicture.asset(
              "assets/images/ic_check.svg",
              height: 81.w,
              width: 81.w,
            )
          : null,
    );
  }
}
