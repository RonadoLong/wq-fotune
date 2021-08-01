import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class UIData {
  //routes
  static const String homeRoute = "/home";
  static const String profileOneRoute = "/View Profile";
  static const String profileTwoRoute = "/Profile 2";
  static const String notFoundRoute = "/No Search Result";
  static const String timelineOneRoute = "/Feed";
  static const String timelineTwoRoute = "/Tweets";
  static const String settingsOneRoute = "/Device Settings";
  static const String shoppingOneRoute = "/Shopping List";
  static const String shoppingTwoRoute = "/Shopping Details";
  static const String shoppingThreeRoute = "/Product Details";
  static const String paymentOneRoute = "/Credit Card";
  static const String paymentTwoRoute = "/Payment Success";
  static const String loginOneRoute = "/Login With OTP";
  static const String loginTwoRoute = "/Login 2";
  static const String dashboardOneRoute = "/Dashboard 1";
  static const String dashboardTwoRoute = "/Dashboard 2";

  //strings
  static const String appName = "stock app";

  //fonts
  static const String quickFont = "Quicksand";
  static const String ralewayFont = "Raleway";
  static const String quickBoldFont = "Quicksand_Bold.otf";
  static const String quickNormalFont = "Quicksand_Book.otf";
  static const String quickLightFont = "Quicksand_Light.otf";

  //images
  static const String imageDir = "assets/images";
  static const String pkImage = "$imageDir/pk.jpg";
  static const String profileImage = "$imageDir/profile.jpg";
  static const String blankImage = "$imageDir/blank.jpg";
  static const String dashboardImage = "$imageDir/dashboard.jpg";
  static const String loginImage = "$imageDir/login.jpg";
  static const String paymentImage = "$imageDir/payment.jpg";
  static const String settingsImage = "$imageDir/setting.jpeg";
  static const String shoppingImage = "$imageDir/shopping.jpeg";
  static const String timelineImage = "$imageDir/timeline.jpeg";
  static const String verifyImage = "$imageDir/verification.jpg";

  //login
  static const String enter_code_label = "Phone Number";
  static const String enter_code_hint = "10 Digit Phone Number";
  static const String enter_otp_label = "OTP";
  static const String enter_otp_hint = "4 Digit OTP";
  static const String get_otp = "Get OTP";
  static const String resend_otp = "Resend OTP";
  static const String login = "Login";
  static const String enter_valid_number = "Enter 10 digit phone number";
  static const String enter_valid_otp = "Enter 4 digit otp";

  //gneric
  static const String error = "Error";
  static const String success = "Success";
  static const String ok = "OK";
  static const String forgot_password = "Forgot Password?";
  static const String something_went_wrong = "Something went wrong";
  static const String coming_soon = "Coming Soon";

  static const Color normal_font_color = Color(0xFF24292E);
  static const Color normal_line_color = Colors.grey;
  static const Color primary_color = Color.fromRGBO(86, 119, 252, 1);
  static const Color grey_color = Color(0xFF24292E);
  static const Color refresh_color = primary_color;
  static const Color default_color = Color(0xff515151);
  static const Color two_color = Color(0xff666666);
  static const Color one_color = Color(0xff333333);
  static const Color three_color = Color(0xff999999);
  static const Color bg_color = Color(0xfff7f7f7);
  static const Color ImgBg_color = Color(0xffE4E9FD);



  static Color win_color_200 = Colors.teal.shade100;
  static Color win_color = Colors.teal;

  static Color red_color_200 = Colors.red.shade100;
  static Color blueGrey = Colors.blueGrey.shade600;

  //新增
  static const Color white_color = Color(0xffFFFFFF); //白色
  static const Color turquoise_color = Color(0xff0AB45B); //青色
  static const Color red_color = Color(0xffDB3737);//红色
  static const Color blue_color = Color(0xff5777FD);//蓝色
  static const Color blck_color = Color.fromRGBO(92, 88, 88, 1);
  static const Color shadow_color = Color.fromRGBO(196, 187, 187, 0.4);//阴影颜色

  static const Color border_color = Color(0xffeeeeee);//边框颜色,分割线颜色

  static const Color wallet_bg_color = Color.fromRGBO(222, 82, 82, 1);//钱包背景颜色




//colors
  static List<Color> kitGradients = [
    // new Color.fromRGBO(103, 218, 255, 1.0),
    // new Color.fromRGBO(3, 169, 244, 1.0),
    // new Color.fromRGBO(0, 122, 193, 1.0),
    Colors.blueGrey.shade800,
    Colors.black87,
  ];
  static List<Color> kitGradients2 = [
    Colors.cyan.shade600,
    UIData.primary_color,
  ];

  //randomcolor
  static final Random _random = new Random();

  /// Returns a random color.
  static Color next() {
    return new Color(0xFF000000 + _random.nextInt(0x00FFFFFF));
  }
}
