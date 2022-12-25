import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hue_t/providers/user_provider.dart';
import 'package:hue_t/view/home/home.dart';
import 'package:hue_t/model/user/user.dart' as userModel;
import 'package:hue_t/view/profileuser/edit_profile.dart';
import 'package:hue_t/view/profileuser/loginin_page.dart';
import 'package:hue_t/view/profileuser/profile_user.dart';
import 'package:hue_t/view/sign_in_out/register_user.dart';
import 'package:hue_t/view/sign_in_out/sign_in_page.dart';

import 'package:provider/provider.dart';
import '../../constants/user_info.dart' as userConstant;
import '../../main.dart';
import 'package:hue_t/model/user/user.dart' as users;

class AuthService {
  //Determine if the user is authenticated.
  handleAuthState(Widget page, Widget targetWidget) {
    return Consumer<UserProvider>(
      builder: (context, value, child) => StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              if (!value.isGoogle) {
                value.createUser(
                    FirebaseAuth.instance.currentUser!.displayName!,
                    FirebaseAuth.instance.currentUser!.email!,
                    "",
                    FirebaseAuth.instance.currentUser!.photoURL!,
                    FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
                    true);
              }

              return value.isGoogle ? page : const EditProfile();
            } else {
              return targetWidget;
            }
          }),
    );
  }

/*  isLogin() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            userConstant.user = userModel.User(name:  FirebaseAuth.instance.currentUser!.displayName!, mail:  FirebaseAuth.instance.currentUser!.email!, photoURL:  FirebaseAuth.instance.currentUser!.photoURL!, uid:  FirebaseAuth.instance.currentUser!.uid, phoneNumber: FirebaseAuth.instance.currentUser!.phoneNumber);
           return
            } else {
            return handleAuthState();
          }
        });
  }*/

  signInWithGoogle() async {
    // Trigger the authentication flow

    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //Sign out
  Future<void> signOut(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    userConstant.user = null;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const HueT(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
