import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Scaffold(body: PortraitPage()));
  }
}

class PortraitPage extends StatefulWidget {
  const PortraitPage({Key? key}) : super(key: key);

  @override
  _PortraitPageState createState() => _PortraitPageState();
}

class _PortraitPageState extends State<PortraitPage> {
  VideoPlayerController? controller;
  
  bool showPlayIcon = true;
  
  _changePlayIconVisibility() {
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    // controller = VideoPlayerController.network(
    //     "https://cdn-resource.ekwing.com/acpf/data/upload/expand/2017/08/29/59a53da773e00.mp4")
    //   ..setLooping(true)
    //   ..initialize().then((_) {
    //     controller!.play();
    //   });
    controller = VideoPlayerController.network(
        'http://tanzi27niu.cdsb.mobi/wps/wp-content/uploads/2017/05/2017-05-17_17-33-30.mp4')
      ..initialize().then((_) {
        // 确保在初始化视频后显示第一帧，直至在按下播放按钮。
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.cyan,
                  padding: EdgeInsets.all(10),
                  child: AspectRatio(
                    aspectRatio: controller!.value.aspectRatio,
                    child: VideoPlayer(controller!),
                  ),
                ),
                showPlayIcon ? IconButton(
                  icon: Icon(Icons.play_circle_fill_rounded),
                  iconSize: 60,
                  color: Colors.green,
                  onPressed: () {
                    controller!.value.isPlaying ? controller!.pause() : controller!.play();
                    showPlayIcon = false;
                    _changePlayIconVisibility();
                  },
                ) : Icon(Icons.pause_circle_filled_rounded,),
              ],
            ),
            MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              VideoFullPage(controller: controller!)));
                },
                child: Text("切换全屏"))
          ],
        ),
      ),
    );
  }
}

class VideoFullPage extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoFullPage({Key? key, required this.controller}) : super(key: key);

  @override
  _VideoFullPageState createState() => _VideoFullPageState();
}

class _VideoFullPageState extends State<VideoFullPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Center(
                  child: Hero(
                    tag: "player",
                    child: AspectRatio(
                      aspectRatio: widget.controller.value.aspectRatio,
                      child: VideoPlayer(widget.controller),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, right: 20),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    onPressed: () {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                      ]);
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: () async {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
          Navigator.pop(context);
          return false;
        });
  }
}
