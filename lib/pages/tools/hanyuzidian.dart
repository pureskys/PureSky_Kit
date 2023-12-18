import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tabs/home.dart';

class hanyuzidian extends StatefulWidget {
  const hanyuzidian({super.key});

  @override
  State<hanyuzidian> createState() => _hanyuzidianState();
}

class _hanyuzidianState extends State<hanyuzidian> {
  var api_url = 'https://www.mxnzp.com/api/convert/dictionary'; // 接口地址
  var content; // 请求的汉字（一次请求只能请求一个字符串）
  var app_id; // app_id
  var app_secret; // app_secret
  var pinyin = ''; // 拼音的接受变量
  var traditional= ''; // 繁体字的接受变量
  var radicals=''; // 偏旁接受变量
  var strokes=''; // 汉字笔画数接收变量
  var explanation=''; // 汉字释义接受变量
  var old_str;  // 旧的汉字
  var old_json;  // 老的数据
  final TextEditingController _textEditingController =
  TextEditingController(); //创建的文本框接收器

  //获取api的密匙
  Future getApiKey() async {
    var name = 'apikey';
    var apijson = await getLocalJson(name);
    app_id = apijson[0]['app_id'];
    app_secret = apijson[0]['app_secret'];
    print("api数据的app_id：$app_id和app_secret：$app_secret");
  }

  // 访问网络接口
  Future getJson_hanzi(url) async {
    if(old_str == _textEditingController.text){
      print('使用老的数据');
      return old_json;
    }else{
      print('访问新数据');
      Dio dio = new Dio();
      Response response = await dio.get(url);
      old_str = _textEditingController.text;
      old_json = response;
      return response;
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
              "汉语文字",
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
          margin: EdgeInsets.fromLTRB(15, 50, 15, 30),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: _textEditingController,
                        decoration: InputDecoration(
                            labelText: "请输入汉字：",
                            hintText: "仅支持一个汉字",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 1.5)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 2))),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"[\u4e00-\u9fa5]"))
                        ],
                        maxLength: 1,
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            backgroundColor: Colors.blueGrey,
                          ),
                          onPressed: () async{
                            var content = _textEditingController.text;
                            var run_url = api_url + '?content=' + content +
                                '&app_id=' + app_id + '&app_secret=' +
                                app_secret;
                            await getJson_hanzi(run_url);
                            var json_data = jsonDecode(old_json.toString())['data'];
                            print(json_data);
                            setState(() {
                              pinyin = json_data[0]['pinyin'];
                              traditional = json_data[0]['traditional'];
                              radicals = json_data[0]['radicals'];
                              strokes = json_data[0]['strokes'].toString();
                              explanation = json_data[0]['explanation'];
                            });

                          },
                          child: Text(
                            '提交',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // 下面的内容
              Container(
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(width: 0.5)),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Text(
                            '拼音：$pinyin',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Text(
                            '繁体：$traditional',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Text(
                            '偏旁部首：$radicals',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Text(
                            '汉字笔画数：$strokes',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey,
                      width: double.infinity,
                      height: 1,
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Text(
                            '汉字释义：',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
                      height: MediaQuery
                          .of(context)
                          .size
                          .height - 520,
                      child: ListView(
                        children: [Text('$explanation')],
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
