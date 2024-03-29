import 'dart:convert';

import 'package:blur/blur.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puresky_kit/pages/home_shouye/all_gongju.dart';
import 'package:puresky_kit/pages/home_shouye/lishishangdejintian.dart';
import 'package:puresky_kit/pages/home_shouye/suijiyinyuetuijian.dart';
import 'package:puresky_kit/pages/home_shouye/wode_shoucang.dart';
import 'package:puresky_kit/pages/tools/suijishici.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../home_shouye/xingchendahai.dart';

void main() => runApp(home_shouye());

var shouye_meiriyitu = 'https://api.likepoems.com/img/bing'; //首页随机图片api
var yiyan_url = "https://v1.hitokoto.cn/?encode=json";
var yiyan_json; //一言获取的new_json
var yiyan_json_hitokoto = ' '; //一言的文本
var yiyan_json_from_who = ' '; //一言的发布者
var yiyan_json_from = ' '; //一言的来源
var app_id; //api接口的app_id
var app_secret; //api接口的app_secret
var Token; // api的token
var _sc_length = 0;
late Future _run_chushihua; // 总工具数初始化函数中转
late Future _run_chushihua1; //收藏数初始化函数中转
//获取api的密匙
Future getApiKey() async {
  var name = 'apikey';
  var apijson = await getLocalJson(name);
  app_id = apijson[0]['app_id'];
  app_secret = apijson[0]['app_secret'];
  var apijson1 = await getLocalJson(name);
  Token = apijson1[1]['Token'];
  print("api数据的app_id：$app_id和app_secret：$app_secret和Token:$Token");
}

Future getLocalJson(String jsonName) async {
  // 本地json读取方法
  var json =
      jsonDecode(await rootBundle.loadString("json/" + jsonName + ".json"));
  return json;
}

//总工具数的初始化函数
Future _chushihua() async {
  // 初始化方法
  var a = await getLocalJson('gongnengjson');
  print("获取的全部功能json数据：$a");
  return a;
}

class home_shouye extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [shouye_home(), yiyan_page()],
        ),
      ),
    );
  }
}

class shouye_home extends StatefulWidget {
  const shouye_home({super.key});

  @override
  State<shouye_home> createState() => _shouye_homeState();
}

class _shouye_homeState extends State<shouye_home> {
  //收藏数初始化函数
  Future _chushihua1() async {
    try {
      // 初始化方法
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var a = sharedPreferences.getString('shoucang');
      var b = jsonDecode(a.toString());
      var c = b.length;
      setState(() {
        _sc_length = c;
      });
      return c;
    } catch (e) {
      print("还没有收藏的功能");
      return 0;
    }
  }

