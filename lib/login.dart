import 'package:candy_tracker/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'components/my_button.dart';

class Login extends StatefulWidget {
  final Function()? onTap;
  const Login({Key? key, required this.onTap}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {

    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );


    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        wrongCredMessage();
      } else {
        print("GIVEN ERROR: " + e.code);
      }
    }
  }

  void wrongCredMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Email or Password! Please try again!'),
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
                  width: 300,
                  height: 300,
                ),
                Text(
                  'Welcome! ready to score lots of sweets?',
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


                SizedBox(height: 30,),

                MyButton(
                  text: "Sign In",
                  onTap: signUserIn,
                ),

                SizedBox(height: 40,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member?'),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Register now!',
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
