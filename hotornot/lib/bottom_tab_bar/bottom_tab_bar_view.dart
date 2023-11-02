import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotornot/home/home_view.dart';
import '../colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../image_constants.dart';
import 'bottom_tab_bar_controller.dart';

class BottomTabBarView extends StatefulWidget {
  const BottomTabBarView({Key? key}) : super(key: key);

  @override
  State<BottomTabBarView> createState() => _BottomTabBarViewState();
}

class _BottomTabBarViewState extends State<BottomTabBarView> {
  final List<Widget> bottomTabViews = [
    const HomeView(),
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomTabBarController>(builder: (controller) {
      return DefaultTabController(
        length: 5,
        initialIndex: controller.currentIndex,
        child: Scaffold(
          backgroundColor: transparentColor,
          extendBody: true,
          bottomNavigationBar: GetBuilder<BottomTabBarController>(
            builder: (controller) {
              return TabBar(
                unselectedLabelColor: Colors.white,
                indicatorColor: deepOrangeColor,
                indicator: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: deepOrangeColor,
                      blurRadius: 20.r,
                      offset: Offset(0, 75.h),
                    ),
                  ],
                ),
                labelColor: transparentColor,
                indicatorPadding: EdgeInsets.only(right: 22.w, left: 22.w),
                labelPadding: EdgeInsets.only(
                    top: 7.0.h, bottom: 20.0.h, right: 2.w, left: 2.w),
                onTap: (index) => controller.onTap(index),
                overlayColor:
                    MaterialStateProperty.all<Color>(transparentColor),
                tabs: [
                  Tab(
                    icon: SvgPicture.asset(
                      unionIcon,
                      color: controller.currentIndex == 0
                          ? deepOrangeColor
                          : whiteColor,
                      height: 25.h,
                      width: 25.h,
                    ),
                  ),
                  Tab(
                    icon: Image.asset(
                      trophyImage,
                      color: controller.currentIndex == 1
                          ? deepOrangeColor
                          : whiteColor,
                      height: 25.h,
                      width: 25.h,
                    ),
                  ),
                  Tab(
                      icon: CircleAvatar(
                    radius: 30.r,
                    backgroundColor: deepOrangeColor,
                    child: Icon(
                      Icons.add,
                      color: whiteColor,
                      size: 30.sp,
                    ),
                  )),
                  Tab(
                    icon: SvgPicture.asset(
                      walletIcon,
                      height: 25.h,
                      width: 25.w,
                      color: controller.currentIndex == 3
                          ? deepOrangeColor
                          : whiteColor,
                    ),
                  ),
                  Tab(
                    icon: SvgPicture.asset(
                      menuIcon,
                      color: controller.currentIndex == 4
                          ? deepOrangeColor
                          : whiteColor,
                      height: 20.h,
                      width: 20.w,
                    ),
                  ),
                ],
              );
            },
          ),
          body: bottomTabViews[controller.currentIndex],
        ),
      );
    });
  }
}
