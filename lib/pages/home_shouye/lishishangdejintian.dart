import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:puresky_kit/pages/tabs/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

var _appbartile = '历史上的今天';

class lishishangdejintian extends StatefulWidget {
  const lishishangdejintian({super.key});

  @override
  State<lishishangdejintian> createState() => _lishishangdejintianState();
}

class _lishishangdejintianState extends State<lishishangdejintian> {
  var datetime; //获取今日时间对象
  var year; //获取年
  var month; //解析今日月份
  var day; //解析时间对象的日
  var history_today_json; //存放缓存中的数据和直接网络获取的数据
  var json_month; //缓存中的日期
  var app_id; //api接口的app_id
  var app_secret; //api接口的app_secret
  var json_day; //缓存中的日期
  List<Widget> history_widget = [];

//获取api的密匙
  Future getApiKey() async {
    var name = 'apikey';
    var apijson = await getLocalJson(name);
    app_id = apijson[0]['app_id'];
    app_secret = apijson[0]['app_secret'];
    print("api数据的app_id：$app_id和app_secret：$app_secret");
  }

  //history_today的判断是否请求网络
  Future _iscunzai_history_today() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var _ishistory_today_json_key =
        await sharedPreferences.containsKey("history_today_json_toString");
    print('是否存在历史上的今天的缓存$_ishistory_today_json_key');
    if (_ishistory_today_json_key == true) {
      try {
        var history_today_json_String =
            await sharedPreferences.getString('history_today_json_toString');
        var history_today_json_String1 =
            jsonDecode(history_today_json_String.toString());
        history_today_json = history_today_json_String1['data'];
        json_month = history_today_json[0]['month'];
        json_day = history_today_json[0]['day'];
        history_today_json = history_today_json_String;
        debugPrint("缓存中的历史上的今天数据的data$history_today_json");
        if (json_month == month && json_day == day) {
          //如果缓存数据为今天则不请求网络直接渲染数据
          return history_today_json;
        } else {
          debugPrint('缓存日期不符合，已重新获取网络数据');
          return _net_history_today();
        }
      } catch (e) {
        debugPrint("尝试获取缓存失败,使用_net_history_today方法设置缓存$e");
        return _net_history_today();
      }
    } else {
      return await _net_history_today();
    }
  }

  //history_today的网络缓存
  Future<void> _net_history_today() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var history_today_url =
        "https://www.mxnzp.com/api/history/today?type=1&app_id=$app_id&app_secret=$app_secret";
    try {
      Dio dio = Dio();
      Response response = await dio.get(history_today_url);
      if (response.statusCode == 200) {
        var history_today_json_toString = response;
        history_today_json = history_today_json_toString;
        debugPrint('网络获取的数据解析json$history_today_json');
        try {
          await sharedPreferences.setString('history_today_json_toString',
              history_today_json_toString.toString());
          debugPrint('设置历史上的今天缓存成功$history_today_json_toString');
          return history_today_json;
        } catch (e) {
          debugPrint('设置历史上的今天缓存失败：$e');
        }
      }
    } catch (e) {
      debugPrint("历史上的今天请求失败$e");
    }
  }

//中转函数
  a() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var history_json =
        sharedPreferences.getString("history_today_json_toString");
    history_today_json = history_json;
    return history_today_json;
  }

  //定义appbar的title
  void _settile(String title) {
    setState(() {
      _appbartile = title;
    });
  }

  late Future history_json_success;

  @override
  void initState() {
    getApiKey(); // 获取密匙
    datetime = DateTime.now(); //获取今日时间对象
    year = datetime.year; //获取年
    month = datetime.month; //解析今日月份
    day = datetime.day; //解析时间对象的日
    debugPrint("$year年$month月$day日");
    history_json_success = _iscunzai_history_today();
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
                setState(() {
                  _appbartile = "历史上的今天";
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
          color: Colors.white,
          height: double.infinity,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: FutureBuilder(
                  future: history_json_success,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // 异步操作正在进行中，显示加载指示器
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      for (var i in jsonDecode(
                          history_today_json.toString())['data']) {
                        var year = i['year'];
                        var month = i['month'];
                        var day = i['day'];
                        var title = i['title'];
                        var details1 = i['details'];
                        var details = "       " +
                            details1.trim().replaceAll('　', ''); //展示在标签页的文本
                        var details3 =
                            details1.replaceAll('　', '0-='); //详情页面用来解析后展示的文本
                        var details4 = details3.replaceAll('\n', '');
                        var details2 =
                            "       " + details4.replaceAll("0-=", "\n       ");
                        history_widget.add(neirongkapian(
                          year: year,
                          month: month,
                          day: day,
                          title: title,
                          details: details,
                          details2: details2,
                          onpressed: _settile,
                        ));
                      }
                      return ListView(
                        children: history_widget,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }
}

//自定义历史上的今天展示框
class neirongkapian extends StatefulWidget {
  final year;
  final month;
  final day;
  final title; //标题
  final details; //传入的首页标签内容
  final details2; //传入的详情页内容
  final Function(String) onpressed;

  const neirongkapian({
    super.key,
    required this.year,
    required this.month,
    required this.day,
    required this.title,
    required this.details,
    required this.details2,
    required this.onpressed,
  });

  @override
  State<neirongkapian> createState() => _neirongkapianState();
}

PersistentBottomSheetController? persistentBottomSheetController;

class _neirongkapianState extends State<neirongkapian> {
  //底部弹窗函数
  void _isBottomSheetOpen() {
    showBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
        context: context,
        builder: (context) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (bool didPop, dynamic) async {
              if (didPop) {
                return;
              } else {
                widget.onpressed("历史上的今天");
                Navigator.pop(context);
              }
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                children: [
                  Expanded(
                      flex: 1,
                      child: ListView(
                        children: [
                          Text(
                            "${widget.details2}",
                            style: TextStyle(fontSize: 17, height: 1.6),
                          )
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _isBottomSheetOpen();
        widget.onpressed(widget.title);
      },
      child: Container(
        width: double.infinity,
        height: 92,
        margin: EdgeInsets.fromLTRB(18, 4, 18, 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey, //颜色
                offset: Offset(0, 0), //位置
                blurRadius: 4, //阴影程度
                spreadRadius: 0 //扩散程度
                )
          ],
        ),
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.year}",
                      style: TextStyle(fontSize: 19),
                    ),
                    Container(
                      height: 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.cyan,
                      ),
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Row(
                        children: [Expanded(flex: 1, child: Container())],
                      ),
                    ),
                    Text(
                      "${widget.month}月${widget.day}日",
                      style: TextStyle(fontSize: 17),
                    )
                  ],
                ))),
            Container(
              width: 2,
              child: Column(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.blue,
                      ))
                ],
              ),
            ),
            Expanded(
                flex: 7,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          flex: 0,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(45, 12, 30, 5),
                            child: Align(
                              child: Text(
                                '${widget.title}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 1,
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 7, 0),
                            child: Text(
                              '${widget.details}',
                              style: TextStyle(
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 2,
                            ),
                          ))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
