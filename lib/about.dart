import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent[200],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "About",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 25,),
                Image(
                  image: AssetImage("assets/TTCaption.png"),
                  width: 250,
                  height: 250,
                ),
                Text(
                  "Welcome to your trick or treat helper!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'In this app, users can interact with a map and add "SweetSpots" to let other app users know which houses are giving out candy this Halloween!',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'To add a SweetSpot, open the drawer tab on the home app bar and click on the house on the map! Fill out the following information and your spot will be published for all app users to see!',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Get out there and be a Halloween hero! Have a safe night!',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
