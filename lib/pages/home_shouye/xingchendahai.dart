import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class xingchendahai extends StatefulWidget {
  const xingchendahai({super.key});

  @override
  State<xingchendahai> createState() => _xingchendahaiState();
}

var url1; // 获取的当前链接
final ValueNotifier<bool> _isLoadingNotifier =
    ValueNotifier<bool>(true); // 加载状态显示的变量

class _xingchendahaiState extends State<xingchendahai> {
  // _______________________________________________________________
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {
        _isLoadingNotifier.value = true;  // 开始设置为加载状态
      },
      onPageFinished: (String url) {
        _isLoadingNotifier.value = false;  // 加载成功设置为加载完成状态
        Uri uri = Uri.parse(url);
        url1 = uri.origin + uri.path;
        print('url1：$url1');
      },
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        return NavigationDecision.navigate;
      },
    ))
    ..loadRequest(Uri.parse('https://www.puresky.top/'));

// ___________________________________________________
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
          child: ValueListenableBuilder<bool>(
            valueListenable: _isLoadingNotifier,
            builder: (BuildContext context, bool isLoading, Widget? child) {
              return isLoading
                  ? Container(
                      color: Colors.white,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container(
                margin: EdgeInsets.fromLTRB(
                    0, MediaQuery.of(context).padding.top + 2, 0, 0),
                child: Center(
                  child: WebViewWidget(
                    controller: controller,
                  ),
                ),
              );
            },
          ),
          canPop: false,
          onPopInvoked: (bool didPop) async {
            print(didPop);
            if (didPop) {
              return;
            } else if (didPop == true) {
              Navigator.pop(context);
            } else {
              if (await controller.canGoBack() && url1 != "网页返回拦截") {
                await controller.goBack();
                return;
              } else {
                Navigator.pop(context);
                return;
              }
            }
          }),
    );
  }
}
