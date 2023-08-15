import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/shared/ui/browser/browser_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UrlButton extends StatelessWidget {
  const UrlButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appService.currentUrl,
      builder: (context, url, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Animate(
            effects: [
              SlideEffect(
                begin: Offset(0, 0.5),
                end: Offset(0, 0),
              )
            ],
            child: TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: appService.currentUrl.value ?? ''));
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BrowserView(url: appService.currentUrl.value!),
                ));
              },
              child: Text('See the page'),
            ),
          ),
        );
      }
    );
  }
}
