import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewWidget extends StatefulWidget {
  final String url;
  const WebviewWidget({super.key, required this.url});

  @override
  State<WebviewWidget> createState() => _WebviewWidgetState();
}

class _WebviewWidgetState extends State<WebviewWidget> {
  late final WebViewController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void didUpdateWidget(covariant WebviewWidget old) {
    super.didUpdateWidget(old);
    if (old.url != widget.url) {
      _ctrl.loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) => WebViewWidget(controller: _ctrl);
}
