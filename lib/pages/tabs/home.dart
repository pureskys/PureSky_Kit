import 'dart:convert';

import 'package:blur/blur.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
SharedPreferences? sharedPreferences; //定义全局sharedPreferences

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
  @override
  //初始化生命周期
  void initState() {
    // TODO: implement initState
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
                                            image:
                                                AssetImage("images/tiandi.jpg"),
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
                                              decoration: TextDecoration.none),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(16, 10, 0, 0),
                                        child: Text(
                                          '工具总数:0',
                                          style: TextStyle(
                                              fontSize: 15.1,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white54,
                                              decoration: TextDecoration.none),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
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
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(15, 0, 0, 20),
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
                                  )),
                              Expanded(
                                  //右边的下方
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "images/danchefengjing.jpg"),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
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
                                        Navigator.of(mainContext).push(MaterialPageRoute(builder: (context)=>xingchendahai()));
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
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "images/pashan.webp"),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                  ))
                            ],
                          ),
                        )),
                    Expanded(
                        //右边容器
                        flex: 1,
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
                                            image:
                                                AssetImage("images/limao.webp"),
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
                                              decoration: TextDecoration.none),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(16, 10, 0, 0),
                                        child: Text(
                                          '0条珍藏',
                                          style: TextStyle(
                                              fontSize: 15.1,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white54,
                                              decoration: TextDecoration.none),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
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

  @override
  void initState() {
    // TODO: implement initState
    yiyan();
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
          child: Column(
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
          ),
        )
      ],
    );
  }
}
