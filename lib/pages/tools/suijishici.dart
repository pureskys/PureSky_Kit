import 'package:blur/blur.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:pinyin/pinyin.dart';

class suijishici extends StatefulWidget {
  const suijishici({super.key});

  @override
  State<suijishici> createState() => _suijishiciState();
}

class _suijishiciState extends State<suijishici> {
  @override
  void initState() {
    // TODO: implement initState
    _dropdownValue = _DropdownMenuItem_json.first;
    super.initState();
  }

  List<String> _DropdownMenuItem_json = [
    '全部',
    '抒情',
    '四季',
    '山水',
    '天气',
    '人物',
    '人生',
    '生活',
    '节日',
    '动物',
    '植物',
    '食物',
    '古籍'
  ]; // 下拉菜单选项
  var _dropdownValue; // 下拉菜单选中的值

  var url = 'https://open.saintic.com/api/sentence/'; // 请求链接
  var _net_json; // 网络获取的数据
  var content = ''; // 诗词内容
  var author = ''; // 诗词作者
  var origin = ''; // 诗词题目
  var category = ''; // 诗歌的类型
  Future<void> _shuaxin() async {
    await _run_net(_dropdownValue);
    setState(() {}); // 刷新ui
  }

  // 网络请求方法
  Future _run_net(String key) async {
    var pinyin = await PinyinHelper.getPinyin(key); // 转换为拼音
    String pinyinWithoutSpace =
        pinyin.replaceAll(' ', '').replaceAll('quanbu', 'all'); // 去掉空格
    var url1 = url + pinyinWithoutSpace + '..json';
    print(url1);
    try {
      Dio dio = Dio();
      // 创建一个自定义的HttpClientAdapter
      dio.httpClientAdapter = IOHttpClientAdapter()
        ..onHttpClientCreate = (client) {
          client.badCertificateCallback = (cert, host, port) => true;
          return null;
        };
      Response response = await dio.get(url1);
      _net_json = response.data;
      print(_net_json);
      var _json_decode0 = _net_json['data'];
      content = _json_decode0['sentence'];
      author = _json_decode0['author'];
      origin = _json_decode0['name'];
      category = _json_decode0['theme'];
      print(_json_decode0);
      return true;
    } catch (error) {
      print('Error: $error');
      return true;
    }
  }

  //  文本绘制代码_作者
  Future _textRendering_author(String author) async {
    List<Widget> author_widget = []; // 保存作者的组件列表
    var _textRendering_author_length = author.length;
    for (var i = 0; i < _textRendering_author_length; i++) {
      var _one_text = author.substring(i, i + 1);
      author_widget.add(Text(
        _one_text,
        style: TextStyle(fontFamily: "Slidechunfeng", fontSize: 19),
      ));
    }
    return author_widget;
  }

//  文本绘制代码_诗词
  Future _textRendering_content(String content) async {
    List<Widget> content_widget_row = []; // 设置几列的组件列表
    String content_list1 = content
        .replaceAll('。', '，')
        .replaceAll('！', '，')
        .replaceAll('？', '，')
        .replaceAll('；', '，')
        .replaceAll('：', '，')
        .replaceAll('、', '，'); // 格式化文本标点符号
    var content_list = content_list1.split("，"); // 以逗号为分割符，将文本转化为数组
    for (var i in content_list) {
      List<Widget> content_widget_column = []; // 保存诗词的组件列表
      // 将数组文本拆分出来
      var content_list_length = i.length;
      for (var j = 0; j < content_list_length; j++) {
        var _one_text = i.substring(j, j + 1);
        content_widget_column.add(Text(
          _one_text,
          style: TextStyle(fontSize: 34, fontFamily: "Slidechunfeng"),
        ));
        print(_one_text);
      }
      content_widget_row.add(Container(
        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
        child: Column(
          children: content_widget_column,
        ),
      ));
    }
    List<Widget> content_widget_row_reversed =
        content_widget_row.reversed.toList(); // 将列表数据倒序
    return content_widget_row_reversed;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/gushibeijing.jpeg'),
                fit: BoxFit.fill)),
        child: Stack(
          children: [
            Blur(
                blur: 10,
                blurColor: Colors.grey,
                colorOpacity: 0.2,
                child: Container()),
            Column(
              children: [
                // 状态栏高度填充组件
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 12,
                ),
                // 选择类型组建
                Container(
                  height: 22,
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 0.1),
                          borderRadius: BorderRadius.all(Radius.circular(2))),
                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: DropdownButton(
                        dropdownColor: Colors.white10,
                        underline: Container(height: 0),
                        value: _dropdownValue,
                        icon: Visibility(
                            visible: false, child: Icon(Icons.arrow_downward)),
                        items: _DropdownMenuItem_json.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Center(
                                  child: Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                      decoration: TextDecoration.none),
                                ),
                              )));
                        }).toList(),
                        onChanged: (Object? value) {
                          if (mounted) {
                            setState(() {
                              _dropdownValue = value.toString();
                            });
                            print('选择的诗词类型$_dropdownValue');
                          }
                        },
                      ),
                    ),
                  ),
                ),
                // 卡片的组件
                Expanded(
                    flex: 1,
                    child: FutureBuilder(
                      future: _run_net(_dropdownValue),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          print('加载中');
                          // 异步操作正在进行中，显示加载指示器
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          print("数据出错");
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          print('可以加载数据${snapshot.data}');
                          return RefreshIndicator(
                              child: ListView(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height -
                                        150,
                                    width: MediaQuery.of(context).size.width,
                                    child: Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      margin:
                                          EdgeInsets.fromLTRB(40, 0, 40, 105),
                                      decoration: BoxDecoration(
                                        color: Color(0xB4CCBB79),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'images/gushibeijing.jpeg'),
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: FutureBuilder(
                                        future: _textRendering_content(content),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            print('加载中');
                                            // 异步操作正在进行中，显示加载指示器
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (snapshot.hasError) {
                                            print("数据出错");
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else if (snapshot.hasData) {
                                            print('可以加载数据${snapshot.data}');
                                            return Row(
                                              children: [
                                                Expanded(
                                                  flex: 0,
                                                  child: FutureBuilder(
                                                    future:
                                                        _textRendering_author(
                                                            author),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<dynamic>
                                                            snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        print('加载中');
                                                        // 异步操作正在进行中，显示加载指示器
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      } else if (snapshot
                                                          .hasError) {
                                                        print("数据出错");
                                                        return Text(
                                                            'Error: ${snapshot.error}');
                                                      } else if (snapshot
                                                          .hasData) {
                                                        print(
                                                            '可以加载数据${snapshot.data}');
                                                        return Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  15),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children:
                                                                  snapshot.data,
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        return Container();
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: FutureBuilder(
                                                    future:
                                                        _textRendering_content(
                                                            content),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<dynamic>
                                                            snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        print('加载中');
                                                        // 异步操作正在进行中，显示加载指示器
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      } else if (snapshot
                                                          .hasError) {
                                                        print("数据出错");
                                                        return Text(
                                                            'Error: ${snapshot.error}');
                                                      } else if (snapshot
                                                          .hasData) {
                                                        print(
                                                            '可以加载数据${snapshot.data}');
                                                        return Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  15),
                                                          child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children:
                                                                    snapshot
                                                                        .data,
                                                              )),
                                                        );
                                                      } else {
                                                        return Container();
                                                      }
                                                    },
                                                  ),
                                                )
                                              ],
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              onRefresh: _shuaxin);
                        } else {
                          return Container();
                        }
                      },
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
