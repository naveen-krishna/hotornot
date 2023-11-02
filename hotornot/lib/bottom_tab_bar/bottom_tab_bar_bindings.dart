import 'package:get/get.dart';
import 'package:hotornot/bottom_tab_bar/bottom_tab_bar_controller.dart';
import 'package:hotornot/home/home_controller.dart';

class BottomTabBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BottomTabBarController());
    Get.put(HomeController());
  }
}
