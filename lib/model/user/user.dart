class User {
  String name;
  String mail;
  String photoURL;
  String? phoneNumber;
  String uid;
  bool? isGoogle;
  String? password;
  User(
      {required this.name,
      required this.mail,
      required this.photoURL,
      required this.uid,
      this.phoneNumber,
      this.isGoogle,
      this.password});
}
