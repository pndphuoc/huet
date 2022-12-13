import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart';
import 'package:hue_t/view/sign_in_out/register_user.dart';
import '../profileuser/auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(children: [
        contentBlock(context),
        backButton(context),
      ]),
    );
  }

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
              fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black87),
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

  labelInput(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 35, right: 35, top: 17),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                fillColor: Color.fromARGB(255, 235, 235, 235),
                hintText: 'Enter your mail',
                labelStyle: TextStyle(color: Colors.grey),
                labelText: 'Email',
                focusColor: Colors.grey,
                border: OutlineInputBorder(
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
              decoration: const InputDecoration(
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                fillColor: Color.fromARGB(255, 235, 235, 235),
                hintText: 'Enter your password',
                labelStyle: TextStyle(color: Colors.grey),
                labelText: 'Password',
                focusColor: Colors.grey,
                border: OutlineInputBorder(
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
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 104, 104, 172),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20, bottom: 20, right: 130, left: 130),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'LOGIN',
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
              Text("Don't have an account? ", style: GoogleFonts.readexPro(fontWeight: FontWeight.w300, color: Colors.grey),),
              Text("Register Now", style: GoogleFonts.readexPro(fontWeight: FontWeight.w500, color: primaryColor),)
            ],
          ),
        ),
      ],
    );
  }
}
