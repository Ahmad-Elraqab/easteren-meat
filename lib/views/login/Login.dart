import 'package:drivers/AppLocalization.dart';
import 'package:drivers/constants/colors.dart';
import 'package:drivers/constants/constants.dart';
import 'package:drivers/constants/routes.dart';
import 'package:drivers/provider/GeneralProvider.dart';
import 'package:drivers/views/custom_widgets/MyAppBar.dart';
import 'package:drivers/views/home/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  TextEditingController usermobile = TextEditingController();
  TextEditingController password = TextEditingController();

  final FocusNode _Focus1 = FocusNode();
  final FocusNode _Focus2 = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, allowFontScaling: true);
    return SafeArea(
      child: Scaffold(
        backgroundColor: offwhite,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                MyAppBar(1),
                Container(
                  margin: EdgeInsetsDirectional.only(top: 100.h, start: 45.w),
                  child: myTexts(),
                ),
                SizedBox(height: 90.h),
                code(),
                myTextField(getTranslated(context, 'Password'), password,
                    _Focus2, _Focus2, 0),
                SizedBox(height: 80.h),
                myButton1(),
                SizedBox(height: 80.h)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(getTranslated(context, 'Login'),
            style: (TextStyle(
                fontFamily: NEO_SANS_FONT_FAMILY,
                color: darkblack,
                fontSize: 69.ssp))),
        SizedBox(height: 15.h),
        Text(getTranslated(context, 'Enter_loginData'),
            style: (TextStyle(
                fontFamily: NEO_SANS_FONT_FAMILY,
                color: gray0,
                fontSize: 42.ssp))),
      ],
    );
  }

  Widget myTextField(String str, TextEditingController controller,
      FocusNode focusNode, FocusNode nextFocusNode, int i) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 80.w, start: 80.w, top: 25.h),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return getTranslated(context, 'Please_Enter_Required');
          }
          return null;
        },
        obscureText: i == 0? true: false,
        keyboardType: i == 0 ? TextInputType.text : TextInputType.phone,
        cursorColor: primaryColor,
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: primaryColor,
            fontFamily: NEO_SANS_FONT_FAMILY,
            fontSize: 42.ssp),
        textInputAction: (focusNode != nextFocusNode)
            ? TextInputAction.next
            : TextInputAction.done,
        decoration: InputDecoration(
            filled: true,
            fillColor: white,
            hintText: str,
            hintStyle: TextStyle(
                color: gray0,
                fontFamily: NEO_SANS_FONT_FAMILY,
                fontSize: 42.ssp),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: offwhite0, width: 3.w),
                borderRadius: BorderRadius.all(Radius.circular(40.h))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: offwhite0, width: 3.w),
                borderRadius: BorderRadius.all(Radius.circular(40.h))),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: red, width: 3.w),
                borderRadius: BorderRadius.all(Radius.circular(40.h))),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: red, width: 3.w),
                borderRadius: BorderRadius.all(Radius.circular(40.h)))),
        onEditingComplete: () {
          setState(() {
            (focusNode != nextFocusNode)
                ? FocusScope.of(context).requestFocus(nextFocusNode)
                : focusNode.unfocus();
          });
        },
      ),
    );
  }

  Widget myTextFieldMobile(String str, TextEditingController controller,
      FocusNode focusNode, FocusNode nextFocusNode, int i) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 80.w, start: 80.w, top: 25.h),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return getTranslated(context, 'Please_Enter_Required');
          }
          return null;
        },
        obscureText: i == 0? true: false,
        keyboardType: i == 0 ? TextInputType.text : TextInputType.phone,
        cursorColor: primaryColor,
        controller: controller,
        focusNode: focusNode,
        maxLength: 9,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: primaryColor,
            fontFamily: NEO_SANS_FONT_FAMILY,
            fontSize: 42.ssp),
        textInputAction: (focusNode != nextFocusNode)
            ? TextInputAction.next
            : TextInputAction.done,
        decoration: InputDecoration(
            filled: true,
            fillColor: white,
            hintText: str,
            hintStyle: TextStyle(
                color: gray0,
                fontFamily: NEO_SANS_FONT_FAMILY,
                fontSize: 42.ssp),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: offwhite0, width: 3.w),
                borderRadius: BorderRadius.all(Radius.circular(40.h))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: offwhite0, width: 3.w),
                borderRadius: BorderRadius.all(Radius.circular(40.h))),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: red, width: 3.w),
                borderRadius: BorderRadius.all(Radius.circular(40.h))),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: red, width: 3.w),
                borderRadius: BorderRadius.all(Radius.circular(40.h)))),
        onEditingComplete: () {
          setState(() {
            (focusNode != nextFocusNode)
                ? FocusScope.of(context).requestFocus(nextFocusNode)
                : focusNode.unfocus();
          });
        },
      ),
    );
  }

  Widget code() {
    return Stack(
      children: <Widget>[
        myTextFieldMobile(getTranslated(context,'Mobile_num'), usermobile, _Focus1, _Focus2, 2),
        mobileCode()
      ],
    );
  }

  Widget mobileCode() {
    return Container(
      height: 80.h,
      alignment: AlignmentDirectional.center,
      margin: EdgeInsetsDirectional.only(end: 110.w, top: 70.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          VerticalDivider(color: primaryColor, thickness: 1.2),
          Text("966+",
              style: (TextStyle(
                  fontFamily: NEO_SANS_FONT_FAMILY,
                  color: darkblack,
                  fontSize: 42.ssp))),
        ],
      ),
    );
  }

  Widget myButton1() {
    return Center(
      child: Container(
        height: 170.h,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsetsDirectional.only(end: 85.w, start: 85.w, top: 25.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.w), color: primaryColor),
        child: FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset("assets/images/in.svg"),
              SizedBox(width: 25.w),
              Text(getTranslated(context,'Login'),
                  textAlign: TextAlign.center,
                  style: (TextStyle(
                    fontFamily: NEO_SANS_FONT_FAMILY,
                    color: white,
                    fontSize: 48.ssp,
                  ))),
            ],
          ),
          onPressed: () {
            if (_formKey.currentState.validate())
              loginUser();
          },
        ),
      ),
    );
  }
  void loginUser() {
      Provider.of<GeneralProvider>(context, listen: false).userLogin(
        context: context,
        body: {
          'mobile': usermobile.text.toString(),
          'password': password.text.toString(),
        },
      );
  }
}
