import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:livelong_flutter/uihelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required String title}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController goalController = TextEditingController();

  register(String email, String password, String name, String gender, String height, String weight, String dob, String goal) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty || gender.isEmpty || height.isEmpty || weight.isEmpty || dob.isEmpty || goal.isEmpty) {
      UiHelper.CustomAlertBox(context, "Please fill in all fields");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Save additional user information to Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'name': name,
          'gender': gender,
          'height': height,
          'weight': weight,
          'dob': dob,
          'goal': goal,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(title: "Home Page"),
          ),
        );
      } on FirebaseAuthException catch (ex) {
        UiHelper.CustomAlertBox(context, ex.message.toString());
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: heightController,
              decoration: InputDecoration(labelText: 'Height'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Weight'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: dobController,
              decoration: InputDecoration(labelText: 'Date of Birth'),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: goalController,
              decoration: InputDecoration(labelText: 'Fitness Goal'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                register(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                  nameController.text.trim(),
                  genderController.text.trim(),
                  heightController.text.trim(),
                  weightController.text.trim(),
                  dobController.text.trim(),
                  goalController.text.trim(),
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
