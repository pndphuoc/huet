import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/view/sign_in_out/sign_in_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rive/rive.dart';

import '../../colors.dart';
import '../../main.dart';
import '../profileuser/auth_service.dart';
import '../profileuser/profile_user.dart';

class RegisterUser extends StatefulWidget {
   const RegisterUser({Key? key}) : super(key: key);
  @override
  State<RegisterUser> createState() => _RegisterUserState();
}
class _RegisterUserState extends State<RegisterUser> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading? Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: LoadingAnimationWidget.discreteCircle(
            size: 50, color: primaryColor,
          )),
    ): Scaffold(
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
    return SingleChildScrollView(
      child: Column(
        children: [
          headerRegisterUser(context),
          labelInput(context),
          buttonRegister(context)
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
      child: IconButton(
          onPressed: () {
            Navigator.pop(context);/*
            Navigator.push(context,MaterialPageRoute(builder: (context) => const ProfileUser()));*/
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

  headerRegisterUser(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/splashscreen/2.png',
          width: MediaQuery.of(context).size.width / 1.67,
          fit: BoxFit.cover,
        ),
        Text(
          'Register HueT',
          style: GoogleFonts.readexPro(
              fontSize: 27, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Please enter the details below to continue.',
          style: GoogleFonts.readexPro(
              color: Colors.black54, fontWeight: FontWeight.w200, fontSize: 14),
        ),
      ],
    );
  }

  Widget inputInformationUser(String hintDataText,String labelDataText, String validatorValue){
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        focusedBorder:
        const UnderlineInputBorder(borderSide: BorderSide.none),
        filled: true,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        fillColor: const Color.fromARGB(255, 235, 235, 235).withOpacity(0.8),
        hintText: hintDataText,
        labelText: labelDataText,
        labelStyle: const TextStyle(color: Colors.grey),
        focusColor: Colors.grey,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),

      validator: (value) {
        if (value == null) {
          return validatorValue;
        }
        return null;
      },
    );
  }

  labelInput(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 35, right: 35, top: 17),
        child: Column(
          children: [
            inputInformationUser('User name','Name','Your user name'),
            const SizedBox(
              height: 15,
            ),
            inputInformationUser('Enter your Email','Email','Your email'),
            const SizedBox(
              height: 15,
            ),
            inputInformationUser('Enter your password', 'Password', 'Your password'),
            const SizedBox(
              height: 15,
            ),
            inputInformationUser('Re-enter your password', 'Confirm password', 'Your password'),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  buttonRegister(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () async{
            setState((){
              isLoading = true;
            });
            //Register
            setState(() {
              isLoading = false;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 104, 104, 172),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20, bottom: 20, right: 95, left: 95),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'REGISTER NOW',
                  style: GoogleFonts.readexPro(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'OR',
          style: GoogleFonts.readexPro(
              fontWeight: FontWeight.w300, color: Colors.grey),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.only(left: 30, right: 30),
          height: 60,
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              await AuthService().signInWithGoogle();
              setState(() {
                isLoading = false;
              });
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: AuthService().handleAuthState(const HueT(), const RegisterUser())), (route) => false);
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
                  'Register with Google',
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
            Navigator.push(context,MaterialPageRoute(builder: (context) => const SignInPage()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account? ", style: GoogleFonts.readexPro(fontWeight: FontWeight.w300, color: Colors.grey),),
              Text("Log In", style: GoogleFonts.readexPro(fontWeight: FontWeight.w500, color: primaryColor),)
            ],
          ),
        ),
      ],
    );
  }
}
