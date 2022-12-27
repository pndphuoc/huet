import 'package:flutter/material.dart';
import 'package:hue_t/main.dart';
import 'package:hue_t/view/home/home.dart';
import 'package:hue_t/view/profileuser/edit_profile.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/constants/user_info.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../profileuser/profile_user.dart';

class ProcessPage extends StatefulWidget {
  const ProcessPage({Key? key}) : super(key: key);

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return user == null ? Scaffold(
      backgroundColor: colors.backgroundColor,
        body: Center(child: LoadingAnimationWidget.discreteCircle(color: colors.primaryColor, size: 30),)) : userProvider.isGoogle ? const HueT(index: 1,) : const EditProfile();
  }
}
