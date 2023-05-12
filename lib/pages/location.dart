import 'dart:math' show cos, sqrt, asin;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finance_app/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart';

import '../theme/colors.dart';



class User {
  final String name;
  final double? latitude;
  final double? longitude;
  final bool online;

  User({
    required this.name,
    this.latitude,
    this.longitude,
    required this.online,
  });

  factory User.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return User(
      name: data != null && data.containsKey('name') ? data['name'] : '',
      latitude: data != null && data.containsKey('latitude') ? data['latitude']?.toDouble() : null,
      longitude: data != null && data.containsKey('longitude') ? data['longitude']?.toDouble() : null,
      online: data != null && data.containsKey('online') ? data['online'] : false,
    );

  }
}

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late Stream<QuerySnapshot> _usersStream;
  late Position _currentPosition;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final double latitude;
  late final double longitude;



  @override
  void initState() {
    super.initState();

    _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('uid', isNotEqualTo: _auth.currentUser?.uid)
        .where('status', isEqualTo: 'Online')
        .where('role',isEqualTo: 'Volunteer')
        .snapshots();


    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print(e);
    }
  }

  double _calculateDistance(double? lat1, double? lon1, double? lat2, double? lon2) {
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) {
      return 0.0;
    }
    const p = 0.017453292519943295;
    const c = cos;
    final a = 0.5 - c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final users = snapshot.data!.docs.map((doc) {
                    return User.fromDocumentSnapshot(doc);
                  }).toList();

                  users.sort((a, b) {
                    final aDistance = _calculateDistance(
                        a.latitude, a.longitude, _currentPosition.latitude,
                        _currentPosition.longitude);
                    final bDistance = _calculateDistance(
                        b.latitude, b.longitude, _currentPosition.latitude,
                        _currentPosition.longitude);
                    return aDistance.compareTo(bDistance);
                  });

                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 16.0,bottom:16.0 ),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(color: primary, boxShadow: [
                                  BoxShadow(
                                      color: grey.withOpacity(0.01),
                                      spreadRadius: 10,
                                      blurRadius: 3)
                                ]),
                                child: Padding(
                                  padding:
                                  EdgeInsets.only(top: 10, bottom: 20, right: 0, left: 0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.assistant_navigation),
                                          SizedBox(
                                            width: 265,
                                          ),
                                          Icon(CupertinoIcons.search)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 22,
                            ),
                            Text(
                              'Nearby',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: mainFontColor,
                              ),
                            ),
                            Icon(Icons.map_rounded,color:mainFontColor),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [ Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Recent",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: mainFontColor,
                                    )),
                                Text("See all",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: mainFontColor,
                                    )),
                              ],
                            ),
                          ),


                          ],
                        ),

                        Expanded(
                          child: ListView(
                            children: users.map((user) {
                              return Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  elevation: 4,
                                  child: Container(
                                    width: (size.width - 90) * 0.7,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          leading:Icon(Icons.check_circle_outlined,color: Colors.green,),
                                          title: Text(user.name),
                                          subtitle: Text('${_calculateDistance(
                                            user.latitude,
                                            user.longitude,
                                            _currentPosition.latitude,
                                            _currentPosition.longitude,
                                          ).toStringAsFixed(2)} km'),
                                          trailing: TextButton(
                                            child: Icon(Icons.navigation),
                                            onPressed: () async {
                                              if (await MapLauncher.isMapAvailable(MapType.google) != null) {
                                                if (user.latitude != null && user.longitude != null) {
                                                  final coords = Coords(user.latitude!, user.longitude!);
                                                  await MapLauncher.showMarker(
                                                    mapType: MapType.google,
                                                    coords: coords,
                                                    title: user.name,
                                                    description:'Volunteer',
                                                  );
                                                } else {
                                                  print('Error: User location is not available');
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }}
