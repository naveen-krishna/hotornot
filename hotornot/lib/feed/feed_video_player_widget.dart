import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class FeedVideoPlayerWidget extends StatefulWidget {
  final BetterPlayerController? videoController;
  final bool isLoading;
  const FeedVideoPlayerWidget(
      {Key? key, required this.videoController, required this.isLoading})
      : super(key: key);

  @override
  State<FeedVideoPlayerWidget> createState() => _FeedVideoPlayerWidgetState();
}

class _FeedVideoPlayerWidgetState extends State<FeedVideoPlayerWidget>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return widget.videoController == null || widget.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Center(
            child: BetterPlayer(
            controller: widget.videoController!,
          ));
  }
}
