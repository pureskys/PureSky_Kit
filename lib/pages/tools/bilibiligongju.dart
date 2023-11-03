import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class bilibiligongju extends StatefulWidget {
  const bilibiligongju({super.key});

  @override
  State<bilibiligongju> createState() => _bilibiligongjuState();
}

class _bilibiligongjuState extends State<bilibiligongju> {
  final TextEditingController _textEditingController =
      TextEditingController(); //创建的文本框接收器
  var _txt_content; // 文本的文本
  var _jiexi_url = 'https://www.mxnzp.com/api/bilibili/video?'; // 解析接口
  var app_id = 'hgfhzqkwtkwhanoe'; //api接口的app_id
  var app_secret = 'WXNIbTdEY2g5MGNqRDVEVkxjSU4xdz09'; //api接口的app_secret

//  链接正则提取
  Future _zhengze_txt(var fenxiang_douying) async {
    RegExp regExp = RegExp(
      r'(https?://[^\s/$.?#].[^\s]*)',
      caseSensitive: false,
      multiLine: false,
    );
    List<String?> urls = regExp
        .allMatches(fenxiang_douying)
        .map((match) => match.group(0))
        .toList();
    return urls;
  }

// base64加密
  Future<String> encodeBase64(String data) async {
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

//  解析抖音链接数据
  Future _net_bilibili(var encodeBase64_url) async {
    Dio dio = Dio();
    var url = _jiexi_url +
        "url=" +
        encodeBase64_url +
        "&app_id=" +
        app_id +
        "&app_secret=" +
        app_secret;
    print("访问的url$url");
    Response response = await dio.get(url);
    if (response.statusCode == 200) {
      return response;
    } else {
      print('哔哩哔哩工具请求失败');
    }
  }

  @override
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
              "哔哩哔哩工具",
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
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15, 50, 15, 30),
                decoration: BoxDecoration(
                  border: new Border.all(color: Colors.blue, width: 2),
                ),
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    labelText: "    链接：",
                    hintText: "    请粘贴哔哩哔哩链接",
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 8),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50)),
                          onPressed: () async {
                            _txt_content = _textEditingController.text;
                            var url = await _zhengze_txt(_txt_content);
                            var encodeBase64_url = await encodeBase64(url[0]);
                            var a = await _net_bilibili(encodeBase64_url);
                            print('返回的数据$a');
                          },
                          child:
                              Text(style: TextStyle(fontSize: 17), '获取无水印链接')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 8),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50)),
                          onPressed: () {},
                          child: Text(style: TextStyle(fontSize: 17), '获取封面')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50)),
                          onPressed: () {},
                          child:
                              Text(style: TextStyle(fontSize: 17), '获取动态封面')),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
