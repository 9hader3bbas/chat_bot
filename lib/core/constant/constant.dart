import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app_assets/app_assets.dart';

class AppConstant {
  static const double appPaddingTen = 10.0;
  static const double appPaddingTwentyTwo = 22.0;
  static const double appPaddingTwentyFive = 25.0;
  static const double appPaddingFourtyFour = 44.0;
  static const double appPaddingTwentyOne = 21.0;

  static const double appMarginTen = 10.0;
  static const double appMarginTwentyTwo = 22.0;
  static const double appMarginTwentyFive = 25.0;
  static const double appMarginFourtyFive = 44.0;
  static const double appMarginTwentyOne = 21.0;

  static const double spaceFive = 5.0;
  static const double spaceTen = 10.0;
  static const double spaceFifteen = 15.0;
  static const double spaceTwenty = 20.0;
  static const double spaceTwentyFive = 25.0;
  static const double spaceThirsty = 30.0;
  static const double spaceThirstyFive = 35.0;
  static const double spaceFourty = 40.0;
  static const double spaceFourtyFive = 45.0;
  static const double spaceFifty = 50.0;

  static double fontSizeFour = 4.0.sp;
  static double fontSizeEight = 8.0.sp;
  static double fontSizeTen = 10.0.sp;
  static double fontSizeTwelve = 12.0.sp;
  static double fontSizeFourteen = 14.0.sp;
  static double fontSizeSixteen = 16.0.sp;
  static double fontSizeEighteen = 18.0.sp;
  static double fontSizeTwenty = 20.0.sp;
  static double fontSizeTwentyFour = 24.0.sp;
  static double fontSizeTwentyEight = 28.0.sp;
  static double fontSizeThirsty = 30.0.sp;
  static double fontSizeThirstyFive = 35.0.sp;

  static double appRadius = 12.r;
  static double sizeFloatingActionButtonThirty = 30.r;
  static double heightButtonSixty = 60.r;
  static double widthButtonThreeHandred = 300.w;
  static double widthButtonOneHandredAndThirtyThree = 133.w;
  static double widthButtonOneHandredAndFourtyFour = 144.w;
  static double widthButtonOneHandredAndSixtyOne = 161.w;
  static double appWidthThemeOne = 1.r;
  static double appWidthThemeTwo = 300.r;
  static double screenHeight = 812;
  static double screenWidth = 375;

  static bool isAndroidApp = GetPlatform.isAndroid;
  static bool isIOSApp = GetPlatform.isIOS;
  static bool isDialogOpenApp = Get.isDialogOpen ?? false;
  static bool isSnackbarOpenApp = Get.isSnackbarOpen;

  static String currentRouteApp = Get.currentRoute;
  static String previousRouteApp = Get.previousRoute;
}
