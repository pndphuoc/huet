import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart';
import 'package:hue_t/view/sign_in_out/register_user.dart';
import 'package:rive/rive.dart';
import '../../conponents/AnimatedBtn.dart';
import '../../main.dart';
import 'package:hue_t/colors.dart';
import '../profileuser/auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}


class _SignInPageState extends State<SignInPage> {
  late RiveAnimationController _btnAnimationController;
  bool isShowSignInDialog = false;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            left: 100,
            bottom: 100,
            child: Image.asset(
              "assets/Backgrounds/Spline.png",
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const SizedBox(),
            ),
          ),
          const RiveAnimation.asset(
            "assets/RiveAssets/shapes.riv",
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: contentBlock(context),),
          backButton(context),
        ]),
      ),
    );
  }

  contentBlock(BuildContext context) {
    return Column(
      children: [
        headerLogin(context),
        labelInput(context),
        buttonLogin(context)
      ],
    );
  }

  backButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(top: 40, left: 20),
      child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))))),
    );
  }

  headerLogin(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/splashscreen/2.png',
          width: MediaQuery.of(context).size.width / 1.15,
          fit: BoxFit.cover,
        ),
        Text(
          'Login HueT',
          style: GoogleFonts.readexPro(
              fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Please enter the details below to continue.',
          style: GoogleFonts.readexPro(
              color: Colors.white, fontWeight: FontWeight.w200, fontSize: 14),
        ),
      ],
    );
  }

  labelInput(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 35, right: 35, top: 17),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                focusedBorder:
                    UnderlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                filled: true,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                fillColor: const Color.fromARGB(255, 235, 235, 235).withOpacity(0.6),
                hintText: 'Enter your mail',
                labelStyle: const TextStyle(color: Colors.black54),
                labelText: 'Email',
                focusColor: Colors.black54,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null) {
                  return 'Your email';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: InputDecoration(
                focusedBorder:
                UnderlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),

                filled: true,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                fillColor: const Color.fromARGB(255, 235, 235, 235).withOpacity(0.6),
                hintText: 'Enter your password',
                labelStyle: const TextStyle(color: Colors.black54),
                labelText: 'Password',
                focusColor: Colors.black54,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null) {
                  return 'Your email';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  buttonLogin(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        AnimatedBtn(
          text: "LOGIN",
            btnAnimationController: _btnAnimationController,
            press: (){
              _btnAnimationController.isActive = true;
            Future.delayed(const Duration(milliseconds: 1500), () => Navigator.push(context,MaterialPageRoute(builder: (context) => const HueT())),);
            }
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'OR',
          style: GoogleFonts.readexPro(
              fontWeight: FontWeight.w300, color: Colors.black87),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.only(left: 30, right: 30),
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              AuthService().signInWithGoogle();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/profileuser/google_logo.png',
                  width: 30,
                  height: 30,
                ),
                Text(
                  'Continue with Google',
                  style: GoogleFonts.readexPro(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 17),
                ),
                const SizedBox(
                  width: 30,
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 15,),
        GestureDetector(
          onTap: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => const RegisterUser()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account? ", style: GoogleFonts.readexPro(fontWeight: FontWeight.w300, color: Colors.white),),
              Text("Register Now", style: GoogleFonts.readexPro(fontWeight: FontWeight.w500, color: Colors.black87),)
            ],
          ),
        ),
      ],
    );
  }
}
