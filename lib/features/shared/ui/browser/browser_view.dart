import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class BrowserView extends StatelessWidget {
  final String url;

  BrowserView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).colorScheme.primary

        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Abi\'s Recipes',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                )),
            Text(
              url,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri(url)),
                  onLoadStart: (controller, url) {},
                  androidOnPermissionRequest: (controller, origin, resources) async {
                    return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {},
                  onConsoleMessage: (controller, consoleMessage) {
                    debugPrint(consoleMessage.message);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
