import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClickableIcon extends StatelessWidget {
  final String iconPath;
  final VoidCallback? clickCallback;
  final EdgeInsetsGeometry? iconPadding;
  final bool? showIcon;
  final double height;
  final double width;
  final bool? isSvgAsset;
  final Color? svgAssetColor;
  final HitTestBehavior behaviour;
  const ClickableIcon({
    Key? key,
    required this.iconPath,
    required this.clickCallback,
    required this.width,
    required this.height,
    this.iconPadding = const EdgeInsets.all(10.0),
    this.showIcon = true,
    this.isSvgAsset = false,
    this.svgAssetColor,
    this.behaviour = HitTestBehavior.opaque,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !showIcon!
        ? const SizedBox.shrink()
        : Container(
            width: width + 4.w,
            height: height + 1.h,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    0.2,
                  ),
                  blurRadius: 45.0,
                )
              ],
            ),
            child: GestureDetector(
              behavior: behaviour,
              onTap: clickCallback,
              child: Padding(
                padding: iconPadding!,
                child: isSvgAsset!
                    ? SvgPicture.asset(
                        iconPath,
                        width: width,
                        height: height,
                        color: svgAssetColor,
                        fit: BoxFit.fitHeight,
                      )
                    : Image.asset(
                        iconPath,
                        width: width,
                        height: height,
                      ),
              ),
            ),
          );
  }
}
