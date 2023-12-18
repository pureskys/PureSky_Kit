import 'dart:convert';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:puresky_kit/pages/home_shouye/suijiyinyuetuijian.dart';
import 'package:puresky_kit/pages/home_shouye/xingchendahai.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../tools/bilibiligongju.dart';
import '../tools/douyinggongju.dart';
import '../tools/hanyuzidian.dart';
import '../tools/vip_yingshi.dart';
import 'lishishangdejintian.dart';

var _sc_json_all; //储存收藏的数据

class wode_shoucang extends StatefulWidget {
  const wode_shoucang({super.key});

  @override
  State<wode_shoucang> createState() => _wode_shoucangState();
}

class _wode_shoucangState extends State<wode_shoucang> {
  var _appbartile = "我的收藏";
  late Future _run_chushihua; // 初始化函数中转

  // 路由类创建函数（路由注册函数）
  Object _getPageInstance(String className) {
    switch (className) {
      case 'VIP视频解析':
        return vip_yingshi();
      case '音乐推荐':
        return suijiyinyuetuijian();
      case '历史上的今天':
        return lishishangdejintian();
      case '我的blog':
        return xingchendahai();
      case '抖音工具':
        return douyinggongju();
      case '哔哩哔哩工具':
        return bilibiligongju();
      case '汉语字典':
        return hanyuzidian();
      default: // 路由失败返回方法
        return className;
    }
  }

//  初始化函数
  Future _chushihua() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      var _is_cuzai = sharedPreferences.containsKey('shoucang');
      if (_is_cuzai == false) {
        return [];
      } else {
        var _scJsonStr = sharedPreferences.getString('shoucang');
        var _scJson = jsonDecode(_scJsonStr!) as List<dynamic>;
        print('收藏的数据json$_scJson');
        return _scJson;
      }
    } catch (e) {
      return [];
    }
  }

//删除组件
  void _remove_wiget(name) {
    setState(() {
      _sc_json_all.remove(name);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _run_chushihua = _chushihua();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Container(
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.lightBlueAccent,
            ),
          ),
        ),
        title: Container(
          child: Center(
            child: Text(
              "$_appbartile",
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 18, 0),
            child: Icon(
              Icons.brightness_high,
              color: Colors.lightBlueAccent,
            ),
          )
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: _run_chushihua,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return Center(
                  child: Text("暂无收藏"),
                );
              } else {
                _sc_json_all = snapshot.data;
                List<Widget> gongneng_widget1 = []; // 渲染的小类
                for (var i in _sc_json_all) {
                  var name = i;
                  var method0 = i;
                  var method = _getPageInstance(method0); // 注册路由
                  gongneng_widget1.add(gongju_zujuan(
                    name: "$name",
                    method: method,
                    fangfa: _remove_wiget,
                  )); // 添加小名字模块
                }
                return Container(
                  margin: EdgeInsets.fromLTRB(18, 10, 18, 10),
                  child: ListView(
                    children: [
                      GridView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 2),
                        children: gongneng_widget1,
                      )
                    ],
                  ),
                );
              }
            } else {
              return Center();
            }
          },
        ),
      ),
    );
  }
}

// 每一个功能的初始化地点
class gongju_zujuan extends StatefulWidget {
  final name; //功能的名字
  final method; // 功能的跳转方法
  final fangfa;

  const gongju_zujuan(
      {super.key, required this.name, required this.method, this.fangfa});

  @override
  State<gongju_zujuan> createState() => _gongju_zujuanState();
}

class _gongju_zujuanState extends State<gongju_zujuan> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: InkWell(
                    // 每个功能的方法定义
                    onTap: () {
                      Navigator.push(
                          mainContext,
                          MaterialPageRoute(
                              builder: (context) => widget.method));
                    },
                    onLongPress: () {
                      // 长按弹出按钮
                      final RenderBox overlay = Overlay.of(context)
                          .context
                          .findRenderObject() as RenderBox;
                      final Offset position =
                          overlay.globalToLocal(Offset.zero);
                      final RenderBox button =
                          context.findRenderObject() as RenderBox;
                      final Offset buttonPosition =
                          button.localToGlobal(Offset.zero);
                      final double dx = buttonPosition.dx +
                          button.size.width / 2 -
                          position.dx;
                      final double dy = buttonPosition.dy - position.dy;
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(dx, dy + 60, dx, 10),
                        items: [
                          PopupMenuItem(
                            child: Container(
                              child: Center(
                                child: Text("取消收藏"),
                              ),
                            ),
                            onTap: () async {
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              try {
                                _sc_json_all.remove(widget.name);
                                var a = jsonEncode(_sc_json_all);
                                print("取消收藏后的数据：$a");
                                sharedPreferences.setString("shoucang", a);
                                print('更改后的收藏设置成功');
                                widget.fangfa(widget.name);
                              } catch (e) {
                                print('缓存创建出错，已清空缓存 $e');
                              }
                            },
                          ),
                        ],
                      );
                    },
                    child: Center(
                      child: Stack(
                        children: [
                          Blur(
                              blur: 1,
                              blurColor: Colors.white,
                              colorOpacity: 0.2,
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                      Colors.greenAccent,
                                      Colors.lightBlueAccent
                                    ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight)),
                              )),
                          Container(
                            child: Align(
                              child: Text(
                                "${widget.name}",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    ));
  }
}