  @override
  //初始化生命周期
  void initState() {
    // TODO: implement initState
    getApiKey();
    _run_chushihua = _chushihua();
    _run_chushihua1 = _chushihua1();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
        child: Expanded(
      flex: 1,
      child: ListView(
        children: [
          Column(
            children: [
              Container(
                  //每日一图开始
                  height: 180,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(14, 5, 14, 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: FadeInImage(
                      matchTextDirection: true,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: AssetImage('images/shulin.webp'),
                      image: NetworkImage(shouye_meiriyitu),
                    ),
                  )),

              //第二次布局开始
              Container(
                margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
                height: 175,
                child: Row(
                  //第二次总体横向布局
                  children: [
                    Expanded(
                        //左边容器
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            //全部工具的点击跳转
                            Navigator.push(
                                    mainContext,
                                    MaterialPageRoute(
                                        builder: (context) => all_gongju()))
                                .then((value) => _chushihua1());
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 7, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                children: [
                                  Blur(
                                    blur: 10,
                                    blurColor: Colors.grey,
                                    colorOpacity: 0.2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "images/tiandi.jpg"),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          margin:
                                              EdgeInsets.fromLTRB(15, 18, 0, 5),
                                          child: Text(
                                            '全部工具',
                                            style: TextStyle(
                                                fontSize: 15.5,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white70,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          margin:
                                              EdgeInsets.fromLTRB(16, 10, 0, 0),
                                          child: FutureBuilder(
                                            future: _run_chushihua,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<dynamic>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else if (snapshot.hasData) {
                                                var json = snapshot.data;
                                                var changdu =
                                                    json[0]['Feature'].length;
                                                print("长度$changdu");
                                                return Text(
                                                  '工具总数:$changdu',
                                                  style: TextStyle(
                                                      fontSize: 15.1,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white54,
                                                      decoration:
                                                          TextDecoration.none),
                                                );
                                              } else {
                                                return Center();
                                              }
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                    Expanded(
                        //右边
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(7, 0, 0, 0),
                          child: Column(
                            children: [
                              Expanded(
                                  //右边的上方
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 7),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "images/shuzhi.webp"),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(mainContext).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    lishishangdejintian()));
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(15, 0, 0, 20),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '历史上的今天',
                                            style: TextStyle(
                                                fontSize: 15,
                                                decoration: TextDecoration.none,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  //右边的下方
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      //跳转到随机网易云音乐推荐
                                      Navigator.of(mainContext).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  suijiyinyuetuijian()));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "images/danchefengjing.jpg"),
                                              fit: BoxFit.cover),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                    ),
                                  ))
                            ],
                          ),
                        ))
                  ],
                ),
              ),
              //中间小圆点
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/taiyang.png"),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
              //第三次页面布局开始
              Container(
                margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
                height: 175,
                child: Row(
                  children: [
                    Expanded(
                        //左边
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 7, 0),
                          child: Column(
                            children: [
                              Expanded(
                                  //左边的上方
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 7),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "images/mohuse.webp"),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: InkWell(
                                      onTap: () {
                                        debugPrint('点击了星辰大海');
                                        Navigator.of(mainContext).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    xingchendahai()));
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(15, 0, 0, 20),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '星辰大海',
                                            style: TextStyle(
                                                fontSize: 15,
                                                decoration: TextDecoration.none,
                                                color: Colors.white70),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  //左边的下方
                                  flex: 1,
                                  child: InkWell(
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "images/pashan.webp"),
                                              fit: BoxFit.cover),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                    ),
                                    onTap: (){
                                      debugPrint('点击了随机诗词');
                                      Navigator.of(mainContext).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  suijishici()));
                                    },
                                  ))
                            ],
                          ),
                        )),
                    Expanded(
                        //右边容器
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                    mainContext,
                                    MaterialPageRoute(
                                        builder: (context) => wode_shoucang()))
                                .then((value) => _chushihua1());
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(7, 0, 0, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                children: [
                                  Blur(
                                    blur: 15,
                                    blurColor: Colors.grey,
                                    colorOpacity: 0.2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "images/limao.webp"),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          margin:
                                              EdgeInsets.fromLTRB(15, 18, 0, 5),
                                          child: Text(
                                            '我的收藏',
                                            style: TextStyle(
                                                fontSize: 15.5,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white70,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                16, 10, 0, 0),
                                            child: FutureBuilder(
                                              future: _run_chushihua1,
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<dynamic>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  return Text(
                                                    '$_sc_length条珍藏',
                                                    style: TextStyle(
                                                        fontSize: 15.1,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white54,
                                                        decoration:
                                                            TextDecoration
                                                                .none),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                    '0条珍藏',
                                                    style: TextStyle(
                                                        fontSize: 15.1,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white54,
                                                        decoration:
                                                            TextDecoration
                                                                .none),
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              },
                                            )),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

//一言布局
class yiyan_page extends StatefulWidget {
  const yiyan_page({super.key});

  @override
  State<yiyan_page> createState() => _yiyan_pageState();
}

class _yiyan_pageState extends State<yiyan_page> {
  Future<void> yiyan() async {
    //一言获取数据
    try {
      var yiyan_url = "https://v1.hitokoto.cn/?encode=json";
      Dio dio = Dio();
      Response response = await dio.get(yiyan_url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.toString());
        yiyan_json = jsonData;
        setState(() {
          yiyan_json_hitokoto = "『" + jsonData['hitokoto'] + "』";
          yiyan_json_from_who = "—— " + jsonData['from_who'];
          yiyan_json_from = "「" + jsonData['from'] + "」";
        });
      } else {
        print('请求失败，状态码：${response.statusCode}');
      }
    } catch (error) {
      print('发生错误：$error');
    }
  }

  late Future yiyan1;

  @override
  void initState() {
    // TODO: implement initState
    yiyan1 = yiyan();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        //   child: Divider(),
        // ),//一言上面的线

        //一言开始
        Container(
          child: InkWell(
            onTap: yiyan,
            child: FutureBuilder<void>(
              future: yiyan1,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
                      child: Text("$yiyan_json_hitokoto",
                          style: TextStyle(
                              fontSize: 13,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 8),
                        child: Text("$yiyan_json_from_who$yiyan_json_from",
                            style: TextStyle(
                                fontSize: 11,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
