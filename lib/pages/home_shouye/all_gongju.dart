import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

class all_gongju extends StatefulWidget {
  const all_gongju({super.key});

  @override
  State<all_gongju> createState() => _all_gongjuState();
}

class _all_gongjuState extends State<all_gongju> {
  var _appbartile = "全部工具";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: Container(
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _appbartile = "全部工具";
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
          child: Center(
            child: Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      ExpansionTile(
                        title: Text("日常工具"),
                        children: [
                          Container(margin: EdgeInsets.all(10),height: 500,child: GridView(
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 2),
                            children: [gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),gongju_zujuan(),],
                          ),)
                        ],
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class gongju_zujuan extends StatefulWidget {
  const gongju_zujuan({super.key});

  @override
  State<gongju_zujuan> createState() => _gongju_zujuanState();
}

class _gongju_zujuanState extends State<gongju_zujuan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Center(
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: InkWell(
                      child: Center(
                        child: Stack(
                          children: [
                            Blur(
                                blur: 10,
                                blurColor: Colors.grey,
                                colorOpacity: 0.2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                        Colors.lightBlueAccent,
                                        Colors.green
                                      ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight)),
                                )),
                            Container(
                              child: Align(
                                child: Text(
                                  "网易云热评",
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
