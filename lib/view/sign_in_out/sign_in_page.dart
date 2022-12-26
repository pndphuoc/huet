import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart';
import 'package:hue_t/providers/user_provider.dart';
import 'package:hue_t/view/profileuser/edit_profile.dart';
import 'package:hue_t/view/sign_in_out/register_user.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
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

class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  bool isShowSignInDialog = false;
  late RiveAnimationController _btnAnimationController;

  bool isLoading = false;

  List<ColorTween> tweenAnimations = [];
  int tweenIndex = 0;
  late AnimationController controller;
  List<Animation<Color?>> colorAnimations = [];

  final _formkey = GlobalKey<FormState>();
  String? email;
  String? password;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
    // controller = AnimationController(
    //   vsync: this,
    //   duration: duration,
    // );
    // for (int i = 0; i < colors.length - 1; i++) {
    //   tweenAnimations.add(ColorTween(begin: colors[i], end: colors[i + 1]));
    // }
    // tweenAnimations
    //     .add(ColorTween(begin: colors[colors.length - 1], end: colors[0]));
    // for (int i = 0; i < colors.length; i++) {
    //   Animation<Color?> animation = tweenAnimations[i].animate(CurvedAnimation(
    //       parent: controller,
    //       curve: Interval((1 / colors.length) * (i + 1) - 0.05,
    //           (1 / colors.length) * (i + 1),
    //           curve: Curves.linear)));
    //
    //   colorAnimations.add(animation);
    // }
    // if (kDebugMode) {
    //   print(colorAnimations.length);
    // }
    // tweenIndex = 0;
    // timer = Timer.periodic(duration, (Timer t) {
    //   setState(() {
    //     tweenIndex = (tweenIndex + 1) % colors.length;
    //   });
    // });
    // controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: primaryColor,
            resizeToAvoidBottomInset: true,
            body: Form(
              key: _formkey,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const RiveAnimation.asset(
                      "assets/RiveAssets/shapes.riv",
                    ),
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
                    child: contentBlock(context),
                  ),
                  backButton(context),
                ]),
              ),
            ),
          );
  }

  @override
  // void dispose() {
  //   timer.cancel();
  //   controller.dispose();
  //   super.dispose();
  // }

  contentBlock(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          headerLogin(context),
          labelInput(context),
          buttonLogin(context)
        ],
      ),
    );
  }

  backButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(top: 40, left: 20),
      child: Consumer<UserProvider>(
        builder: (context, value, child) => IconButton(
            onPressed: () {
              value.isLogin = true;
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            ),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))))),
      ),
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
                errorStyle: const TextStyle(color: Colors.red),
                focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                filled: true,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                fillColor:
                    const Color.fromARGB(255, 235, 235, 235).withOpacity(0.6),
                hintText: 'Enter your mail',
                labelStyle: const TextStyle(color: Colors.black54),
                labelText: 'Email',
                focusColor: Colors.black54,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Không được để trống";
                }
                if (!EmailValidator.validate(value)) {
                  return "Email nhập không hợp lệ !";
                }

                email = value;
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                filled: true,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                fillColor:
                    const Color.fromARGB(255, 235, 235, 235).withOpacity(0.6),
                hintText: 'Enter your password',
                labelStyle: const TextStyle(color: Colors.black54),
                labelText: 'Password',
                focusColor: Colors.black54,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Không được để trống";
                }

                password = value;
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Consumer<UserProvider>(
                builder: (context, value, child) => value.isLogin
                    ? const SizedBox(
                        height: 0,
                      )
                    : Text(
                        'Tài khoản hoặc mật khẩu không đúng!',
                        style: GoogleFonts.readexPro(
                            fontWeight: FontWeight.w400, color: Colors.red),
                      )),
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
        Consumer<UserProvider>(
          builder: (context, value, child) => AnimatedBtn(
              text: "LOGIN",
              btnAnimationController: _btnAnimationController,
              press: () {
                _btnAnimationController.isActive = true;
                if (_formkey.currentState!.validate()) {
                  Future.doWhile(() async {
                    const RiveAnimation.asset(
                      "assets/RiveAssets/success.riv",
                    );

                    setState(() async {
                      value.isLogin = false;

                      await value.login(email!, password!);
                      if (value.isLogin) {
                        await Future.delayed(Duration(milliseconds: 2000));
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => HueT(
                                      index: 1,
                                    ))),
                            (route) => false);
                      } else {
                        setState(() {});
                      }
                    });

                    return true;
                  });
                } else {}
              }),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'OR',
          style: GoogleFonts.readexPro(
              fontWeight: FontWeight.w300, color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.only(left: 30, right: 30),
          height: 60,
          child: Consumer<UserProvider>(
            builder: (context, value, child) => ElevatedButton(
              onPressed: () async {
                await AuthService().signInWithGoogle();
                await value.checkEmail(FirebaseAuth.instance.currentUser!.email!);
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
        ),
        const SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AuthService()
                        .handleAuthState(const HueT(), const RegisterUser())));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: GoogleFonts.readexPro(
                    fontWeight: FontWeight.w300, color: Colors.white),
              ),
              Text(
                "Register Now",
                style: GoogleFonts.readexPro(
                    fontWeight: FontWeight.w500, color: Colors.black87),
              )
            ],
          ),
        ),
      ],
    );
  }
}
