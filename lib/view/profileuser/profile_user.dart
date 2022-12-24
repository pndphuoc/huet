import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as color;
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hue_t/main.dart';
import 'package:hue_t/view/profileuser/edit_profile.dart';
import 'package:hue_t/view/profileuser/loginin_page.dart';
import 'package:hue_t/view/sign_in_out/register_user.dart';
import 'package:hue_t/view/sign_in_out/sign_in_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../colors.dart';
import '../../constants/user_info.dart' as user_constants;
import 'auth_service.dart';
import 'package:hue_t/colors.dart' as colors;

class ProfileUser extends StatefulWidget {
  const ProfileUser({Key? key}) : super(key: key);

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  bool status = false;
  double sideLength = 50;
  bool isLoading = false;
  var isUserLoginWithGoogle = FirebaseAuth.instance.currentUser;
  bool isUserGG = false;
  @override
  void initState() {
    super.initState();
    if(isUserLoginWithGoogle != null) {
      isUserGG = true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return isLoading? Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: LoadingAnimationWidget.discreteCircle(
            size: 50, color: primaryColor,
          )),
    ):Scaffold(
      body: ListView(
        children: [
          header(context),
          content(context),
          preferences(context),
          //_buttonItem('Food', Icons.abc, () {}),
        ],
      ),
    );
  }

  Widget _buttonItem(
      String title, IconData leadingIcon, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(leadingIcon, color: Colors.black54),
              const SizedBox(
                width: 10,
              ),
              Text(title,
                  style: GoogleFonts.readexPro(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54)),
            ],
          ),

          const Icon(Icons.arrow_forward_ios_outlined,
              size: 17, color: Colors.black54),
          //Download
        ],
      ),
    );
  }

  Widget header(BuildContext context) {
    return user_constants.user == null
        ? Padding(
            padding: const EdgeInsets.only(top: 80, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150),
                    /*boxShadow: const [
                  BoxShadow(
                    blurRadius: 7,
                    spreadRadius: 1,
                    color: Colors.grey,
                    offset: Offset(1, 3),
                  )
                ]*/
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: Image.asset(
                        "assets/images/hotel/avatar.png",
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          accountNavigator(context,  AuthService().handleAuthState(const HueT(), const SignInPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: colors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Log in',
                          style: GoogleFonts.readexPro(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 120,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          accountNavigator(context, AuthService().handleAuthState(const HueT(), const RegisterUser()));
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: colors.primaryColor, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Register',
                          style: GoogleFonts.readexPro(
                              color: colors.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 80, bottom: 10),
            child: Column(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 7,
                          spreadRadius: 1,
                          color: Colors.grey,
                          offset: Offset(1, 3),
                        )
                      ]),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child:isUserGG? Image.network(
                        user_constants.user!.photoURL.toString(),
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ):Image.asset('assets/images/socialNetwork/avatar.png')
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  user_constants.user!.name,
                  style: GoogleFonts.readexPro(
                      fontSize: 19, fontWeight: FontWeight.w600),
                ),
                Text(
                  user_constants.user!.mail.toString(),
                  style: GoogleFonts.readexPro(
                      fontSize: 15, fontWeight: FontWeight.w100),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    accountNavigator(context, const EditProfile());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 104, 104, 172),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Edit Profile',
                        style: GoogleFonts.readexPro(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      const Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  accountNavigator(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Widget content(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: 40,
          color: color.backgroundColor,
          child: Text(
            'CONTENT',
            style: GoogleFonts.readexPro(
                letterSpacing: 2.0,
                fontSize: 14,
                fontWeight: FontWeight.w200,
                color: Colors.grey),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  /*user_constants.user == null
                      ? accountNavigator(context,  AuthService().handleAuthState(FavoritePage()))
                      : Container();*/
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite_border_outlined,
                            color: Colors.black54),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Favorites',
                          style: GoogleFonts.readexPro(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        ),
                      ],
                    ),

                    const Icon(Icons.arrow_forward_ios_outlined,
                        size: 17, color: Colors.black54),
                    //Download
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  user_constants.user == null
                      ? accountNavigator(context, const SignInPage())
                      : Container();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: Colors.black54),
                        const SizedBox(width: 10),
                        Text('My Location',
                            style: GoogleFonts.readexPro(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54)),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 17,
                      color: Colors.black54,
                    ),
                    //Download
                  ],
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ],
    );
  }

  Widget preferences(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: 40,
          color: color.backgroundColor,
          child: Text(
            'PREFERENCES',
            style: GoogleFonts.readexPro(
                letterSpacing: 2.0,
                fontSize: 14,
                fontWeight: FontWeight.w200,
                color: Colors.grey),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.language,
                        color: Colors.black54,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Language',
                        style: GoogleFonts.readexPro(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'English',
                        style: GoogleFonts.readexPro(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.black54),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 17,
                        color: Colors.black54,
                      ),
                    ],
                  ), //Download
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.dark_mode_outlined,
                        color: Colors.black54,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Dark Mode',
                        style: GoogleFonts.readexPro(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54),
                      ),
                    ],
                  ),
                  FlutterSwitch(
                    inactiveColor: Colors.black12,
                    width: 60.0,
                    activeColor: const Color.fromARGB(255, 104, 104, 172),
                    height: 30.0,
                    valueFontSize: 0.0,
                    toggleSize: 25.0,
                    value: status,
                    borderRadius: 30.0,
                    padding: 2.0,
                    showOnOff: true,
                    onToggle: (val) {
                      setState(() {
                        status = !status;
                      });
                    },
                  ),
                  //Download
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              user_constants.user == null
                  ? Container()
                  : TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      splashFactory: NoSplash.splashFactory
                    ),
                    onPressed: () async {
                      bool isLogout = await showDialog(context: context,
                          builder: (BuildContext context) {//TOTO:BUG
                            return _buildLogOutAlertDialog(context);
                          }
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout_outlined,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 10,),
                        Text(
                          'Log Out',
                          style: GoogleFonts.readexPro(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildLogOutAlertDialog(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FadeInUp(
            duration: const Duration(milliseconds:200 ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            title: Text("Log Out?", style: GoogleFonts.readexPro(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25), textAlign: TextAlign.center,),
            content: Text("Are you sure want to log out", style: GoogleFonts.readexPro(color: Colors.grey,), textAlign: TextAlign.center,),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(onPressed: (){
                Navigator.of(context).pop(false);
              },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 15),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ), child: Text("No", style: GoogleFonts.readexPro(color: Colors.grey),),
              ),
              ElevatedButton(onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await AuthService().signOut(context);
                setState(() {
                  isLoading = false;
                });
              },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 15),
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ), child: const Text("Yes"),
              ),
            ],
          ),)
        ],
      ),
    );
  }
}
