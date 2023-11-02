import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get.dart';

import 'bottom_tab_bar/bottom_tab_bar_bindings.dart';
import 'bottom_tab_bar/bottom_tab_bar_view.dart';

class RouteManager {
  static const String home = '/';

  static List<GetPage> pages = [
    GetPage(
      name: home,
      page: () => BottomTabBarView(),
      bindings: [BottomTabBarBinding()],
    ),
  ];
}
