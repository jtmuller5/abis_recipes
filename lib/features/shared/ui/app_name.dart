import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppName extends StatelessWidget {
  const AppName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Abi\'s Recipes',
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(fontSize: 32, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
      ).animate(onPlay: (controller) => controller.repeat()).shimmer(delay: Duration(seconds: 5)),
    );
  }
}
