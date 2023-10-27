import 'package:candy_tracker/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'components/my_button.dart';

class Signup extends StatefulWidget {
  final Function()? onTap;
  const Signup({Key? key, required this.onTap}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  void signUserUp() async {
    var auth = FirebaseAuth.instance;

    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    if(passwordController.text != confirmController.text) {
      Navigator.pop(context);
      showErrorMessage("Passwords do not match!");
      return;
    }

    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      Navigator.pop(context);
      var userUid = auth.currentUser?.uid;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        showErrorMessage("Incorrect email and/or password, please try again!");
      } else {
        print("GIVEN ERROR: " + e.code);
      }
    }
  }

  void showErrorMessage(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[400],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                //Logo
                Image(
                  image: AssetImage('assets/TTCaption.png'),
                  width: 250,
                  height: 250,
                ),
                Text(
                  'Let\'s create an account for you!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16
                  ),
                ),

                SizedBox(height: 25,),

                MyTextField(
                  lines: 1,
                  type: TextInputType.text,
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                SizedBox(height: 10,),
                MyTextField(
                  lines: 1,
                  type: TextInputType.text,
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 10,),
                MyTextField(
                  lines: 1,
                  type: TextInputType.text,
                  controller: confirmController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),


                SizedBox(height: 30,),

                MyButton(
                  text: "Sign Up",
                  onTap: signUserUp,
                ),

                SizedBox(height: 40,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Login now!',
                        style: TextStyle(
                            color: Colors.blue[300], fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
        ),
      ),

    );
  }
}
