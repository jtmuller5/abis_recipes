import 'package:abis_recipes/app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PastryIcon extends StatelessWidget {
  PastryIcon({
    Key? key,
    required this.pastry,
    this.sideLength = 48,
    this.asset,
  }) : super(key: key);

  final Pastry pastry;
  final double sideLength;
  String? asset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: sideLength, width: sideLength, child: Image.asset(asset ?? pastry.asset)).animate(onPlay: (controller) => controller.repeat()).shake(
          delay: Duration(seconds: 1),
          duration: Duration(milliseconds: 1000),
          offset: Offset(0, .1),
          hz: 2,
        );
  }
}
