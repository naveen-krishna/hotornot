import 'package:get/get.dart';
import '../home/home_controller.dart';

class BottomTabBarController extends GetxController {
  dynamic argumentData = Get.arguments;
  var currentIndex = 0;
  String token = "";

  void updateFocusedIndex(int index) {
    currentIndex = index;
    update();
  }

  onTap(int index) async {
    BottomTabBarController bottomTabBarController = Get.find();
    HomeController homeController = Get.find();
    var currentActiveIndex = bottomTabBarController.currentIndex;
    bottomTabBarController.updateFocusedIndex(index);
    if (currentActiveIndex != index) {
      if (currentActiveIndex == 0) {
        homeController.disposeAllController();
      }
      if (index == 0) {
        homeController.initPageControllerAndVideoControllersWithInitIndex();
      } else if (index == 1) {
      } else if (index == 2) {
      } else if (index == 3) {
      } else if (index == 4) {}
    }
  }
}
