import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:blur/blur.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class suijiyinyuetuijian extends StatefulWidget {
  const suijiyinyuetuijian({super.key});

  @override
  State<suijiyinyuetuijian> createState() => _suijiyinyuetuijianState();
}

class _suijiyinyuetuijianState extends State<suijiyinyuetuijian> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool _ispauseMusic = true; //是否暂停播放标识
  bool _isfirstplay = true; //是否是第一次播放音乐标识
  var _maxtime = 1.0; //进度条最大长度
  var _musicjindu = 0.0; //进度条初始长度
  var _netjson; //页面构建所需的json
  var _maxtime_xianshi = "0:00"; //显示的总长度
  var _musicjindu_xianshi = "0:00"; //进度显示

  late Future _netmusic; //中转函数

  var name; //歌曲的名字
  var auther; //歌曲的作者
  var picUrl; //歌曲的图片
  var mp3url; //歌曲的链接
  var _content; //歌曲的热评
  var _zhanweitupian = 'images/mohuse.webp'; //占位图设置
  var _isfail = false;
  List yinyuehuancun = []; //创建临时音乐缓存字典
  var _huancun_xiaobiaojianshu = 2; //缓存下表减少数
  bool _shangyishou_key = false; //标注是否点击了上一首

  @override
  void initState() {
    // TODO: implement initState
    _netmusic = _net();
    super.initState();
  }

// 切换上一首歌曲
  Future<void> _shangyishou() async {
    // 获取临时缓存的音乐json数据
    var changdu = yinyuehuancun.length; //获取缓存长度
    if (changdu < 2) {
      print("缓存长度不够");
    } else {
      if (_shangyishou_key == false) {
        _shangyishou_key = true;
        _isfail = false;
        int i = changdu - _huancun_xiaobiaojianshu; //标注缓存倒数下标
        print('获取的缓存数据${yinyuehuancun[i]}');
        setState(() {
          _isfail = false;
          _isfirstplay = true;
          _ispauseMusic = true;
          _musicjindu = 0.0;
          _seekTo(0);
          _netjson = yinyuehuancun[i];
        });
        _huancun_xiaobiaojianshu = _huancun_xiaobiaojianshu + 1;
      } else if (_shangyishou_key == true) {
        _shangyishou_key = true;
        _isfail = false;
        int i = changdu - _huancun_xiaobiaojianshu; //标注缓存倒数下标
        print('获取的缓存数据${yinyuehuancun[i]}');
        setState(() {
          _isfail = false;
          _isfirstplay = true;
          _ispauseMusic = true;
          _musicjindu = 0.0;
          _seekTo(0);
          _netjson = yinyuehuancun[i];
        });
        _huancun_xiaobiaojianshu = _huancun_xiaobiaojianshu + 1;
      }
    }
  }

//获取歌曲信息
  Future<void> _huoquxinxi(_mp3url) async {
    try {
      await audioPlayer.setSourceUrl(_mp3url);
      Duration? maxDuration = await audioPlayer.getDuration();
      _maxtime = maxDuration!.inMilliseconds.toDouble();
      setState(() {
        var a = _maxtime / 1000;
        var d = a.toInt();
        var c = Duration(minutes: d).toString().substring(0, 4);
        _maxtime_xianshi = c;
      });
    } catch (e) {
        _isfirstplay = true;
        _ispauseMusic = true;
        _musicjindu = 0.0;
        _seekTo(0);
      print("获取歌曲长度失败");
    }
  }

  void _anniucaozuo() {
    //播放按钮的操作
    if (_ispauseMusic == false && _isfirstplay == false) {
      _pauseMusic(); //暂停播放
      setState(() {
        _ispauseMusic = !_ispauseMusic;
      });
    } else if (_ispauseMusic == true && _isfirstplay == false) {
      _resumeMusic(); //恢复播放
      setState(() {
        _ispauseMusic = !_ispauseMusic;
      });
    } else if (_isfirstplay == true) {
      _playMusic(mp3url); //开始播放

      _isfirstplay = false;
    }
  }

