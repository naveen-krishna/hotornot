import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class ChachedProfileNetworkImage extends StatelessWidget {
  const ChachedProfileNetworkImage({
    Key? key,
    required this.width,
    required this.height,
    required this.url,
  }) : super(key: key);

  final String url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return url.isEmpty
        ? CircleAvatar(
            radius: width / 2,
            backgroundColor: inputBgColorDark,
          )
        : CachedNetworkImage(
            key: ValueKey(url),
            memCacheHeight: 100,
            memCacheWidth: 100,
            maxHeightDiskCache: 100,
            maxWidthDiskCache: 100,
            imageBuilder: (context, imageProvider) => Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      colorFilter: url ==
                              "https://storage.googleapis.com/ps_videos/default_thumbnails/default_profile_pic.png"
                          ? const ColorFilter.mode(
                              inputBgColorDark,
                              BlendMode.color,
                            )
                          : null,
                    ),
                  ),
                ),
            placeholder: (context, url) => CircleAvatar(
                  radius: width / 2,
                  // backgroundImage: const AssetImage(defaultUserImage),
                  backgroundColor: inputBgColorDark,
                ),
            errorWidget: (context, url, error) {
              return CircleAvatar(
                radius: width / 2,
                // backgroundImage: const AssetImage(defaultUserImage),
                backgroundColor: inputBgColorDark,
              );
            },
            imageUrl: url);
  }
}
