import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './pages/tabs/home.dart';
import './pages/tabs/wode.dart';

void main() {
  runApp(MyApp());
}
var mainContext; //创建main_tbs的全局context
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PureSky_Kit',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0.0,
            titleTextStyle: TextStyle(
                color: Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ), //定义app主题
      debugShowCheckedModeBanner: false,
      home: tabs(),
    );
  }
}

class tabs extends StatefulWidget {
  const tabs({super.key});

  @override
  State<tabs> createState() => _tabsState();
}

var _pageController = PageController(); //实例化页面控制器
var _tab_index = 0; //定义tabs起始标签序列
var list_tabs = [home_shouye(), wode()]; //定义的tabs列表

class _tabsState extends State<tabs> {
  @override
  Widget build(BuildContext context) {
    mainContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('PureSky_Kit'),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, //设置状态栏透明
            statusBarIconBrightness: Brightness.dark //设置状态栏字体颜色为黑色
            ),
      ),
      //主页面编辑开始
      body: Center(
        child: Container(
            child: PageView(
          controller: _pageController,
          physics: BouncingScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _tab_index = index;
            });
          },
          children: list_tabs,
        )),
      ),
      //主页面编辑结束
      //底部导航栏开始

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab_index,
        onTap: (index) {
          setState(() {
            _tab_index = index;
          });
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 350),
              curve: Curves.ease); //点击bar切换页面动画配置
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '我的')
        ],
      ),
      //底部导航栏结束
    );
  }
}
