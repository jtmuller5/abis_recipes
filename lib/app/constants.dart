import 'package:flutter/cupertino.dart';

SizedBox gap8 = SizedBox(height: 8, width: 8);
SizedBox gap16 = SizedBox(height: 16, width: 16);
SizedBox gap32 = SizedBox(height: 32, width: 32);
SizedBox gap64 = SizedBox(height: 64, width: 64);

enum Pastry {
  cupCake('assets/cup-cake.png'),
  chocolateCake('assets/chocolate-cake.png'),
  cheesecake('assets/cheesecake.png'),
  cookies('assets/cookies.png'),
  croissant('assets/croissant.png'),
  eclair('assets/eclair.png'),
  danish('assets/danish.png'),
  macarons('assets/macarons.png'),
  milkBread('assets/milk-bread.png'),
  donuts('assets/donuts.png'),
  brioche('assets/brioche.png'),
  mousse('assets/mousse.png'),
  tart('assets/tart.png');

  const Pastry(this.asset);

  final String asset;
}
