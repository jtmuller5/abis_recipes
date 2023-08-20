import 'package:abis_recipes/app/router.dart';
import 'package:flutter/material.dart';

class BakerChat extends StatelessWidget {
  const BakerChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'baker_chat',
      onPressed: () {
        router.push('/chat');
      },
      child: Icon(
        Icons.message_outlined,
        color: Colors.white,
      ),
    );
  }
}
