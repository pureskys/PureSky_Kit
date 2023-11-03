import 'package:flutter/material.dart';

class vip_yingshi extends StatefulWidget {
  const vip_yingshi({super.key});

  @override
  State<vip_yingshi> createState() => _aaaState();
}

class _aaaState extends State<vip_yingshi> {
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
              "VIP视频解析",
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
                margin: EdgeInsets.fromLTRB(10,20,10,10),
                decoration: BoxDecoration(
                  border: new Border.all(color: Colors.blue, width: 2),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "   请粘贴视频链接",
                    hintText: "    请粘贴视频链接",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
