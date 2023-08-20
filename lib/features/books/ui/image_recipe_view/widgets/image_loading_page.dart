import 'package:abis_recipes/app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ImageLoadingPage extends StatelessWidget {
  const ImageLoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(    crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Animate(
          effects: [ScaleEffect()],
          child: Image.asset(
            'assets/chef.png',
            height: 300,
          ),
        ),
        gap16,
        Text(
          'Sorting some things out \n(this can take up to 30 seconds)',
          textAlign: TextAlign.center,
        ),
        gap16,
        CircularProgressIndicator(),
      ],
    );
  }
}
