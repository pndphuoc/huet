import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/main.dart';
import 'package:rive/rive.dart';

import '../view/profileuser/profile_user.dart';

class AnimatedBtn extends StatelessWidget {
  const AnimatedBtn({Key? key, required RiveAnimationController btnAnimationController,
                               required this.press, required this.text})  : _btnAnimationController = btnAnimationController,
        super(key: key);
  final String text;
  final RiveAnimationController _btnAnimationController;
  final VoidCallback press;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        height: 64,
        width: 236,
        child: Stack(
          children: [
            RiveAnimation.asset(
              "assets/RiveAssets/button.riv",
              controllers: [_btnAnimationController],
            ),
            Positioned.fill(
              top: 8,
              child: Center(child: Text(text, style: GoogleFonts.readexPro(fontWeight: FontWeight.w400, color: Colors.black))),
            ),

          ],
        ),
      ),
    );
  }
}