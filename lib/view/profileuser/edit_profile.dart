import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/view/profileuser/profile_user.dart';
import '../../constants/user_info.dart' as user_constant;

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var isUserLoginWithGoogle = FirebaseAuth.instance.currentUser;
  bool isUserGG = false;
  @override
  void initState() {
    if(isUserLoginWithGoogle != null){
      isUserGG = true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              header(context),
              const SizedBox(height: 40,),
              avatar(context),
              content(context)
            ],
          ),
        ),
      ),
    );
  }

  header(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20,right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: (){
                Navigator.pop(context, MaterialPageRoute(builder: (context) => const ProfileUser()));
              },
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_ios_new_outlined, size: 17, color: Colors.black54,),
                      Text('Back',style: GoogleFonts.readexPro(fontSize: 17,fontWeight: FontWeight.w300, color: Colors.black54),),
                    ],
                  ),
              ),
              Text('Edit Profile', style: GoogleFonts.readexPro(fontWeight: FontWeight.w400, fontSize: 20),),
              TextButton(onPressed: (){
                Navigator.pop(context, MaterialPageRoute(builder: (context) => const ProfileUser()));
              },
                child: Row(
                  children: [
                    Text('Save', style: GoogleFonts.readexPro(fontWeight: FontWeight.w400, fontSize: 17, color: Color.fromARGB(255, 104, 104, 172)),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  avatar(BuildContext context) {
    return Stack(
      children: [ Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(150),boxShadow: const [
          BoxShadow(
            blurRadius: 7,
            spreadRadius: 1,
            color: Colors.grey,
            offset: Offset(1,3),
          )
        ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(150),
          child: Image.network(FirebaseAuth.instance.currentUser!.photoURL!.toString(),width: 150,height: 150,fit: BoxFit.cover,),
        ),
      ),
      Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: const Color.fromARGB(255, 104, 104, 172)),
            child: const Center(
              child: Icon(
                Icons.settings,
                size: 20,
                color: Colors.white,
              ),
            ),
          )),
      ],

    );
  }

  content(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name',style:GoogleFonts.readexPro(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.black87),),
                const SizedBox(height: 10,),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: user_constant.user!.name,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email',style:GoogleFonts.readexPro(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.black87),),
                const SizedBox(height: 10,),
                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: user_constant.user!.mail,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Phone',style:GoogleFonts.readexPro(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.black87),),
                const SizedBox(height: 10,),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: user_constant.user!.phoneNumber,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Password',style:GoogleFonts.readexPro(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.black87),),
                SizedBox(height: 10,),
                isUserGG?TextField(
                  obscureText: true,
                  enabled: false,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: '******',
                  ),
                ):
                TextField(
                  obscureText: true,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: '******',
                  ),
                )
              ],
            ),
          ],
        )
      ),
    );
  }
}
