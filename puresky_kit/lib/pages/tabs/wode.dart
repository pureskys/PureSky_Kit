import 'package:flutter/material.dart';
void main() => runApp(wode());

class wode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        body: Center(
          child: Container(
            child: Text('我的'),
          ),
        ),
      ),
    );
  }
}
