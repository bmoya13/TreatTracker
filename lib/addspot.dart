import 'package:candy_tracker/components/my_button.dart';
import 'package:candy_tracker/components/my_textfield.dart';
import 'package:candy_tracker/home.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSpot extends StatefulWidget {
  final LatLng point;
  const AddSpot(this.point, {Key? key}) : super(key: key);

  @override
  State<AddSpot> createState() => _AddSpotState();
}

class _AddSpotState extends State<AddSpot> {

  final titleController = TextEditingController();
  final ratingController = TextEditingController();
  final notesController = TextEditingController();


  var auth = FirebaseAuth.instance;
  var db = FirebaseFirestore.instance;

  void submitSpot() async {
    var title = titleController.text.toString();
    var rating = ratingController.text.toString();
    var notes = notesController.text.toString();
    var coords = '${widget.point.latitude}, ${widget.point.longitude}';

    if (title.isEmpty || rating.isEmpty || notes.isEmpty) {
      showAlertDialog(context, "Ensure all fields are filled out", false);
    } else {
      db.collection('sweetspots').doc(coords).set({
        'title': title,
        'rating': rating,
        'notes': notes,
        'lat': '${widget.point.latitude}',
        'long': '${widget.point.longitude}',
        'uid': auth.currentUser?.uid,
      });
      showAlertDialog(context, 'SweetSpot successfully created!', true);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[400],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Add SweetSpot!",
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
                SizedBox(height: 15,),
                Text(
                  'Fill out this info to add the sweetspot!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10,),
                Image(
                  image: AssetImage('assets/TTIcon.png'),
                  width: 200,
                  height: 200,
                ),
                Text(
                  'Position: ${widget.point.latitude.toStringAsFixed(6)}, ${widget.point.longitude.toStringAsFixed(6)}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10,),
                MyTextField(
                  lines: 1,
                  controller: titleController,
                  hintText: 'Title',
                  obscureText: false,
                  type: TextInputType.text,
                ),
                SizedBox(height: 10,),
                Text(
                    "Rating (1-10): ",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10,),
                MyTextField(
                  lines: 1,
                  controller: ratingController,
                  hintText: "based on decorations, candy, etc.",
                  obscureText: false,
                  type: TextInputType.number,
                ),
                SizedBox(height: 10,),
                MyTextField(
                  lines: 3,
                  controller: notesController,
                  hintText: "Special notes about the location...",
                  obscureText: false,
                  type: TextInputType.text,
                ),
                SizedBox(height: 10,),
                MyButton(onTap: submitSpot, text: "Submit")
              ],
            ),
          ),
        ),
      ),
    );
  }
  showAlertDialog(BuildContext context, String text, bool finished) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        if (finished) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage())
          );
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(text),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
