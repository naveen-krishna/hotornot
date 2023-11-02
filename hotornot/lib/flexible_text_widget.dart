import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';

class FlexibleTextWidget extends StatefulWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final Color? backgroundColor;
  final bool? showFullText;
  final int textLengthToShow;
  final Function? onTapLink;
  final Function? onTapCallbackForMentions;
  final Function? onTapCallbackForHashtag;
  final WrapAlignment? wrapAlignment;
  final TextAlign? textAlignment;
  const FlexibleTextWidget({
    Key? key,
    required this.text,
    this.fontSize,
    this.showFullText,
    this.fontWeight,
    this.textColor = whiteColor,
    this.textLengthToShow = 180,
    this.onTapCallbackForHashtag,
    this.onTapCallbackForMentions,
    this.onTapLink,
    this.backgroundColor = transparentColor,
    this.wrapAlignment = WrapAlignment.start,
    this.textAlignment = TextAlign.start,
  }) : super(key: key);

  @override
  State<FlexibleTextWidget> createState() => _FlexibleTextWidgetState();
}

class _FlexibleTextWidgetState extends State<FlexibleTextWidget> {
  late bool showFullText;

  @override
  void initState() {
    showFullText = widget.showFullText ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.text.isEmpty
        ? const SizedBox.shrink()
        : Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(1.w),
            ),
            width: 300.w,
            child: Wrap(
              alignment: widget.wrapAlignment!,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: !showFullText
                            ? widget.text.length >= widget.textLengthToShow
                                ? widget.text
                                    .substring(0, widget.textLengthToShow)
                                : widget.text
                            : widget.text,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: "kumbh-Sans-regular"),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              showFullText = !showFullText;
                            });
                          },
                      ),
                      if (widget.text.length >= widget.textLengthToShow)
                        TextSpan(
                          text: !showFullText ? "......" : "",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: whiteColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                showFullText = !showFullText;
                              });
                            },
                        ),
                    ],
                  ),
                  textAlign: widget.textAlignment,
                ),
              ],
            ),
          );
  }
}
