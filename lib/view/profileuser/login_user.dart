import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hue_t/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({Key? key}) : super(key: key);

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: SizedBox(height: 20,
        child: ElevatedButton(
            child: const Text('Login with Google'),
            onPressed: (){
              final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();
            },
          ),
      ),
    );
  }
}

