import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hotornot/bottom_tab_bar/bottom_tab_bar_bindings.dart';
import 'package:hotornot/route_manager.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then(
      (value) => runApp(const MyApp()),
    );
  }, (error, stackTrace) {
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393.0, 852.0),
      builder: (context, child) => GetMaterialApp(
        title: 'HotOrNot',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "regular",
          // primaryColor: appColor,
          // backgroundColor: appColor,
          dividerColor: Colors.transparent,
        ),
        getPages: RouteManager.pages,
        initialRoute: RouteManager.home,
        initialBinding: BottomTabBarBinding(),
      ),
    );
  }
}
