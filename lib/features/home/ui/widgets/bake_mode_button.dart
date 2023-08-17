import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/main.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

class BakeModeButton extends StatelessWidget {
  const BakeModeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: appService.bakeMode,
        builder: (context, value, child) {
          return FloatingActionButton(
            backgroundColor: value ? Colors.green : Colors.white,
            onPressed: () {
              appService.setBakeMode(!appService.bakeMode.value);

              if (!value) {
                amplitude.logEvent('press bake mode on');
                Wakelock.enable();
              } else {
                amplitude.logEvent('press bake mode off');
                Wakelock.disable();
              }

              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: !value ? Colors.green : Colors.black, content: Text(!value ? 'Bake Mode On' : 'Bake Mode Off')));
            },
            child: Icon(
              value ? Icons.cake : Icons.cake_outlined,
              color: value ? Colors.white : Colors.black,
            ),
          );
        });
  }
}
