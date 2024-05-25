import 'package:drivers/AppLocalization.dart';
import 'package:drivers/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//Langauge
String getTranslated(BuildContext context, String key) {
  return AppLocalization.of(context).translate(key).toString();
}

const ENGLISH ='en';
const ARABIC ='ar';
const COUNTRYCODE ='US';

//Fonts
const String NEO_SANS_FONT_FAMILY = "Neo-Sans";
const String SST_FONT_FAMILY = "Sst-Arabic";
const String ROBOTO_FONT_FAMILY = "Roboto";

//Order Statuses
final String PENDING = "Pending";
final String CURRENT = "Current";
final String PREVIOUS = "Previous";



//TextStyle
TextStyle appBarTitleStyle = TextStyle(fontFamily:NEO_SANS_FONT_FAMILY, color: white, fontSize: 48.ssp);

