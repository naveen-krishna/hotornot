import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hotornot/image_constants.dart';
import '../flexible_text_widget.dart';
import '../utilities.dart';
import '../video_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedVideoDetailsWidget extends StatefulWidget {
  final int index;
  final VideoModel videoData;
  final Function(String)? onTitleLinkPress;
  final Function(String) onPressedHashTag;
  final Function(String) onPressedMentionTag;
  final Orientation? deviceOrientation;
  final bool? hideCampaignTag;
  const FeedVideoDetailsWidget({
    Key? key,
    required this.index,
    required this.videoData,
    required this.onPressedHashTag,
    this.onTitleLinkPress,
    required this.onPressedMentionTag,
    this.deviceOrientation = Orientation.portrait,
    this.hideCampaignTag = false,
  }) : super(key: key);

  @override
  State<FeedVideoDetailsWidget> createState() => _FeedVideoDetailsWidgetState();
}

class _FeedVideoDetailsWidgetState extends State<FeedVideoDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(left: 20.w, bottom: 30.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  profilePicImage,
                  height: 40.h,
                  width: 40.h,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        utf8Decoding("Natasha009"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          SvgPicture.asset(
                            viewsIcon,
                            height: 15.h,
                            width: 15.w,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            utf8Decoding("2,500"),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
              ],
            ),
            SizedBox(height: 10.h),
            FlexibleTextWidget(
              text: utf8Decoding(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book"),
              onTapCallbackForHashtag: widget.onPressedHashTag,
              onTapCallbackForMentions: widget.onPressedMentionTag,
              onTapLink: widget.onTitleLinkPress,
              textLengthToShow: 40,
              showFullText: false,
            ),
          ],
        ),
      ),
    );
  }
}
