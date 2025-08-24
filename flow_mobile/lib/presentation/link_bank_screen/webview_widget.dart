import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

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
    final params = const PlatformWebViewControllerCreationParams();
    _ctrl =
        WebViewController.fromPlatformCreationParams(params)
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onWebResourceError: (err) {
                debugPrint('WEB ERR → ${err.errorCode} ${err.description}');
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
      // Android-only tweaks
      if (_ctrl.platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
        (_ctrl.platform as AndroidWebViewController).setMixedContentMode(
          MixedContentMode.alwaysAllow,
        );
      }
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
