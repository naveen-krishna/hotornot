import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hotornot/image_constants.dart';
import '../clickable_icon.dart';
import '../colors.dart';
import '../video_model.dart';

class FeedVideoInteractionElemetsWidget extends StatefulWidget {
  final int index;
  final VideoModel videoData;
  final bool? isMuted;
  final VoidCallback onPressedMute;
  const FeedVideoInteractionElemetsWidget({
    Key? key,
    required this.index,
    required this.videoData,
    this.isMuted = true,
    required this.onPressedMute,
  }) : super(key: key);

  @override
  State<FeedVideoInteractionElemetsWidget> createState() =>
      _FeedVideoInteractionElemetsWidgetState();
}

class _FeedVideoInteractionElemetsWidgetState
    extends State<FeedVideoInteractionElemetsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      padding: EdgeInsets.only(bottom: 30.h, top: 60.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.isMuted!
              ? ClickableIcon(
                  width: 35.w,
                  height: 30.h,
                  isSvgAsset: true,
                  iconPadding: const EdgeInsets.only(
                      top: 2, left: 2, right: 2, bottom: 0),
                  iconPath: unmutedIcon,
                  svgAssetColor: whiteColor,
                  clickCallback: widget.onPressedMute,
                )
              : ClickableIcon(
                  width: 35.w,
                  height: 30.h,
                  isSvgAsset: true,
                  iconPadding: const EdgeInsets.only(
                      top: 2, left: 2, right: 2, bottom: 0),
                  iconPath: mutedIcon,
                  svgAssetColor: whiteColor,
                  clickCallback: widget.onPressedMute,
                ),
          Column(
            children: [
              ClickableIcon(
                width: 30.w,
                height: 25.h,
                isSvgAsset: true,
                iconPadding:
                    const EdgeInsets.only(top: 2, left: 2, right: 2, bottom: 0),
                iconPath: likeIcon,
                svgAssetColor: whiteColor,
                clickCallback: () {},
              ),
              SizedBox(height: 25.h),
              ClickableIcon(
                width: 45.w,
                height: 40.h,
                iconPath: shareIcon,
                isSvgAsset: true,
                iconPadding: const EdgeInsets.only(top: 2, left: 2, right: 2),
                clickCallback: () {},
              ),
              SizedBox(height: 25.h),
              ClickableIcon(
                width: 45.w,
                height: 40.h,
                iconPath: hotIconImage,
                isSvgAsset: false,
                iconPadding: const EdgeInsets.only(top: 2, left: 2, right: 2),
                clickCallback: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
