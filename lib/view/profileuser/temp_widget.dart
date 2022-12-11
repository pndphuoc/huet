import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hue_t/view/profileuser/auth_service.dart';
import 'package:hue_t/view/profileuser/loginin_page.dart';
import 'package:hue_t/view/profileuser/profile_user.dart';
import '../../constants/user_info.dart' as userConstant;
import '../../model/user/user.dart' as userModel;
class TempWidget extends StatefulWidget {
  const TempWidget({Key? key}) : super(key: key);

  @override
  State<TempWidget> createState() => _TempWidgetState();
}

class _TempWidgetState extends State<TempWidget> {
  @override
  Widget build(BuildContext context) {
    return userConstant.user != null ? const ProfileUser(): AuthService().handleAuthState();
  }
}
