import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class xingchendahai extends StatefulWidget {
  const xingchendahai({super.key});

  @override
  State<xingchendahai> createState() => _xingchendahaiState();
}
var url1;
class _xingchendahaiState extends State<xingchendahai> {

  // _______________________________________________________________
  var controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {
          Uri uri = Uri.parse(url);
          url1 = uri.origin + uri.path;
      },
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        return NavigationDecision.navigate;
      },
    ))
    ..loadRequest(Uri.parse('https://chenyang-tnt.gitee.io/'));



// ___________________________________________________
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, MediaQuery
                .of(context)
                .padding
                .top + 2, 0, 0),
            child: Center(
              child: WebViewWidget(
                controller: controller,
              ),
            ),
          ),
          onWillPop: () async {
            if (await controller.canGoBack() && url1 != "https://chenyang-tnt.gitee.io/") {
              await controller.goBack();
              return false;
            } else {
              return true;
            }
          }),
    );
  }
}