//歌歌曲切换操作
  Future<void> _music_qiehuan() async {
    try {
      var key = yinyuehuancun.length - 1;
      var key0 = yinyuehuancun.length - _huancun_xiaobiaojianshu + 1;
      var _id1 =
          jsonDecode(yinyuehuancun[key].toString())['data']['id']; // 获取缓存最后的id
      var _id2 = jsonDecode(yinyuehuancun[key0].toString())['data']['id'];
      print(
          "id1=$_id1加${jsonDecode(yinyuehuancun[key].toString())['data']},id2=$_id2加${jsonDecode(yinyuehuancun[key0].toString())['data']}");
      if (_id1 == _id2) {
        _huancun_xiaobiaojianshu = 2;
        await _net();
        Future.delayed(Duration(milliseconds: 1800)); //等待1.8秒
        setState(() {
          var json = jsonDecode(_netjson.toString())['data'];
          name = json['name'];
          auther = json['auther'];
          picUrl = json['picUrl'];
          mp3url = json['mp3url'];
          _content = json['content'];
          _huoquxinxi(mp3url);
        });
      } else {
        print("使用缓存操作");
        if (_shangyishou_key == false) {
          _huancun_xiaobiaojianshu = _huancun_xiaobiaojianshu - 1;
          var i = yinyuehuancun.length - _huancun_xiaobiaojianshu;
          setState(() {
            _isfail = false;
            _isfirstplay = true;
            _ispauseMusic = true;
            _musicjindu = 0.0;
            _seekTo(0);
            _netjson = yinyuehuancun[i];
          });
        } else if (_shangyishou_key == true) {
          _huancun_xiaobiaojianshu = _huancun_xiaobiaojianshu - 2;
          _shangyishou_key = false;
          var i = yinyuehuancun.length - _huancun_xiaobiaojianshu;
          setState(() {
            _isfail = false;
            _isfirstplay = true;
            _ispauseMusic = true;
            _musicjindu = 0.0;
            _seekTo(0);
            _netjson = yinyuehuancun[i];
          });
        }
      }
    } catch (e) {
      print("下一首歌异常处理");
      _huancun_xiaobiaojianshu = 2;
      setState(() {
        _isfail = false;
        _isfirstplay = true;
        _ispauseMusic = true;
        _musicjindu = 0.0;
        _seekTo(0);
      });
      await _net();
    }
  }

