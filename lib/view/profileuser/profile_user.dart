import 'package:flutter/cupertino.dart';
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
      body: Column(
        children: [
          SizedBox(height: 80),
          header(context),
          SizedBox(height: 10,),
          content(context),
          preferences(context)
        ],
      ),
    );
  }

  header(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(150),boxShadow: [
            BoxShadow(
              blurRadius: 7,
              spreadRadius: 1,
              color: Colors.grey,
              offset: Offset(1,3),
            )
          ]),
          child: ClipRRect(

              borderRadius: BorderRadius.circular(150),
              child: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/20220401_Lee_Min-ho_%EC%9D%B4%EB%AF%BC%ED%98%B8_ELLE_Taiwan_%283%29.jpg/640px-20220401_Lee_Min-ho_%EC%9D%B4%EB%AF%BC%ED%98%B8_ELLE_Taiwan_%283%29.jpg",width: 150,height: 150,fit: BoxFit.cover,)),
        ),
            SizedBox(height: 5,),
            Text('Leminhoo',style: GoogleFonts.readexPro(fontSize: 19,fontWeight: FontWeight.w600),),
            Text('leminhoth@gmail.com', style: GoogleFonts.readexPro(fontSize: 15,fontWeight: FontWeight.w100),),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
            },style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 104, 104, 172),shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            )),
              child: SizedBox(
                width: 115,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Edit Profile',style: GoogleFonts.readexPro(fontSize: 14, fontWeight: FontWeight.w400),),
                    Icon(Icons.arrow_forward_ios_outlined, size: 17,),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  content(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: 40,
          color: color.backgroundColor,
          child: Text('CONTENT',style:GoogleFonts.readexPro(letterSpacing: 2.0,fontSize: 14, fontWeight: FontWeight.w200, color: Colors.grey),),
        ),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20,),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(

                    children: [
                      Icon(Icons.favorite_border_outlined, color: Colors.black54,),
                      SizedBox(width: 10,),
                      Text('Favorites', style: GoogleFonts.readexPro(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.black54),),
                    ],
                  ),

                  Icon(Icons.arrow_forward_ios_outlined,size: 17,color: Colors.black54,),
                  //Download
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.black54,),
                      SizedBox(width: 10,),
                      Text('My Location', style: GoogleFonts.readexPro(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.black54),),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios_outlined,size: 17,color: Colors.black54,),
                  //Download

                ],
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ],
    );
  }

  preferences(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: 40,
          color: color.backgroundColor,
          child: Text('PREFERENCES',style:GoogleFonts.readexPro(letterSpacing: 2.0,fontSize: 14, fontWeight: FontWeight.w200, color: Colors.grey),),
        ),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20,),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(

                    children: [
                      Icon(Icons.language, color: Colors.black54,),
                      SizedBox(width: 10,),
                      Text('Language', style: GoogleFonts.readexPro(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.black54),),
                    ],
                  ),
                  Row(
                    children: [
                      Text('English', style: GoogleFonts.readexPro(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black54),),
                      Icon(Icons.arrow_forward_ios_outlined,size: 17,color: Colors.black54,),
                    ],
                  ),                  //Download
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.dark_mode_outlined, color: Colors.black54,),
                      SizedBox(width: 10,),
                      Text('Dark Mode', style: GoogleFonts.readexPro(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.black54),),
                    ],
                  ),
                  FlutterSwitch(
                    inactiveColor: Colors.black12,
                    width: 60.0,
                    activeColor: Color.fromARGB(255, 104, 104, 172),
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
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(

                    children: [
                      Icon(Icons.logout_outlined, color: Colors.black54,),
                      SizedBox(width: 10,),
                      Text('Log Out', style: GoogleFonts.readexPro(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.black54),),
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
