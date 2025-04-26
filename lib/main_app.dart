import 'package:chat_bot/core/constant/colors/colors.dart';
import 'package:chat_bot/core/constant/routes/routes.dart';
import 'package:chat_bot/features/view/pages/splash_screen/splash_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/constant/constant.dart';
import 'core/localization/translation.dart';
import 'pages_routes/pages_routes.dart';

//main app
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(AppConstant.screenWidth, AppConstant.screenHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          translations: AppTranslation(),
          debugShowCheckedModeBanner: false,
          title: "Chat Bot",
          theme: ThemeData(
              textSelectionTheme: TextSelectionThemeData(
            cursorColor: AppColors.primaryColor,
            selectionColor:
                AppColors.primaryColor.withOpacity(0.3), // Highlight color
            selectionHandleColor:
                AppColors.primaryColor, // Selection handle color (pin)
          )),
          enableLog: true,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 250),
          textDirection: TextDirection.ltr,
          getPages: routes,
          initialRoute: AppRoutes.splashScreen,
          home: SplashScreenView(),
        );
      },
    );
  }
}
