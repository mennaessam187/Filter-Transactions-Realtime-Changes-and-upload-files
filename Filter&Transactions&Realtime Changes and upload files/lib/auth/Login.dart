//import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:secondproject_firebase/component/container_webside.dart';
import 'package:secondproject_firebase/component/materialbutton.dart';
import 'package:secondproject_firebase/component/textformfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

bool loading = false;

class _LoginState extends State<Login> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  GlobalKey<FormState> key1 = GlobalKey();
  /* Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    if (googleUser == null) {
      return;
    }
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context)
        .pushNamedAndRemoveUntil("welcompage", (route) => false);
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue[800],
                      ),
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey[200],
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        "images/login.png",
                        width: 50,
                        height: 50,
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 50, right: 10),
            child: Form(
              key: key1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 37,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Login To Continue Using The App",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  text("Enter your Email", emailcontroller, Icon(Icons.email),
                      (value) {
                    if (value!.isEmpty) {
                      return "Can't empty this field";
                    } else if (!(value!.contains("@gmail.com"))) {
                      return "notValite Email";
                    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return "The email must contain a number from 0 to 9";
                    }
                  }, (ValueKey) {}),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  text("Enter your Password", passwordcontroller,
                      Icon(Icons.visibility), (value) {
                    if (value!.isEmpty) {
                      return "Can't empty this field";
                    }
                  }, (ValueKey) {})
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    /*   if (emailcontroller.text == "") {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.rightSlide,
                        title: 'Dialog Title',
                        desc:
                            'Please enter the email that you want to change it is password',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      )..show();
                    } else {
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: emailcontroller.text);
                        MotionToast(
                          width: 350,
                          height: 50,

                          primaryColor: const Color.fromARGB(255, 13, 71, 161),
                          description: const Text(
                              "Check your email and change the password",
                              style: TextStyle(color: Colors.white)),
                          animationType: AnimationType
                              .fromTop, // Show the toast from the top
                          position: MotionToastPosition.top,
                          barrierColor: Colors.black.withOpacity(0.2),
                        ).show(context);
                      } catch (e) {
                        MotionToast(
                          width: 350,
                          height: 50,
                          primaryColor: Colors.red,
                          description: Text("Not Valied this Email,Try Again",
                              style: TextStyle(color: Colors.white)),
                          animationType: AnimationType
                              .fromTop, // Show the toast from the top
                          position: MotionToastPosition.bottom,
                          barrierColor: Colors.black.withOpacity(0.2),
                        ).show(context);
                      }
                    }
                    */
                  },
                  child: Container(
                    child: const Text(
                      "Forget Password?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 8, left: 8),
            child: materialbutton(() async {
              if (key1.currentState!.validate()) {
                try {
                  final credential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: emailcontroller.text,
                          password: passwordcontroller.text);
                  if (credential.user!.emailVerified) {
                    Navigator.of(context).pushReplacementNamed("homepage");
                  } else {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Email Verification',
                      desc: 'Please verify your email.',
                      btnOkOnPress: () {},
                    ).show();
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                  }
                }
              }
              /*    if (key1.currentState!.validate()) {
                try {
                  loading = true;
                  setState(() {});
                  final credential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailcontroller.text,
                    password: passwordcontroller.text,
                  );
                  loading = false;
                  setState(() {});
                  if (credential.user!.emailVerified) {
                    Navigator.of(context).pushReplacementNamed("welcompage");
                  } else {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Email Verification',
                      desc: 'Please verify your email.',
                      btnOkOnPress: () {},
                    ).show();
                  }
                } on FirebaseAuthException catch (e) {
                  loading = false;
                  setState(() {});
                  if (e.code == 'user-not-found') {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Login Error',
                      desc: 'No user found for that email.',
                      btnOkOnPress: () {},
                    ).show();
                  } else if (e.code == 'wrong-password') {
                    loading = false;
                    setState(() {});
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Login Error',
                      desc: 'Incorrect password. Please try again.',
                      btnOkOnPress: () {},
                    ).show();
                  } else if (e.code == 'invalid-email') {
                    loading = false;
                    setState(() {});
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Login Error',
                      desc:
                          'The email address is not valid. Please enter a valid email.',
                      btnOkOnPress: () {},
                    ).show();
                  } else if (e.code == 'user-disabled') {
                    loading = false;
                    setState(() {});
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Login Error',
                      desc: 'This user account has been disabled.',
                      btnOkOnPress: () {},
                    ).show();
                  } else {
                    loading = false;
                    setState(() {});
                    // هنا نقوم بوضع رسالة خطأ عامة للمستخدم في حال وقوع خطأ غير معروف
                    print("Unhandled error: ${e.code}");
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Login Error',
                      desc:
                          'An unexpected error occurred. Please try again later.',
                      btnOkOnPress: () {},
                    ).show();
                  }
                } catch (e) {
                  loading = false;
                  setState(() {});
                  // في حالة حدوث أي خطأ غير متوقع آخر
                  print("An unknown error occurred: $e");
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    title: 'Login Error',
                    desc: 'An unknown error occurred. Please try again later.',
                    btnOkOnPress: () {},
                  ).show();
                }
              } else {
                return "false";
              }
              */
            }, "Login"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 20,
                  child: Divider(
                    color: Colors.grey[300],
                  ),
                ),
                Text(
                  "Or login With",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SofadiOne',
                  ),
                ),
                SizedBox(
                  width: 120,
                  height: 20,
                  child: Divider(
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {}, child: contwebside(Icons.facebook)),
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    //signInWithGoogle();
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                    ),
                    child: ClipOval(
                        child: Image.asset(
                      "images/g.webp",
                      width: 10,
                      height: 10,
                      fit: BoxFit.contain,
                    )),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(onTap: () {}, child: contwebside(Icons.apple)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't Have Account?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("Register");
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
