import 'package:audioplayers/audioplayers.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

import '../tabs/home.dart';

class suijiyinyuetuijian extends StatefulWidget {
  const suijiyinyuetuijian({super.key});

  @override
  State<suijiyinyuetuijian> createState() => _suijiyinyuetuijianState();
}

class _suijiyinyuetuijianState extends State<suijiyinyuetuijian> {
  AudioPlayer audioPlayer = AudioPlayer();
  double _progress = 0.0; //歌曲起始进度
  var _ispauseMusic = false;

  @override
  void initState() {
    // TODO: implement initState
    _playMusic();
    super.initState();
  }

  Widget _setplayicon() {
    var key;
    if (_ispauseMusic == false) {
      key = Icon(
        Icons.play_circle_rounded,
        color: Colors.white54,
        size: 62,
      );
      _ispauseMusic = true;
    } else {
      key = Icon(
        Icons.pause,
        color: Colors.white54,
        size: 62,
      );
      _ispauseMusic = false;
    }
    return key;
  }

  void _playMusic() async {
    //播放音乐
    await audioPlayer.setSourceUrl(
        'https://m801.music.126.net/20230719225206/ef074ffeebac2ae0033956bb2df1ecd7/jdymusic/obj/wo3DlMOGwrbDjj7DisKw/28557975606/4994/db53/1a19/8dab8add6ecc582a753e2331d673cec5.mp3');
  }

  void _pauseMusic() async {
    //暂停音乐
    await audioPlayer.pause();
  }

  void _seekTo(double milliseconds) {
    //拖动音乐
    audioPlayer.seek(Duration(milliseconds: milliseconds.toInt()));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Stack(
            children: [
              Blur(
                  blur: 8,
                  blurColor: Colors.grey,
                  colorOpacity: 0.2,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Expanded(
                      flex: 1,
                      child: ClipRRect(
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder:
                              AssetImage('images/yingyuebofangzhanweitu.jpg'),
                          image: NetworkImage(shouye_meiriyitu),
                        ),
                      ),
                    ),
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Blur(
                        blur: 0.5,
                        blurColor: Colors.grey,
                        colorOpacity: 0.2,
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage(
                              matchTextDirection: true,
                              fit: BoxFit.cover,
                              placeholder: AssetImage(
                                  'images/yingyuebofangzhanweitu.jpg'),
                              image: NetworkImage(shouye_meiriyitu),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text("dasdasdasdasdasdsa"),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("开始时间"),
                        Expanded(
                          flex: 1,
                          child: Slider(
                              min: 0.0,
                              max: 100,
                              value: _progress,
                              onChanged: (e) {
                                setState(() {
                                  _progress = e;
                                  _seekTo(e);
                                });
                              }),
                        ),
                        Text("结束时间")
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                            onTap: () {
                              _playMusic();
                              setState(() {
                                _setplayicon();
                              });
                            },
                            child: _setplayicon()),
                        InkWell(
                          child: Icon(
                            Icons.offline_bolt,
                            color: Colors.white54,
                            size: 62,
                          ),
                        )
                      ],
                    )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
