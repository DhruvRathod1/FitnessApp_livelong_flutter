import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:livelong_flutter/registerPage.dart';
import 'package:livelong_flutter/uihelper.dart';
import 'registerPage.dart';
import 'home.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signUp(String email, String password) async {
    if (email == "" || password == "") {
      UiHelper.CustomAlertBox(context, "Enter Required Fields");
    } else {
      UserCredential? userCredential;
      try {
        userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterPage(title: "Register Page"), // Provide title parameter
          ),
        );
      } on FirebaseAuthException catch (ex) {
        return UiHelper.CustomAlertBox(context, ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up Page"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.CustomTextField(
            emailController,
            "Email",
            Icons.mail,
            false,
          ),
          UiHelper.CustomTextField(
            passwordController,
            "Password",
            Icons.password,
            true,
          ),
          SizedBox(height: 30),
          UiHelper.CustomButton(
                () {
              signUp(
                emailController.text.toString(),
                passwordController.text.toString(),
              );
            },
            "Sign Up",
          )
        ],
      ),
    );
  }
}
