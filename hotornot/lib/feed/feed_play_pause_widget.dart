import 'package:flutter/material.dart';

class FeedPlayPauseWidget extends StatefulWidget {
  final bool pause;
  const FeedPlayPauseWidget({super.key, required this.pause});

  @override
  State<FeedPlayPauseWidget> createState() => _FeedPlayPauseWidgetState();
}

class _FeedPlayPauseWidgetState extends State<FeedPlayPauseWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
        child: Icon(
          !widget.pause ? Icons.pause : Icons.play_arrow_rounded,
          color: Colors.white60,
          size: 40,
        ),
      ),
    );
  }
}
