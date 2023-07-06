import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:puresky_kit/pages/tabs/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  var json_day; //缓存中的日期

  //history_today的判断是否请求网络
  void _iscunzai_history_today() async {
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
        debugPrint("缓存中的历史上的今天数据的data$history_today_json");
        json_month = history_today_json[0]['month'];
        json_day = history_today_json[0]['day'];
        if (json_month == month && json_day == day) {
          //如果缓存数据为今天则不请求网络直接渲染数据
        } else {
          _net_history_today();
        }
      } catch (e) {
        debugPrint("尝试获取缓存失败,使用_net_history_today方法设置缓存$e");
        _net_history_today();
      }
    } else {
      await _net_history_today();
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
        history_today_json =
            jsonDecode(history_today_json_toString.toString())['data'];
        debugPrint('网络获取的数据解析json$history_today_json');
        try {
          await sharedPreferences.setString('history_today_json_toString',
              history_today_json_toString.toString());
          debugPrint('设置历史上的今天缓存成功$history_today_json_toString');
        } catch (e) {
          debugPrint('设置历史上的今天缓存失败：$e');
        }
      }
    } catch (e) {
      debugPrint("历史上的今天请求失败$e");
    }
  }

  @override
  void initState() {
    datetime = DateTime.now(); //获取今日时间对象
    year = datetime.year; //获取年
    month = datetime.month; //解析今日月份
    day = datetime.day; //解析时间对象的日
    debugPrint("$year年$month月$day日");
    _iscunzai_history_today();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
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
          child: Text(
            "历史上的今天",
            style: TextStyle(fontSize: 18, color: Colors.black87),
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
        height: double.infinity,
        child: Column(
          children: [Expanded(
            flex: 1,
            child: ListView(
                children: [neirongkapian()],
            ),
          )],
        ),
      ),
    );
  }
}

class neirongkapian extends StatefulWidget {
  const neirongkapian({super.key});

  @override
  State<neirongkapian> createState() => _neirongkapianState();
}

class _neirongkapianState extends State<neirongkapian> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      margin: EdgeInsets.fromLTRB(18, 5, 18, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [BoxShadow(
              color:Colors.grey,//颜色
              offset: Offset(0,0),//位置
              blurRadius: 6,//阴影程度
              spreadRadius: 0//扩散程度
            )],
      ),
      child: Text('sdasd'),
    );
  }
}
