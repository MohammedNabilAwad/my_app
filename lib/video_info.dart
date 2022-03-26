import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'colors.dart' as color;

class VideoInfo extends StatefulWidget {
  const VideoInfo({Key? key}) : super(key: key);

  @override
  _VideoInfoState createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  List videoInfo = [];
  bool _playArea = false;
  bool _isPlaying = false;
  bool _disposed = false;
  int _isPlayingIndex = -1;
  VideoPlayerController? _controller;

  _initData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/videoinfo.json")
        .then((value) {
      setState(() {
        videoInfo = json.decode(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _disposed = true;
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: _playArea == false
            ? BoxDecoration(
                gradient: LinearGradient(colors: [
                color.AppColor.gradientFirst.withOpacity(0.9),
                color.AppColor.gradientSecond
              ], begin: FractionalOffset(0.0, 0.4), end: Alignment.topRight))
            : BoxDecoration(color: color.AppColor.gradientSecond),
        child: Column(
          children: [
            // ################################################################
            _playArea == false
                ? Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      // height: 250,
                      padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // ############
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: Icon(Icons.arrow_back_ios,
                                    size: 20,
                                    color:
                                        color.AppColor.secondPageTopIconColor),
                                onTap: () {
                                  Get.back();
                                },
                              ),
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: color.AppColor.secondPageTopIconColor,
                              )
                            ],
                          ),
                          // ############
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Legs Toning",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: color.AppColor.secondPageTitleColor),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "and Glutes Workout",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: color.AppColor.secondPageTitleColor),
                              ),
                            ],
                          ),
                          // ############
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                        colors: [
                                          color.AppColor
                                              .secondPageContainerGradient1stColor,
                                          color.AppColor
                                              .secondPageContainerGradient2ndColor
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(Icons.timer,
                                        size: 20,
                                        color:
                                            color.AppColor.secondPageIconColor),
                                    Text(
                                      "68 min",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: color
                                              .AppColor.secondPageIconColor),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 210,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                        colors: [
                                          color.AppColor
                                              .secondPageContainerGradient1stColor,
                                          color.AppColor
                                              .secondPageContainerGradient2ndColor
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(Icons.handyman_outlined,
                                        size: 20,
                                        color:
                                            color.AppColor.secondPageIconColor),
                                    Text(
                                      "Resistent band, kettebell",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: color
                                              .AppColor.secondPageIconColor),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          // #############
                        ],
                      ),
                    ))
                : Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      // height: 250,
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            color: Colors.black.withOpacity(0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20, bottom: 5),
                                  child: InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      size: 20,
                                      color:
                                          color.AppColor.secondPageTopIconColor,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 20, bottom: 5),
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 20,
                                    color:
                                        color.AppColor.secondPageTopIconColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _playView(context),
                          _controlView(context)
                        ],
                      ),
                    )),
            // ################################################################
            Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(70))),
                  child: Column(
                    children: [
                      // #########    //^\\
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Circuit 1 : Legs Toning",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: color.AppColor.circuitsColor),
                          ),
                          Row(
                            children: [
                              Icon(Icons.loop,
                                  size: 30, color: color.AppColor.loopColor),
                              SizedBox(width: 5), // <=======
                              Text(
                                "3 sets",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: color.AppColor.setsColor),
                              )
                            ],
                          )
                        ],
                      ),
                      // ###########
                      Expanded(
                          child: ListView.builder(
                              itemCount: videoInfo.length,
                              itemBuilder: (_, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      _onTapVideo(index);
                                      debugPrint(index.toString());
                                      setState(() {
                                        if (_playArea == false) {
                                          _playArea = true;
                                        }
                                      });
                                    },
                                    child: _buildCard(index));
                              }))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  var _onUpdateControllerTime;
  void _onControllerUpdate() async {
    if (_disposed) {
      return;
    }
    _onUpdateControllerTime = 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_onUpdateControllerTime > now) {
      return;
    } else {
      _onUpdateControllerTime = now + 500;
    }
    final controller = _controller;
    if (controller == null) {
      debugPrint("controller is null");
      return;
    }
    if (!controller.value.isInitialized) {
      debugPrint("controller can not be isInitialized");
      return;
    }
    final playing = controller.value.isPlaying;
    _isPlaying = playing;
  }

  _onTapVideo(int index) async {
    final controller =
        VideoPlayerController.network(videoInfo[index]["videoUrl"]);
    final old = _controller;
    _controller = controller;
    if (old != null) {
      old.removeListener(_onControllerUpdate);
      old.pause();
    }
    setState(() {});
    controller
      ..initialize().then((_) {
        old?.dispose();
        _isPlayingIndex = index;
        controller.addListener(_onControllerUpdate);
        controller.play();
        setState(() {});
      });
  }

  Widget _controlView(BuildContext context) {
    final noMeute = (_controller?.value?.volume ?? 0) > 0;
    return Container(
      height: 30,
      width: double.infinity,
      color: Colors.black.withOpacity(0.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              if (noMeute) {
                _controller?.setVolume(0);
              } else {
                _controller?.setVolume(1.0);
              }
              setState(() {});
            },
            // child: Padding(
            // padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Icon(
              noMeute ? Icons.volume_up : Icons.volume_off,
              color: Colors.white,
              size: 30,
            ),
          ),
          FlatButton(
              onPressed: () async {
                final index = _isPlayingIndex;
                if (index >= 0 && videoInfo.length >= 0) {
                  _onTapVideo(index);
                } else {
                  Get.snackbar("video", "No videos ahead !",
                      snackPosition: SnackPosition.BOTTOM,
                      icon: Icon(Icons.face, size: 30, color: Colors.white),
                      backgroundColor: color.AppColor.gradientSecond,
                      colorText: Colors.white);
                }
              },
              child: Icon(
                Icons.fast_rewind,
                size: 30,
                color: Colors.white,
              )),
          FlatButton(
              onPressed: () async {
                if (_isPlaying) {
                  setState(() {
                    _isPlaying = false;
                  });
                  _controller?.pause();
                } else {
                  setState(() {
                    _isPlaying = true;
                  });
                  _controller?.play();
                }
              },
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                size: 30,
                color: Colors.white,
              )),
          FlatButton(
              onPressed: () async {
                final index = _isPlayingIndex + 1;
                if (index <= videoInfo.length - 1) {
                  _onTapVideo(index);
                } else {
                  Get.snackbar("Video List",
                      "You have finished watching all the videos. Congrate !",
                      snackPosition: SnackPosition.BOTTOM,
                      icon: Icon(Icons.face, size: 30, color: Colors.white),
                      backgroundColor: color.AppColor.gradientSecond,
                      colorText: Colors.white);
                }
              },
              child: Icon(
                Icons.fast_forward,
                size: 30,
                color: Colors.white,
              )),
          Icon(
            Icons.fullscreen_exit,
            size: 30,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  Widget _playView(BuildContext context) {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: VideoPlayer(controller),
      );
    } else {
      return AspectRatio(
          aspectRatio: 16 / 9,
          child: Center(
              child: Text(
            "Preparing...",
            style: TextStyle(fontSize: 20, color: Colors.white60),
          )));
    }
  }

  _buildCard(int index) {
    return Container(
      height: 135,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: AssetImage(videoInfo[index]["thumbnail"]),
                        fit: BoxFit.cover)),
              ),
              // ####
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoInfo[index]["title"],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    videoInfo[index]["time"],
                    style: TextStyle(color: Colors.grey[500]),
                  )
                ],
              )
            ],
          ),
          // #########
          Row(
            children: [
              Container(
                width: 80,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color(0xFFeaeefc),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "15s rest",
                  style: TextStyle(
                    color: Color(0xFF839fed),
                  ),
                ),
              ),
              // #########
              Row(
                children: [
                  for (int i = 0;
                      i < 80;
                      i++) //  <==== خلي الخط دينمك ع حسب عرض الشاشة
                    i.isEven
                        ? Container(
                            width: 3,
                            height: 1,
                            color: Colors.white,
                          )
                        : Container(
                            width: 3,
                            height: 1,
                            decoration: BoxDecoration(
                                color: Color(0xFF839fed),
                                borderRadius: BorderRadius.circular(2)),
                          )
                ],
              ),
              // ###########
            ],
          )
        ],
      ),
    );
  }
}
