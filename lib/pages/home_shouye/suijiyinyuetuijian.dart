import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  var music_time_key; // 保存音乐时长是否获取到的变量
  Duration? maxDuration; // 获取的网络歌曲时间
  late Future _netmusic; //中转函数

  var name; //歌曲的名字
  var _is_shuaxing_ing = false; //刷新的标志
  var auther; //歌曲的作者
  var picUrl; //歌曲的图片
  var mp3url; //歌曲的链接
  var _content; //歌曲的热评
  var comment_name; // 热评者的昵称
  var _zhanweitupian = 'images/mohuse.webp'; //占位图设置
  var _isfail = false;
  List yinyuehuancun = []; //创建临时音乐缓存字典
  var _huancun_xiaobiaojianshu = 2; //缓存下表减少数
  bool _shangyishou_key = false; //标注是否点击了上一首
  bool _bofangshunxu = true; // 播放的顺序按钮切换标识
  var _time_daojishi = 3; // 倒计时

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
      maxDuration = await audioPlayer.getDuration();
      _maxtime = maxDuration!.inMilliseconds.toDouble();
      music_time_key = true;
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
      music_time_key = false;
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
    setState(() {
      _is_shuaxing_ing = true;
    });
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
        await Future.delayed(Duration(milliseconds: 1800)); //等待1.8秒
        setState(() {
          _is_shuaxing_ing = false;
          var json = jsonDecode(_netjson.toString())['data'];
          name = json['name'];
          auther = json['auther'];
          picUrl = json['picUrl'];
          mp3url = json['mp3url'];
          _content = json['content'];
          comment_name = json['comment_name'];
          _huoquxinxi(mp3url);
        });
      } else {
        print("使用缓存操作");
        if (_shangyishou_key == false) {
          _huancun_xiaobiaojianshu = _huancun_xiaobiaojianshu - 1;
          var i = yinyuehuancun.length - _huancun_xiaobiaojianshu;
          setState(() {
            _is_shuaxing_ing = false;
            _isfail = false;
            _isfirstplay = true;
            _ispauseMusic = true;
            _musicjindu = 0.0;
            _musicjindu_xianshi = '0:00';
            _seekTo(0);
            _netjson = yinyuehuancun[i];
          });
        } else if (_shangyishou_key == true) {
          _huancun_xiaobiaojianshu = _huancun_xiaobiaojianshu - 2;
          _shangyishou_key = false;
          var i = yinyuehuancun.length - _huancun_xiaobiaojianshu;
          setState(() {
            _is_shuaxing_ing = false;
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
      // 原api链接 https://api.vvhan.com/api/reping
      Response response = await dio.get('https://tenapi.cn/v2/comment');
      if (response.statusCode == 200) {
        var decode_json = jsonDecode(response.toString());
        var code = decode_json['code']; // 状态信息
        var id = decode_json['data']['id']; // 歌曲id
        var name = decode_json['data']['songs']; // 歌曲名字
        var auther = decode_json['data']['sings']; // 演唱者名字
        var picUrl = decode_json['data']['cover']; // 歌曲封面
        var mp3url = decode_json['data']['url']; // 歌曲链接
        //var avatarUrl = decode_json['data']['avatarUrl']; // 评论者头像
        var comment_name = decode_json['data']['name']; // 评论者的昵称
        var content = decode_json['data']['comment']; // 热评内容
        var vvhan_json_type = {
          "success": code,
          "data": {
            'id': id,
            'name': name,
            'auther': auther,
            'picUrl': picUrl,
            'mp3url': mp3url,
            'comment_name': comment_name, // 这个没用过的
            'content': content
          }
        };
        var vvhan_json_type_encode = jsonEncode(vvhan_json_type);
        print('转换类型之后的对象$vvhan_json_type_encode');
        print('网络获取的对象$response');
        _netjson = vvhan_json_type_encode;
        yinyuehuancun.add(vvhan_json_type_encode);
        print("获取的网络数据$_netjson");
        print("获取的缓存数据$yinyuehuancun");
        setState(() {
          _is_shuaxing_ing = false;
        });
      }
    } catch (e) {
      debugPrint('获取网易云音乐数据失败$e');
      setState(() {
        _is_shuaxing_ing = false;
      });
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
    if (music_time_key == false) {
      // 判断音乐是否有效的
      music_time_key = true;
      setState(() {
        _isfail = true;
      });
      Timer.periodic(Duration(milliseconds: 1000), (timer) async {
        setState(() {
          _time_daojishi = _time_daojishi - 1;
        });
        if (_time_daojishi == 0) {
          setState(() {
            _isfail = false;
          });
          try {
            audioPlayer.dispose();
            audioPlayer = AudioPlayer();
            _isfail = false;
            _ispauseMusic = true;
            setState(() {
              _musicjindu_xianshi = "0:00";
              _musicjindu = 0.0;
              _isfirstplay = true;
            });
          } catch (e) {
            print("下一首异常：摧毁对象失败");
          }
          await _music_qiehuan();
          _anniucaozuo();
          _time_daojishi = 3;
          timer.cancel(); // 关闭计时器
        }
      });
    } else {
      await audioPlayer.play(UrlSource(_musicurl));
      // 获取音乐的总时长
      try {
        Duration? maxDuration = await audioPlayer.getDuration();
        _maxtime = maxDuration!.inMilliseconds.toDouble();
        print("音乐时常：$_maxtime");
        setState(() {
          var a = _maxtime / 1000;
          var d = a.toInt();
          var c = Duration(minutes: d).toString().substring(0, 4);
          _maxtime_xianshi = c;
        });
        //获取音乐进度
        await audioPlayer.onPositionChanged.listen((event) {
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
      } catch (e) {
        await Future.delayed(Duration(seconds: 3));
        try {
          audioPlayer.dispose();
          audioPlayer = AudioPlayer();
        } catch (e) {
          print("下一首异常：摧毁对象失败");
        }
        await _music_qiehuan();
      }
      //音乐播放完毕的操作
      audioPlayer.onPlayerComplete.listen((event) async {
        if (_bofangshunxu == true) {
          // 如果是单曲循环则执行这里
          setState(() {
            _isfail = false;
            _musicjindu = 0.0;
            _musicjindu_xianshi = "0:00";
          });
          await audioPlayer.play(UrlSource(_musicurl)); // 播放音乐
        } else if (_bofangshunxu == false) {
          // 随机播放执行这里
          await Future.delayed(Duration(seconds: 2));
          try {
            audioPlayer.dispose();
            audioPlayer = AudioPlayer();
            _isfail = false;
            _ispauseMusic = true;
            setState(() {
              _musicjindu_xianshi = "0:00";
              _musicjindu = 0.0;
              _isfirstplay = true;
            });
          } catch (e) {
            print("下一首异常：摧毁对象失败");
          }
          await _music_qiehuan();
          _anniucaozuo();
        }
      });
    }
  }

  void _pauseMusic() async {
    //暂停音乐
    await audioPlayer.pause();
    debugPrint("暂停播放音乐");
  }

  void _seekTo(double milliseconds) async {
    //拖动音乐
    var key = milliseconds / 1000;
    audioPlayer.seek(Duration(seconds: key.toInt()));
    await audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        _musicjindu = event.inMilliseconds.toDouble();
        var b = _musicjindu / 1000;
        var d = b.toInt();
        var c = Duration(minutes: d).toString().substring(0, 4);
        _musicjindu_xianshi = c;
      });
      debugPrint("进度$_musicjindu_xianshi");
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
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
                comment_name = json['comment_name'];
                _huoquxinxi(mp3url);
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Blur(
                        blur: 12,
                        blurColor: Colors.transparent,
                        colorOpacity: 0.2,
                        child: Container(
                          height: double.infinity,
                          child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: picUrl,
                              httpHeaders: {
                                'User-Agent':
                                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36 Edg/117.0.2045.55'
                              },
                              placeholder: (context, url) => Image.asset(
                                    _zhanweitupian,
                                    fit: BoxFit.cover,
                                  )),
                        )),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 1,
                              child: ListView(
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height/18,),
                                  Container(
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  20, 20, 20, 20),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      '$name',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white54,
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      "$auther",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.white60),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //大图片
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Blur(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    blur: 0.5,
                                                    blurColor: Colors.grey,
                                                    colorOpacity: 0.2,
                                                    child: Container(
                                                      height: 300,
                                                      width: 310,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child:
                                                            CachedNetworkImage(
                                                                matchTextDirection:
                                                                    true,
                                                                fit: BoxFit
                                                                    .cover,
                                                                imageUrl:
                                                                    picUrl,
                                                                httpHeaders: {
                                                                  'User-Agent':
                                                                      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36 Edg/117.0.2045.55'
                                                                },
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Image.asset(
                                                                      _zhanweitupian,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      matchTextDirection:
                                                                          true,
                                                                    )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                _is_shuaxing_ing
                                                    ? Container(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                            //评论
                                            Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    12, 10, 12, 0),
                                                child: Text(
                                                  "$_content",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white54,
                                                  ),
                                                )),
                                            Container(
                                              width: double.infinity,
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 18, 0),
                                              child: Stack(
                                                alignment:
                                                    Alignment.centerRight,
                                                children: [
                                                  Text(
                                                    '——$comment_name',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white54,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),

                                            //进度条
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 0, 10, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                      width: 35,
                                                      child: Text(
                                                        "$_musicjindu_xianshi",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white54),
                                                      )),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Slider(
                                                        activeColor:
                                                            Colors.blueGrey,
                                                        min: 0,
                                                        max: _maxtime + 900,
                                                        value: _musicjindu,
                                                        onChanged: (e) {
                                                          setState(() {
                                                            _musicjindu = e;
                                                            print(
                                                                "滑动值${e.toInt()}");
                                                            _seekTo(e);
                                                          });
                                                        }),
                                                  ),
                                                  Text(
                                                    "$_maxtime_xianshi",
                                                    style: TextStyle(
                                                        color: Colors.white54),
                                                  )
                                                ],
                                              ),
                                            ),
                                            //控制器的面板
                                            Container(
                                                //播放顺序控制（随机播放。单曲循环）
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 18, 0, 0),
                                                  height: 62,
                                                  width: 62,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      _bofangshunxu =
                                                          !_bofangshunxu;
                                                    },
                                                    icon: _bofangshunxu
                                                        ? Icon(
                                                            Icons.repeat_one,
                                                            size: 46,
                                                            color:
                                                                Colors.white54,
                                                          )
                                                        : Icon(
                                                            Icons.shuffle,
                                                            size: 42,
                                                            color:
                                                                Colors.white54,
                                                          ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 62,
                                                  width: 62,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        try {
                                                          audioPlayer.stop();
                                                          audioPlayer.dispose();
                                                          audioPlayer =
                                                              AudioPlayer();
                                                        } catch (e) {
                                                          print("上一首异常：摧毁对象失败");
                                                        }
                                                        _isfail = false;
                                                        _ispauseMusic = true;
                                                        _shangyishou(); //上一首
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .skip_previous_rounded,
                                                        size: 62,
                                                        color: Colors.white54,
                                                      )),
                                                ),
                                                Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 0, 20, 0),
                                                    child: SizedBox(
                                                      height: 62,
                                                      width: 62,
                                                      child: Container(
                                                          child: IconButton(
                                                              onPressed:
                                                                  _anniucaozuo,
                                                              icon:
                                                                  _ispauseMusic
                                                                      ? Icon(
                                                                          Icons
                                                                              .play_circle_rounded,
                                                                          size:
                                                                              62,
                                                                          color:
                                                                              Colors.white54,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .pause,
                                                                          size:
                                                                              62,
                                                                          color:
                                                                              Colors.white54,
                                                                        ))),
                                                    )),
                                                SizedBox(
                                                  height: 62,
                                                  width: 62,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        try {
                                                          audioPlayer.dispose();
                                                          audioPlayer =
                                                              AudioPlayer();
                                                          _isfail = false;
                                                          _ispauseMusic = true;
                                                          setState(() {
                                                            _musicjindu_xianshi =
                                                                "0:00";
                                                            _musicjindu = 0.0;
                                                            _isfirstplay = true;
                                                          });
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
                                                Container(
                                                  // 展开播放目录列表
                                                  margin: EdgeInsets.fromLTRB(
                                                      10, 17, 0, 0),
                                                  height: 62,
                                                  width: 62,
                                                  child: IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Icons.queue_music,
                                                      size: 46,
                                                      color: Colors.white54,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                            Container(
                                                //歌曲加载失败显示的页面
                                                margin: EdgeInsets.all(15),
                                                child: _isfail
                                                    ? Text(
                                                        "未找到歌曲信息:$_time_daojishi",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white54),
                                                      )
                                                    : Container())
                                          ],
                                        ),
                                      ))
                                ],
                              ))
                        ],
                      ),
                    )
                  ],
                );
              }
            },
          ),
          canPop: false,
          onPopInvokedWithResult: (bool didPop, dynamic) async {
            if (didPop) {
              return;
            } else {
              // 拦截返回操作（暂停音乐后再退出）
              print('音乐推荐返回操作');
              audioPlayer.dispose();
              Navigator.pop(context);
            }
          }),
    );
  }
}
