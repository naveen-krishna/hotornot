import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../video_player_page_widget.dart';
import 'home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return GetBuilder<HomeController>(
          id: "homeMainBody",
          builder: (homeController) {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: HomeWidget(),
            );
          });
    });
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: "mainHome",
      builder: (homeController) {
        return PageViewWidget(
          homeController: homeController,
        );
      },
    );
  }
}

class PageViewWidget extends StatefulWidget {
  final HomeController homeController;
  const PageViewWidget({
    super.key,
    required this.homeController,
  });

  @override
  State<PageViewWidget> createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.homeController.videoList.isEmpty
        ? const CircularProgressIndicator()
        : PageView.builder(
            itemCount: widget.homeController.videoList.length,
            controller: widget.homeController.pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: (index) =>
                widget.homeController.onPageChangedByFeed(index),
            itemBuilder: (context, index) {
              HomeController homeController = Get.find();
              return Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: VideoPlayerPageWidget(
                  index: index,
                  onLongPressCallback: () {},
                  onLongPressEndCallback: (longPressEndDetails) {},
                  onSharePressedCallback: () {},
                  onBookmarkPressedCallback: () {},
                  onFollowPressed: () {},
                  onLikePressedCallback: () {},
                  onTapCallback: () {
                    if (homeController.isPaused!) {
                      homeController.playControllerAtIndexByFeed(index);
                    } else {
                      homeController.stopControllerAtIndexByFeed(index,
                          shouldPause: true);
                    }
                  },
                ),
              );
            });
  }
}
