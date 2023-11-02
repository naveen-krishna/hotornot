import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotornot/home/home_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'feed/feed_play_pause_widget.dart';
import 'feed/feed_video_details_widget.dart';
import 'feed/feed_video_interaction_elements_widget.dart';
import 'feed/feed_video_player_widget.dart';

class VideoPlayerPageWidget extends StatefulWidget {
  final int index;
  final VoidCallback onTapCallback;
  final VoidCallback onLongPressCallback;
  final VoidCallback onLikePressedCallback;
  final VoidCallback? onSharePressedCallback;
  final VoidCallback onBookmarkPressedCallback;
  final VoidCallback onFollowPressed;
  final Function(LongPressEndDetails) onLongPressEndCallback;

  const VideoPlayerPageWidget({
    Key? key,
    required this.index,
    required this.onTapCallback,
    required this.onLongPressCallback,
    required this.onLongPressEndCallback,
    required this.onLikePressedCallback,
    required this.onSharePressedCallback,
    required this.onBookmarkPressedCallback,
    required this.onFollowPressed,
  }) : super(key: key);

  @override
  State<VideoPlayerPageWidget> createState() => _VideoPlayerPageWidgetState();
}

class _VideoPlayerPageWidgetState extends State<VideoPlayerPageWidget> {
  late HomeController otherUserProfileFeedController;
  String? currentUserName;

  @override
  initState() {
    otherUserProfileFeedController = Get.find();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTapCallback,
      onLongPress: widget.onLongPressCallback,
      onLongPressEnd: widget.onLongPressEndCallback,
      onDoubleTap: () {
        // if (!otherUserProfileFeedController.videoList[widget.index].userLiked) {
        //   widget.onLikePressedCallback();
        // }
      },
      child: Stack(
        children: [
          SizedBox.expand(
            child: GetBuilder<HomeController>(
                id: "videoPlayerWidget",
                builder: (userFeedVideoPlayerController) {
                  return FeedVideoPlayerWidget(
                    videoController: userFeedVideoPlayerController
                        .videoControllers[widget.index],
                    isLoading: userFeedVideoPlayerController
                            .videoPlayerLoaders[widget.index] ??
                        false,
                  );
                }),
          ),
          SizedBox(
            child: Padding(
              padding: EdgeInsets.only(top: 60.h),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 38.h,
                  width: 97.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: const Color(0xFF000033).withOpacity(0.20),
                  ),
                  child: Center(
                    child: Text(
                      "Hot or Not",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: "kumbh-Sans-regular"),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: Get.height - 70.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GetBuilder<HomeController>(
                  id: "feedInteractionController",
                  builder: (controller) {
                    return FeedVideoInteractionElemetsWidget(
                      index: widget.index,
                      videoData: otherUserProfileFeedController
                          .videoList[widget.index],
                      isMuted: controller.muteVideo,
                      onPressedMute: () =>
                          controller.toggleMuteByFeed(widget.index),
                    );
                  },
                )
              ],
            ),
          ),
          GetBuilder<HomeController>(
              id: "pauseIcon",
              builder: (feedMuteController) {
                debugPrint("GetBuilder VideoPlayerPageWidget Mute Icon >>>>");
                if (feedMuteController.showPauseIcon) {
                  return FeedPlayPauseWidget(
                      pause: feedMuteController.isPaused!);
                } else {
                  return const SizedBox.shrink();
                }
              }),
          Positioned(
            left: 0,
            bottom: 70.h,
            right: 70.w,
            child: GetBuilder<HomeController>(
                id: "feedVideoDetailsWidget",
                builder: (feedVideoDetailsController) {
                  return FeedVideoDetailsWidget(
                    index: widget.index,
                    videoData:
                        feedVideoDetailsController.videoList[widget.index],
                    onPressedHashTag: (value) {},
                    onTitleLinkPress: (url) {},
                    onPressedMentionTag: (mentionString) {},
                  );
                }),
          ),
        ],
      ),
    );
  }
}
