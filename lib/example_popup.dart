import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamplePopup extends StatefulWidget {
  final Marker marker;

  const ExamplePopup(this.marker, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExamplePopupState();
}

class _ExamplePopupState extends State<ExamplePopup> {

  var db = FirebaseFirestore.instance;

  List spotTitle = ['...'];
  List spotRating = ['...'];
  List spotNotes = ['...'];


  @override
  void initState() {
    super.initState();
    loadSpotsFromDb();
  }

  void loadSpotsFromDb() {
    db.collection('sweetspots').doc('${widget.marker.point.latitude}, ${widget.marker.point.longitude}').get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        spotTitle[0] = documentSnapshot.get('title');
        spotRating[0] = documentSnapshot.get('rating');
        spotNotes[0] = documentSnapshot.get('notes');
      } else {
        print("document does not exist on db");
      }
      setState(() {});
    }).catchError((error) {
      print("request failed for cache " + error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => setState(() {
        }),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _cardDescription(context),
          ],
        ),
      ),
    );
  }

  Widget _cardDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              spotTitle[0],
              overflow: TextOverflow.fade,
              softWrap: false,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
            Text(
              'Position: ${widget.marker.point.latitude.toStringAsFixed(6)}, ${widget.marker.point.longitude.toStringAsFixed(6)}',
              style: const TextStyle(fontSize: 13.0),
            ),
            Text(
              'Rating: ' + spotRating[0],
              style: const TextStyle(fontSize: 15.0),
            ),
            Text(
              'Notes: ' + spotNotes[0],
              style: const TextStyle(fontSize: 15.0),
            ),
          ],
        ),
      ),
    );
  }
}