import 'package:candy_tracker/addspot.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:candy_tracker/about.dart';

import 'example_popup.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PopupController _popupLayerController = PopupController();
  var NewStash = false;

  final user = FirebaseAuth.instance.currentUser!;
  var auth = FirebaseAuth.instance;
  var db = FirebaseFirestore.instance;

  List caches = [];
  List cacheUID = [];

  @override
  void initState() {
    super.initState();
    loadSpotsFromDb();
  }

  void loadSpotsFromDb() {
    caches = [];
    cacheUID = [];
    db.collection("sweetspots").get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          caches.add(LatLng(double.parse(docSnapshot.get('lat')), double.parse(docSnapshot.get('long'))));
          cacheUID.add(docSnapshot.get('uid'));
        }
        print("list: " + caches[0].toString());
        print("uid list: " + cacheUID[0].toString());
        setState(() {});
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final test = caches.map((latlng) {
      return Marker(
        width: 60,
        height: 60,
        point: latlng,
        builder: (_) => Icon(
          Icons.circle,
          color: cacheUID[caches.indexOf(latlng)] == auth.currentUser?.uid ?
          Colors.green.withOpacity(0.3) :
          Colors.blue.withOpacity(0.3),
          size: 60,
        ),
        anchorPos: AnchorPos.align(AnchorAlign.center),
      );
    }).toList();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: signUserOut,
              icon: Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {
              loadSpotsFromDb();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Map refreshed!',
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor:
                      Colors.white,
                  )
              );
            },
            icon: Icon(Icons.refresh),
          )
        ],
        title: Text(
          user.email!,
        ),
      ),
      drawer: Drawer(
        width: 250,
        backgroundColor: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
                image: DecorationImage(
                  image: AssetImage('assets/TTCaption.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: Text(''),
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2, color: Colors.deepPurple),
                borderRadius: BorderRadius.circular(10),
              ),
              leading: Icon(Icons.info, size: 40, color: Colors.grey[400],),
              title: Text(
                'About',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey[400],
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const About())
                );
              },
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2, color: Colors.deepPurple),
                borderRadius: BorderRadius.circular(10),
              ),
              leading: Icon(Icons.add_business, size: 40, color: Colors.grey[400],),
              title: Text(
                'Add Sweetspot',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey[400],
                ),
              ),
              onTap: () {
                if (NewStash == true) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  NewStash = true;
                  ScaffoldMessenger.of(context).showSnackBar(_buildSnackbar(context));
                }
              },
            ),
          ],
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(34.07324817, -118.060849),
          zoom: 18,
          maxZoom: 18,
          minZoom: 17,
          onTap: _handleTap,
        ),
        children: [
          TileLayer(
            urlTemplate: dotenv.env['TEMPLATE'],
            userAgentPackageName: "com.treattracker.app",
          ),
          PopupMarkerLayerWidget(
            options: PopupMarkerLayerOptions(
              popupController: _popupLayerController,
              markers: test,
              markerRotateAlignment:
              PopupMarkerLayerOptions.rotationAlignmentFor(AnchorAlign.center),
              popupBuilder: (BuildContext context, Marker marker) =>
                  ExamplePopup(marker),
            ),
          ),
        ],
      ),
    );
  }
  SnackBar _buildSnackbar(BuildContext context) {
    return new SnackBar(
      content: const Text(
        'Tap the map to place a stash!',
        textAlign: TextAlign.center,
      ),
      duration: Duration(days: 1),
      backgroundColor: Colors.blueGrey,
      shape: StadiumBorder(),
      margin: EdgeInsets.all(50),
      behavior: SnackBarBehavior.floating,
    );
  }

  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    if (NewStash == true) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      setState(() {
        NewStash = false;
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSpot(latlng))
        );
      });
    }
  }
}