//获取网易云热门音乐json数据
  Future<void> _net() async {
    try {
      Dio dio = Dio();
      Response response = await dio.get('https://api.vvhan.com/api/reping');
      if (response.statusCode == 200) {
        _netjson = response;
        yinyuehuancun.add(response);
        print("获取的网络数据$_netjson");
        print("获取的缓存数据$yinyuehuancun");
      }
    } catch (e) {
      debugPrint('获取网易云音乐数据失败$e');
    }
  }

  void _resumeMusic() async {
    //恢复播放状态
    audioPlayer.resume();
    debugPrint("恢复播放音乐");
  }

  void _playMusic(_musicurl) async {
    //播放音乐
    debugPrint("开始播放音乐0");
    if (_musicurl == 'https://music.163.com/404') {
      setState(() {
        _isfail = true;
      });
    } else {
      await audioPlayer.play(UrlSource(_musicurl));
      //音乐播放完毕的操作
      await audioPlayer.onPlayerComplete.listen((event) async {
        setState(() {
          _isfirstplay = true;
          _ispauseMusic = true;
          _musicjindu = 0.0;
          _seekTo(0);
        });
      });
      // 获取音乐的总时长
      Duration? maxDuration = await audioPlayer.getDuration();
      _maxtime = maxDuration!.inMilliseconds.toDouble();
      setState(() {
        var a = _maxtime / 1000;
        var d = a.toInt();
        var c = Duration(minutes: d).toString().substring(0, 4);
        _maxtime_xianshi = c;
      });
      //获取音乐进度
      audioPlayer.onPositionChanged.listen((event) {
        setState(() {
          _musicjindu = event.inMilliseconds.toDouble();
          var b = _musicjindu / 1000;
          var d = b.toInt();
          var c = Duration(minutes: d).toString().substring(0, 4);
          _musicjindu_xianshi = c;
        });
        debugPrint("进度$_musicjindu_xianshi");
      });

      debugPrint("开始播放音乐$maxDuration");
      setState(() {
        _ispauseMusic = !_ispauseMusic;
      });
    }
  }

  void _pauseMusic() async {
    //暂停音乐
    await audioPlayer.pause();
    debugPrint("暂停播放音乐");
  }

  void _seekTo(double milliseconds) {
    //拖动音乐
    var key = milliseconds / 1000;
    audioPlayer.seek(Duration(seconds: key.toInt()));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          child: FutureBuilder(
            future: _netmusic,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // 异步操作正在进行中，显示加载指示器
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                // 异步操作出错，显示错误信息
                return Text('Error: ${snapshot.error}');
              } else {
                // 异步操作已完成，显示数据
                var json = jsonDecode(_netjson.toString())['data'];
                name = json['name'];
                auther = json['auther'];
                picUrl = json['picUrl'];
                mp3url = json['mp3url'];
                _content = json['content'];
                _huoquxinxi(mp3url);
                return Stack(
                  children: [
                    Blur(
                        blur: 12,
                        blurColor: Colors.transparent,
                        colorOpacity: 0.2,
                        child: Container(
                          height: double.infinity,
                          child: FadeInImage(
                            fit: BoxFit.cover,
                            placeholder: AssetImage(_zhanweitupian),
                            image: NetworkImage(picUrl),
                          ),
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  '$name',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "$auther",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white60),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //大图片
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Blur(
                                borderRadius: BorderRadius.circular(15),
                                blur: 0.5,
                                blurColor: Colors.grey,
                                colorOpacity: 0.2,
                                child: Container(
                                  height: 300,
                                  width: 310,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: FadeInImage(
                                      matchTextDirection: true,
                                      fit: BoxFit.cover,
                                      placeholder: AssetImage(_zhanweitupian),
                                      image: NetworkImage(picUrl),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        //评论
                        Container(
                            margin: EdgeInsets.fromLTRB(12, 10, 12, 0),
                            child: Text(
                              "$_content",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white54,
                              ),
                            )),

                        //进度条
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  width: 35,
                                  child: Text(
                                    "$_musicjindu_xianshi",
                                    style: TextStyle(color: Colors.white54),
                                  )),
                              Expanded(
                                flex: 1,
                                child: Slider(
                                    activeColor: Colors.blueGrey,
                                    min: 0,
                                    max: _maxtime + 900,
                                    value: _musicjindu,
                                    onChanged: (e) {
                                      setState(() {
                                        _musicjindu = e;
                                        print("滑动值${e.toInt()}");
                                        _seekTo(e);
                                      });
                                    }),
                              ),
                              Text(
                                "$_maxtime_xianshi",
                                style: TextStyle(color: Colors.white54),
                              )
                            ],
                          ),
                        ),
                        //控制器的面板
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 14, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 62,
                                  width: 62,
                                  child: IconButton(
                                      onPressed: () {
                                        try {
                                          audioPlayer.stop();
                                          audioPlayer.dispose();
                                          audioPlayer = AudioPlayer();
                                        } catch (e) {
                                          print("上一首异常：摧毁对象失败");
                                        }
                                        _isfail = false;
                                        _ispauseMusic = true;
                                        _shangyishou(); //上一首
                                      },
                                      icon: Icon(
                                        Icons.skip_previous_rounded,
                                        size: 62,
                                        color: Colors.white54,
                                      )),
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: SizedBox(
                                      height: 62,
                                      width: 62,
                                      child: Container(
                                          child: IconButton(
                                              onPressed: _anniucaozuo,
                                              icon: _ispauseMusic
                                                  ? Icon(
                                                      Icons.play_circle_rounded,
                                                      size: 62,
                                                      color: Colors.white54,
                                                    )
                                                  : Icon(
                                                      Icons.pause,
                                                      size: 62,
                                                      color: Colors.white54,
                                                    ))),
                                    )),
                                SizedBox(
                                  height: 62,
                                  width: 62,
                                  child: IconButton(
                                      onPressed: () {
                                        try {
                                          audioPlayer.stop();
                                          audioPlayer.dispose();
                                          audioPlayer = AudioPlayer();
                                          _isfail = false;
                                          _ispauseMusic = true;
                                        } catch (e) {
                                          print("下一首异常：摧毁对象失败");
                                        }
                                        _music_qiehuan();
                                      },
                                      icon: Icon(
                                        Icons.skip_next_rounded,
                                        size: 62,
                                        color: Colors.white54,
                                      )),
                                ),
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.all(15),
                            child: _isfail
                                ? Text(
                                    "未找到歌曲信息",
                                    style: TextStyle(color: Colors.white54),
                                  )
                                : Container())
                      ],
                    )
                  ],
                );
              }
            },
          ),
          onWillPop: () async {
            audioPlayer.stop();
            return true;
          }),
    );
  }
}
