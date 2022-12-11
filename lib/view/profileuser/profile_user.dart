import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as color;
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hue_t/view/profileuser/edit_profile.dart';

class ProfileUser extends StatefulWidget {
  const ProfileUser({Key? key}) : super(key: key);

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  Widget _buttonItem(String title, IconData leadingIcon, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(leadingIcon,
                  color: Colors.black54),
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
    return Padding(
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
                child: Image.network(
                  FirebaseAuth.instance.currentUser!.photoURL.toString(),
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                )),
          ),
          const SizedBox(height: 5),
          Text(
            FirebaseAuth.instance.currentUser!.displayName!,
            style: GoogleFonts.readexPro(
                fontSize: 19, fontWeight: FontWeight.w600),
          ),
          Text(
            FirebaseAuth.instance.currentUser!.email.toString(),
            style: GoogleFonts.readexPro(
                fontSize: 15, fontWeight: FontWeight.w100),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () => editProfileAction(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 104, 104, 172),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: SizedBox(
              width: 115,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Profile',
                    style: GoogleFonts.readexPro(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void editProfileAction() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const EditProfile()));
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.favorite_border_outlined,
                          color: Colors.black54),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Favorites',
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Colors.black54),
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
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.logout_outlined,
                        color: Colors.black54,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Log Out',
                        style: GoogleFonts.readexPro(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
