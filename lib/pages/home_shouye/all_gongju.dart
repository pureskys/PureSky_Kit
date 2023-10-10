import 'dart:convert';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:puresky_kit/main.dart';
import 'package:puresky_kit/pages/home_shouye/lishishangdejintian.dart';
import 'package:puresky_kit/pages/home_shouye/suijiyinyuetuijian.dart';
import 'package:puresky_kit/pages/home_shouye/xingchendahai.dart';
import 'package:puresky_kit/pages/tools/vip_yingshi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class all_gongju extends StatefulWidget {
  const all_gongju({super.key});

  @override
  State<all_gongju> createState() => _all_gongjuState();
}

class _all_gongjuState extends State<all_gongju> {
  var _appbartile = "全部工具";
  late Future _run_chushihua; // 初始化函数转换
  Future getLocalJson(String jsonName) async {
    // 本地json读取方法
    var json =
        jsonDecode(await rootBundle.loadString("json/" + jsonName + ".json"));
    return json;
  }

// 初始化方法
  Future _chushihua() async {
    var a = await getLocalJson('gongnengjson');
    print("获取的全部功能json数据：$a");
    return a;
  }

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
      default: // 路由失败返回方法
        return className;
    }
  }

// 获取外部储存路径函数
  Future<String?> getExternalStoragePath() async {
    var directory = await getExternalStorageDirectory();
    var path = directory!.path;
    return path;
  }

  @override
  void initState() {
    // TODO: implement initState
    _run_chushihua = _chushihua();
    getExternalStoragePath();
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: Container(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _appbartile = "全部工具";
                  });
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
            child: Column(
              children: [
                Expanded(
                    flex: 1,
                    child: FutureBuilder(
                      future: _run_chushihua,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // 异步操作正在进行中，显示加载指示器
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          // 获取成功的处理方法
                          List<Widget> gongneng_widget = []; // 最终渲染的大类
                          List<Widget> gongneng_widget1 = []; // 渲染的小类
                          var json = snapshot.data; // 获取的json文件初始化数据
                          var Feature; //子json大类的json
                          var Tag; // 大类工具名
                          var name; // 单个工具名称的名字
                          var isCollect; // 是否收藏的关键变量
                          var method; // 工具名称的跳转函数名
                          for (var i in json) {
                            gongneng_widget1 = [];
                            Tag = i['Tag'];
                            Feature = i['Feature'];
                            for (var j in Feature) {
                              name = j['name'];
                              isCollect = j['isCollect'];
                              var method0 = j['method'];
                              var method = _getPageInstance(method0);
                              gongneng_widget1.add(gongju_zujuan(
                                  name: "$name", method: method)); // 添加小名字模块
                            }
                            gongneng_widget.add(// 大标签完成的list
                                ExpansionTile(title: Text("$Tag"), children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(18, 5, 18, 10),
                                child: GridView(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 15,
                                          crossAxisSpacing: 15,
                                          childAspectRatio: 2),
                                  children: gongneng_widget1,
                                ),
                              )
                            ]));
                          }
                          return ListView(
                            // 返回的ui组件
                            children: gongneng_widget,
                          );
                        } else {
                          // 意外情况返回的组件
                          return Container();
                        }
                      },
                    ))
              ],
            ),
          )),
    );
  }
}

// 每一个功能的初始化地点
class gongju_zujuan extends StatefulWidget {
  final name; //功能的名字
  final method; // 功能的跳转方法
  const gongju_zujuan({super.key, required this.name, required this.method});

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
                        final RenderBox overlay = Overlay.of(context)!
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
                                  child: Text("收藏"),
                                ),
                              ),
                              onTap: () async {
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                try {
                                  var _isKey =
                                      sharedPreferences.containsKey('shoucang');
                                  if (!_isKey) {
                                    // 如果'shoucang'键不存在，则创建一个新的收藏列表并保存
                                    var _scJson = [widget.name];
                                    var _scJsonToString = jsonEncode(_scJson);
                                    await sharedPreferences.setString(
                                        'shoucang', _scJsonToString);
                                    print('新建收藏缓存成功$_scJsonToString');
                                  } else {
                                    var _scJsonStr =
                                        sharedPreferences.getString('shoucang');
                                    var _scJson = jsonDecode(_scJsonStr!)
                                        as List<dynamic>;

                                    // 检查新的收藏项是否已经存在于列表中
                                    if (!_scJson.contains(widget.name)) {
                                      _scJson.add(widget.name);
                                      var _scJsonToString = jsonEncode(_scJson);
                                      await sharedPreferences.setString(
                                          'shoucang', _scJsonToString);
                                      print('收藏缓存为 $_scJson');
                                    } else {
                                      print('该项已经存在于收藏列表中');

                                    }
                                  }
                                } catch (e) {
                                  print('缓存创建出错，已清空缓存 $e');
                                  sharedPreferences.clear();
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
                                blur: 10,
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
                ))
          ],
        ),
      ),
    );
  }
}
