import 'dart:convert';

import 'package:drivers/models/responses/login/LoginModel.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences{

  final SharedPreferences sharedPreferences;

  AppSharedPreferences({@required this.sharedPreferences});

  static const ID = 'id';
  static const OPEN_FIRST_INTRO = 'open_first_intro';
  static const TOKEN = 'TOKEN';
  static const FBTOKEN = 'FBTOKEN';
  static const IMAGE = 'IMAGE';
  static const FIRST_NAME = 'first_name';
  static const LAST_NAME = 'last_name';
  static const ROLE = 'role';
  static const MOBILE = 'mobile';
  static const IAT = 'iat';
  static const EMAIL = 'email';
  static const CAR_TYPE = 'car_type';
  static const CAR_NUMBER = 'car_number';
  static const PROVIDER_ID = 'provider_id';
  static const CART_BADGE = 'cart_badge';
  static const FULL_NAME = 'fullname';
  static const USER_TYPE = 'user_type';
  static const MOBILE_VERIFIED_AT = 'EmailVerifiedAt';
  static const USER = 'user';
  static const CART_LIST = 'cartList';
  static const SETTINGS = 'settings';

  Future<void> clear() {
    sharedPreferences.remove(TOKEN);
    sharedPreferences.remove(FBTOKEN);
    sharedPreferences.remove(IMAGE);
    sharedPreferences.remove(FIRST_NAME);
    sharedPreferences.remove(LAST_NAME);
    sharedPreferences.remove(ROLE);
    sharedPreferences.remove(MOBILE);
    sharedPreferences.remove(IAT);
    sharedPreferences.remove(EMAIL);
    sharedPreferences.remove(FULL_NAME);
    sharedPreferences.remove(USER_TYPE);
    sharedPreferences.remove(USER);
    sharedPreferences.remove(MOBILE_VERIFIED_AT);
    sharedPreferences.remove(CAR_TYPE);
    sharedPreferences.remove(CAR_NUMBER);
  }

  Future<void> setUserId(int id) async {
    return await sharedPreferences.setInt(ID, id);
  }

  int getUserId() {
    return sharedPreferences.getInt(ID);
  }

  Future<void> setOpenIntro(bool open) async {
    return await sharedPreferences.setBool(OPEN_FIRST_INTRO, open);
  }

  bool getOpenIntro() {
    return sharedPreferences.getBool(OPEN_FIRST_INTRO) ?? false;
  }

  Future<void> setUserToken(String token) async {
    return await sharedPreferences.setString(TOKEN, token);

  }

  Future<void> clearUserToken() async {
    return await sharedPreferences.setString(TOKEN, null);
  }

  String getUserToken() {
    return sharedPreferences.getString(TOKEN);
  }

  String getUserImage() {
    return sharedPreferences.getString(IMAGE);
  }

  Future<void> setUserImage(String token) async {
    return await sharedPreferences.setString(IMAGE, token);
  }

  Future<void> setUserFirebaseToken(String token) async {
    return await sharedPreferences.setString(FBTOKEN, token);
  }

  Future<void> clearUserFirebaseToken() async {
    return await sharedPreferences.setString(FBTOKEN, null);
  }

  String getUserFirebaseToken() {
    return sharedPreferences.getString(FBTOKEN);
  }

  Future<void> setUserType(String type) async {
    return await sharedPreferences.setString(USER_TYPE, type);
  }

  String getUserType(){
    return sharedPreferences.getString(USER_TYPE);
  }

  Future<void> setMobileVerifiedAt(int type) async {
    return await sharedPreferences.setInt(MOBILE_VERIFIED_AT, type);
  }

  int getMobileVerifiedAte(){
    return sharedPreferences.getInt(MOBILE_VERIFIED_AT);
  }

  Future<void> setFullName(String fullName) async {
    return await sharedPreferences.setString(FULL_NAME, fullName);
  }

  String getUserFullName() {
    return sharedPreferences.getString(FULL_NAME);
  }

  Future<void> setUserMobile(String mobile) async {
    return await sharedPreferences.setString(MOBILE, mobile);
  }

  String getUserMobile() {
    return sharedPreferences.getString(MOBILE);
  }

  Future<void> setUserEmail(String email) async {
    return await sharedPreferences.setString(EMAIL, email);
  }

  String getUserEmail() {
    return sharedPreferences.getString(EMAIL);
  }

  Future<void> setCarType(String carType) async {
    return await sharedPreferences.setString(CAR_TYPE, carType);
  }

  String getCarType() {
    return sharedPreferences.getString(CAR_TYPE);
  }

  Future<void> setCarNumber(String carNumber) async {
    return await sharedPreferences.setString(CAR_NUMBER, carNumber);
  }

  String getCarNumber() {
    return sharedPreferences.getString(CAR_NUMBER);
  }

  Future<void> setLogin(LoginModel loginModel) async {
    String user = jsonEncode(loginModel);
    return await sharedPreferences.setString(USER, user);
  }

  LoginModel getLogin() {
    if(sharedPreferences.getString(USER) == null){
      return null;
    }
    var map =  jsonDecode(sharedPreferences.getString(USER));
    return LoginModel.fromJson(map);
  }
}