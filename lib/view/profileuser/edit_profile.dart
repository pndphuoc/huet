// import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/providers/user_provider.dart';
import 'package:hue_t/view/profileuser/profile_user.dart';
import 'package:provider/provider.dart';
import '../../constants/user_info.dart' as user_constant;
import '../../main.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // var isUserLoginWithGoogle = FirebaseAuth.instance.currentUser;
  // bool isUserGG = false;
  // @override
  // void initState() {
  //   if(isUserLoginWithGoogle != null){
  //     isUserGG = true;
  //   }
  // }
  final _formKey = GlobalKey<FormState>();
  String name = user_constant.user!.name;
  String email = user_constant.user!.mail;
  String? password = user_constant.user!.password;
  String image = user_constant.user!.photoURL;
  String? phone = user_constant.user!.phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                header(context),
                const SizedBox(
                  height: 40,
                ),
                avatar(context),
                content(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  header(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20, right: 10),
          child: Consumer<UserProvider>(
            builder: (context, value, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HueT(
                                  index: 2,
                                )),
                        (route) => false);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 17,
                        color: Colors.black54,
                      ),
                      Text(
                        'Back',
                        style: GoogleFonts.readexPro(
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                            color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Edit Profile',
                  style: GoogleFonts.readexPro(
                      fontWeight: FontWeight.w400, fontSize: 20),
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() async {
                        await value.updateUser(name, email, password!, image,
                            phone!, user_constant.user!.isGoogle);
                        if (value.isUpdate) {
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfileUser()),
                              (route) => false);
                        }
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        'Save',
                        style: GoogleFonts.readexPro(
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                            color: Color.fromARGB(255, 104, 104, 172)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  avatar(BuildContext context) {
    return Stack(
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
              user_constant.user!.photoURL,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromARGB(255, 104, 104, 172)),
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
                  Text(
                    'Name',
                    style: GoogleFonts.readexPro(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      initialValue: name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        RegExp regex = RegExp(
                            r'^[a-zA-Z0-9.a-zA-Z0-9+" "+ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂ ưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]+$');
                        if (value!.length < 2 || value.length > 50) {
                          return "Vui lòng nhập tên ít nhất 2 ký tự và không quá 50 ký tự";
                        }
                        if (!regex.hasMatch(value)) {
                          return "Tên không được chứa ký tự đặc biệt!";
                        }
                        name = value;
                        return null;
                      })
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: GoogleFonts.readexPro(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: email,
                    enabled: !user_constant.user!.isGoogle!,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (!EmailValidator.validate(value!)) {
                        return "Email không hợp lệ!";
                      }
                      email = value;
                      return null;
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phone',
                    style: GoogleFonts.readexPro(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: phone ?? "",
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      phone = value;
                      return null;
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Password',
                    style: GoogleFonts.readexPro(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: password,
                    obscureText: true,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorText:
                          password == null ? "Vui lòng nhập mật khẩu" : null,
                    ),
                    validator: (value) {
                      if (value!.length < 5) {
                        return "Vui lòng nhập mật khẩu dài hơn!";
                      }
                      password = value;
                      return null;
                    },
                  )
                ],
              ),
            ],
          )),
    );
  }
}
