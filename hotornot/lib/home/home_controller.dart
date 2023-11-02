import 'dart:convert';
import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import '../base_exception_class.dart';
import '../video_model.dart';
import 'package:path/path.dart' as path;

class HomeController extends GetxController {
  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 1,
    keepPage: true,
  );
  var videoControllers = {};
  var videoPlayerLoaders = {};
  var videoPlayerTimers = {};
  int focussedIndex = 0;
  var muteVideo = false;
  List<VideoModel> videoList = [];
  List<VideoModel> initialVideoList = [];
  var firstFrameLoadedIndex = {};
  List<int> uninitilaizedControllers = [];
  late SharedPreferences prefs;
  var showPauseIcon = false;
  var showReportOptionsInMenu = false;
  bool fetchingShareLink = false;
  bool showDeleteMoreOptions = false;
  bool? isPaused = false;

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    muteVideo = prefs.getBool("mute") ?? false;
    (jsonDecode(await rootBundle
            .loadString("assets/mock_data/home_videos.json"))["videos"] as List)
        .forEach((element) {
      initialVideoList.add(VideoModel(element));
    });
    videoList.addAll(initialVideoList);
    update(["mainHome"]);
    initializeControllerAtIndexByFeed(0).then((value) {
      playControllerAtIndexByFeed(0);
      initializeControllerAtIndexByFeed(focussedIndex + 1);
    });
    Wakelock.enable();
    super.onInit();
  }

  void toggleMuteByFeed(int index) {
    baseMethodExceptions(() async {
      bool? mute = prefs.getBool("mute") ?? false;
      if (mute) {
        await prefs.setBool("mute", false);
      } else {
        await prefs.setBool("mute", true);
      }
      muteVideo = !mute;
      (videoControllers[index] as BetterPlayerController)
          .setVolume(muteVideo ? 0 : 1);
      if (index > 0) {
        (videoControllers[index - 1] as BetterPlayerController)
            .setVolume(muteVideo ? 0 : 1);
      }
      if (index + 1 < videoList.length) {
        (videoControllers[index + 1] as BetterPlayerController)
            .setVolume(muteVideo ? 0 : 1);
      }
      update(["feedInteractionController"]);
    });
  }

  onPageChangedByFeed(int index) {
    if (index > focussedIndex) {
      playNextByFeed(index);
    } else {
      playPreviousByFeed(index);
    }
    if (index == videoList.length - 2) {
      addVideos();
    }
    isPaused = false;
    focussedIndex = index;
  }

  void playNextByFeed(int index) {
    // debugPrint('play next index $index from feed');

    /// Stop [index - 1] controller
    stopControllerAtIndexByFeed(index - 1);

    /// Dispose [index - 2] controller
    disposeControllerAtIndexByFeed(index - 2);

    /// Play current video (already initialized)
    playControllerAtIndexByFeed(index);

    /// Initialize [index + 1] controller
    initializeControllerAtIndexByFeed(index + 1);
  }

  void playPreviousByFeed(int index) {
    // debugPrint('play prev index $index');

    /// Stop [index + 1] controller
    stopControllerAtIndexByFeed(index + 1);

    /// Dispose [index + 2] controller
    disposeControllerAtIndexByFeed(index + 2);

    /// Play current video (already initialized)
    playControllerAtIndexByFeed(index);

    /// Initialize [index - 1] controller
    initializeControllerAtIndexByFeed(index - 1);
  }

  void stopControllerAtIndexByFeed(int index, {bool shouldPause = false}) {
    // debugPrint('stop controller  at index $index');
    if (videoList.length > index && index >= 0) {
      /// Get controller at [index]
      final BetterPlayerController? _controller = videoControllers[index];

      /// Pause
      _controller?.pause();
      isPaused = true;
      showPauseIcon = true;
      update(["pauseIcon"]);
      Future.delayed(const Duration(milliseconds: 1000), () {
        showPauseIcon = false;
        update(["pauseIcon"]);
      });
      if (!shouldPause && (_controller?.isVideoInitialized() ?? false)) {
        /// Reset position to beginning
        _controller?.seekTo(const Duration());
        //update prev video play time
      }
    }
  }

  Future initializeControllerAtIndexByFeed(int index) async {
    // debugPrint('initialize controller at $index');
    if (videoList.length > index && index >= 0) {
      // debugPrint(
      //     'video url at index => $index =>>>>> ${videoList[index].url}');
      final BetterPlayerController _controller = BetterPlayerController(
        const BetterPlayerConfiguration(
          autoPlay: false,
          autoDetectFullscreenAspectRatio: true,
          looping: true,
          handleLifecycle: true,
          autoDispose: false,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            showControls: false,
            enableFullscreen: true,
            fullscreenEnableIcon: Icons.fullscreen,
            fullscreenDisableIcon: Icons.fullscreen_exit,
            enableMute: false,
            enableProgressText: false,
            enableProgressBar: false,
            enableProgressBarDrag: false,
            enablePlayPause: false,
            enableSkips: false,
            enableAudioTracks: false,
            enableRetry: false,
            enableSubtitles: false,
            showControlsOnInitialize: true,
          ),
        ),
      );
      // print(_controller.getAspectRatio());

      // add loader for index
      updateVideoPlayerLoaderAtIndexByFeed(index, true);

      //  add to videoControllers
      updateVideoControllerAtIndexByFeed(index, _controller);
      final extension = path.extension(videoList[index].videoUrl);
      await _controller
          .setupDataSource(BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        videoList[index].videoUrl,
        videoExtension: extension == ".m3u8" ? "m3u8" : extension.substring(1),
        videoFormat: extension == ".m3u8" ? BetterPlayerVideoFormat.hls : null,
        liveStream: extension == ".m3u8" ? true : null,
        bufferingConfiguration: const BetterPlayerBufferingConfiguration(
          minBufferMs: 3000,
          bufferForPlaybackMs: 250,
          bufferForPlaybackAfterRebufferMs: 500,
          maxBufferMs: 3000,
        ),
        cacheConfiguration: extension != ".m3u8"
            ? null
            : BetterPlayerCacheConfiguration(
                useCache: true,
                key: videoList[index].videoUrl,
              ),
        useBufferForIos: 1,
      ))
          .onError((error, stackTrace) {
        uninitilaizedControllers.add(index);
      });
      if (_controller.videoPlayerController!.value.aspectRatio.isNaN) {
        _controller.setOverriddenAspectRatio(Get.width / Get.height);
      } else {
        _controller.setOverriddenAspectRatio(
            _controller.videoPlayerController!.value.aspectRatio);
      }
      _controller.setLooping(true);
      _controller.setVolume((prefs.getBool("mute") ?? false) ? 0 : 1);
      updateVideoPlayerLoaderAtIndexByFeed(index, false);
      firstFrameLoadedIndex[index] = false;
    }
  }

  void playControllerAtIndexByFeed(int index) {
    // debugPrint('play controller $index');
    baseMethodExceptionsForSync(() {
      isPaused = false;
      showPauseIcon = true;
      update(["pauseIcon"]);
      Future.delayed(const Duration(milliseconds: 1000), () {
        showPauseIcon = false;
        update(["pauseIcon"]);
      });
      update(["videoPlayerWidget"]);
      if (videoList.length > index && index >= 0) {
        /// Get controller at [index]
        final BetterPlayerController? _controller = videoControllers[index];
        final BetterPlayerController? _controllerAfter =
            videoControllers[index + 1];
        final BetterPlayerController? _controllerBefore =
            videoControllers[index - 1];
        double positionVal = 0.0;
        listener(BetterPlayerEvent event) {
          if (event.betterPlayerEventType ==
              BetterPlayerEventType.stalledCheck) {
            if (Platform.isAndroid) {
              // for android re intialize player
              _controller?.retryDataSource().then((val) {
                Future.delayed(const Duration(milliseconds: 200), () {
                  if (positionVal > 1.0) {
                    if (index != focussedIndex) {
                      _controller.pause();
                    }
                  }
                });
              });
            } else {
              Future.delayed(const Duration(milliseconds: 200), () {
                if (index != focussedIndex) {
                  _controller?.pause();
                }
              });
            }
          } else if (event.betterPlayerEventType ==
              BetterPlayerEventType.bufferingUpdate) {
            Future.delayed(const Duration(milliseconds: 200), () {
              if (index != focussedIndex) {
                _controller?.pause();
              }
            });
          }
        }

        _controller?.addEventsListener(listener);

        /// Play controller
        if (_controllerAfter != null) {
          _controllerAfter.onPlayerVisibilityChanged(0);
        }
        if (_controllerBefore != null) {
          _controllerBefore.onPlayerVisibilityChanged(0);
        }
        _controller?.onPlayerVisibilityChanged(100);
        _controller?.play();
        videoPlayerTimers[index] = 0;
      }
    });
  }

  void disposeControllerAtIndexByFeed(int index) {
    // debugPrint('dispose controller at index $index');
    if (videoList.length > index && index >= 0) {
      /// Get controller at [index]
      final BetterPlayerController? _controller = videoControllers[index];

      /// Dispose controller
      _controller?.dispose(forceDispose: true);
      _controller?.removeEventsListener((p0) => {});

      if (videoControllers.containsValue(_controller)) {
        videoControllers.remove(index);
        videoPlayerLoaders.remove(index);
      }
    }
  }

  void updateVideoPlayerLoaderAtIndexByFeed(int index, bool val) {
    // debugPrint('update video loader at index $index');
    baseMethodExceptionsForSync(() {
      videoPlayerLoaders[index] = val;
      update(["videoPlayerWidget"]);
    });
  }

  void updateVideoControllerAtIndexByFeed(
      int index, BetterPlayerController controller) {
    // debugPrint('update video controller at index $index');
    baseMethodExceptionsForSync(() {
      videoControllers[index] = controller;
    });
  }

  void disposeAllController() {
    // debugPrint('dispose all controllers');
    pageController.dispose();
    var controllers = videoControllers.values.toList();
    for (var controller in controllers) {
      final BetterPlayerController? _controller = controller;

      /// Dispose controller
      _controller?.dispose(forceDispose: true);
    }
    videoControllers = {};
    videoPlayerLoaders = {};
    update();
    Wakelock.disable();
  }

  void initPageControllerAndVideoControllersWithInitIndex() {
    initializeControllerAtIndexByFeed(focussedIndex).then((value) {
      update();
      playControllerAtIndexByFeed(focussedIndex);
      if (videoList.length >= 2) {
        if (focussedIndex == 0) {
          initializeControllerAtIndexByFeed(focussedIndex + 1);
        } else if (focussedIndex > 0 && focussedIndex < videoList.length) {
          initializeControllerAtIndexByFeed(focussedIndex + 1);
          initializeControllerAtIndexByFeed(focussedIndex - 1);
        }
      }
    });
    pageController = PageController(initialPage: focussedIndex, keepPage: true);
    Wakelock.enable();
  }

  addVideos() {
    videoList.addAll(initialVideoList);
    update(["mainHome"]);
  }
}
