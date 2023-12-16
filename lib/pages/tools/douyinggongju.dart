import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class douyinggongju extends StatefulWidget {
  const douyinggongju({super.key});

  @override
  State<douyinggongju> createState() => _douyinggongjuState();
}

class _douyinggongjuState extends State<douyinggongju> {
  final TextEditingController _textEditingController =
      TextEditingController(); //创建的文本框接收器
  var _txt_content; // 文本的文本
  var _jiexi_url = 'https://tenapi.cn/v2/video'; // 解析接口
  var net_json; // 获取的json数据里面的data
  var _code = '等待中';
  var old_url_content;

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

//  解析抖音链接数据
  Future _net_douying(var old_url) async {
    if (old_url[0] == old_url_content) {
      print('数据没变，使用缓存数据');
      return net_json;
    } else {
      print('获取网络数据');
      Dio dio = Dio();
      var url = _jiexi_url + '?url=' + old_url[0];
      print("等待访问的链接$url");
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        old_url_content = old_url[0];
        return response;
      } else {
        print('抖音工具请求失败');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
              "抖音工具",
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
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                      labelText: "    链接：",
                      hintText: "    请粘贴抖音链接",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueGrey, width: 1.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2))),
                ),
              ),
              Text('$_code'),
              Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 8),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              backgroundColor: Colors.blue),
                          onPressed: () async {
                            _txt_content = _textEditingController.text;
                            var old_url = await _zhengze_txt(_txt_content);
                            print(old_url);
                            net_json = await _net_douying(old_url);
                            var json_str =
                                jsonDecode(net_json.toString()); // 将json数据转化为dart实列
                            var msg = json_str['code'];
                            if (msg == 200) {
                              setState(() {
                                _code = "无水印视频链接复制成功";
                              });
                              var json_data = json_str['data'];
                              var url = json_data['url'];
                              Clipboard.setData(ClipboardData(text: url));
                              print('成功msg:$msg和url：$url');
                            } else {
                              setState(() {
                                _code = "无水印链接获取失败，请重试";
                              });
                              print('解析失败：$msg');
                            }
                          },
                          child: Text(
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              '获取无水印链接')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 8),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              backgroundColor: Colors.blue),
                          onPressed: () async{
                            _txt_content = _textEditingController.text;
                            var old_url = await _zhengze_txt(_txt_content);
                            print(old_url);
                            net_json = await _net_douying(old_url);
                            var json_str =
                            jsonDecode(net_json.toString()); // 将json数据转化为dart实列
                            var msg = json_str['code'];
                            if (msg == 200) {
                              setState(() {
                                _code = "封面链接复制成功";
                              });
                              var json_data = json_str['data'];
                              var cover = json_data['cover'];
                              Clipboard.setData(ClipboardData(text: cover));
                              print('成功msg:$msg和url：$cover');
                            } else {
                              setState(() {
                                _code = "封面获取失败，请重试";
                              });
                              print('解析失败：$msg');
                            }
                          },
                          child: Text(
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              '获取封面')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              backgroundColor: Colors.blue),
                          onPressed: () async{
                            _txt_content = _textEditingController.text;
                            var old_url = await _zhengze_txt(_txt_content);
                            print(old_url);
                            net_json = await _net_douying(old_url);
                            var json_str =
                            jsonDecode(net_json.toString()); // 将json数据转化为dart实列
                            var msg = json_str['code'];
                            if (msg == 200) {
                              setState(() {
                                _code = "作者头像链接复制成功";
                              });
                              var json_data = json_str['data'];
                              var avatar = json_data['avatar'];
                              Clipboard.setData(ClipboardData(text: avatar));
                              print('成功msg:$msg和url：$avatar');
                            } else {
                              setState(() {
                                _code = "作者头像链接获取失败，请重试";
                              });
                              print('解析失败：$msg');
                            }
                          },
                          child: Text(
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              '获取作者头像')),
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
