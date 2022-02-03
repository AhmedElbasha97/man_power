import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SupportChatPage extends StatefulWidget {
  @override
  _SupportChatPageState createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  @override
  late WebViewController _controller;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: new WebView(
          initialUrl: 'https://tawk.to/chat/6078259af7ce1827093ab3f2/1f3al5p6d',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) async {
            _controller = webViewController;

            //I've left out some of the code needed for a webview to work here, fyi
          },
        ),
        // body: Tawk(
        //   directChatLink:
        //       'https://tawk.to/chat/6078259af7ce1827093ab3f2/1f3al5p6d',
        //   visitor: TawkVisitor(),
        //   onLoad: () {
        //     print('Hello Tawk!');
        //   },
        //   onLinkTap: (String url) {
        //     print(url);
        //   },
        //   placeholder: Center(
        //     child: Text('Loading...'),
        //   ),
        // ));
    );
  }
}
