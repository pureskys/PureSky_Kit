import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tabs/home.dart';

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
  var app_id; //api接口的app_id
  var app_secret; //api接口的app_secret
  var _code = '等待中'; // 请求的状态信息
  var old_encodeBase64_url; // 旧的视频链接base64编码
  var respond; // 获取的网络返回数据

  //获取api的密匙
  Future getApiKey() async {
    var name = 'apikey';
    var apijson = await getLocalJson(name);
    app_id = apijson[0]['app_id'];
    app_secret = apijson[0]['app_secret'];
    print("api数据的app_id：$app_id和app_secret：$app_secret");
  }

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
    if (encodeBase64_url == old_encodeBase64_url) {
      var _old_json_decode = jsonDecode(respond.toString());
      var msg = _old_json_decode["msg"];
      if (msg != "数据返回成功！") {
        old_encodeBase64_url = encodeBase64_url;
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
          setState(() {
            _code = "解析接口可能失效，请联系开发者进行修复";
          });
          print('哔哩哔哩工具请求失败');
        }
      } else {
        return respond;
      }
    } else {
      old_encodeBase64_url = encodeBase64_url;
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
        setState(() {
          _code = "解析接口可能失效，请联系开发者进行修复";
        });
        print('哔哩哔哩工具请求失败');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getApiKey();
    super.initState();
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
                        height: 20,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: Text('$_code')),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 8),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50)),
                          onPressed: () async {
                            _txt_content = _textEditingController.text;
                            var url = await _zhengze_txt(_txt_content);
                            var encodeBase64_url = await encodeBase64(url[0]);
                            // 这里开始把base64编码的链接传给了网络访问函数
                            respond = await _net_bilibili(encodeBase64_url);
                            var respond1 = jsonDecode(respond.toString());
                            var msg = respond1['msg'];
                            if (msg == "数据返回成功！") {
                              setState(() {
                                _code = "无水印视频链接复制成功";
                              });
                              var data = respond1["data"];
                              var list = data["list"][0];
                              var url = list["url"];
                              Clipboard.setData(ClipboardData(text: url));
                              print('成功msg:$msg和url：$url');
                            } else {
                              setState(() {
                                _code = "无水印链接获取失败，请重试";
                              });
                              print('解析失败：$msg');
                            }
                          },
                          child:
                              Text(style: TextStyle(fontSize: 17), '获取无水印链接')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 8),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50)),
                          onPressed: () async {
                            _txt_content = _textEditingController.text;
                            var url = await _zhengze_txt(_txt_content);
                            var encodeBase64_url = await encodeBase64(url[0]);
                            // 这里开始把base64编码的链接传给了网络访问函数
                            respond = await _net_bilibili(encodeBase64_url);
                            var respond1 = jsonDecode(respond.toString());
                            var msg = respond1['msg'];
                            if (msg == "数据返回成功！") {
                              setState(() {
                                _code = "封面链接复制成功";
                              });
                              var data = respond1["data"];
                              var cover = data["cover"];
                              Clipboard.setData(ClipboardData(text: cover));
                              print('成功msg:$msg和cover：$cover');
                            } else {
                              setState(() {
                                _code = "封面获取失败，请重试";
                              });
                              print('解析失败：$msg');
                            }
                          },
                          child: Text(style: TextStyle(fontSize: 17), '获取封面')),
                    )
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
