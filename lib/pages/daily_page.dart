import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_finance_app/theme/colors.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class DailyPage extends StatefulWidget {


  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> with WidgetsBindingObserver {
  Position? _positionFuture;
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _search = TextEditingController();
  late Map<String, dynamic> position ;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    setPosition();
  }

  void setPosition() async{
    final position = await _determinePosition();
    setState(() {
      _positionFuture = position;
    });
    if(_positionFuture != null)
     setStatus("Online");
    // _positionFuture.then((value) => setState((){
    //   position = value as Map<String, dynamic>;
    // }));
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
      "longitude": _positionFuture!.longitude,
      "latitude": _positionFuture!.latitude
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      var isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('EEEE, MMMM d');
    var formattedDate = formatter.format(now);
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 10),
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: grey.withOpacity(0.03),
                    spreadRadius: 10,
                    blurRadius: 3,
                    // changes position of shadow
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 25, right: 20, left: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Icon(Icons.bar_chart), Icon(Icons.more_vert)],
                  ),
                  SizedBox(
                    height: 15,
                  ),StreamBuilder<DocumentSnapshot>(
                    stream: _firestore.collection('users').doc(_auth.currentUser?.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        Map<String, dynamic> userMap = snapshot.data!.data() as Map<String, dynamic>;
                        return Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(userMap['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: (size.width - 40) * 0.6,
                              child: Column(
                                children: [
                                  Text(
                                    userMap['name'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: mainFontColor,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    userMap['status'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container(); // or any other widget to return
                      }
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // FutureBuilder<Position>(
                      //   future: _positionFuture,
                      //   builder: (context, snapshot) {
                      //     if (snapshot.hasData) {
                      //       var position = snapshot.data!;
                      //       // Use the position to build the widget tree
                      //       return Column(children: [
                      //         Text(
                      //           "${position.latitude.roundToDouble()}",
                      //           style: TextStyle(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.w600,
                      //               color: mainFontColor),
                      //         ),
                      //         SizedBox(
                      //           height: 5,
                      //         ),
                      //         Text(
                      //           "Latitude",
                      //           style: TextStyle(
                      //               fontSize: 12,
                      //               fontWeight: FontWeight.w100,
                      //               color: black),
                      //         )
                      //       ]);
                      //     } else if (snapshot.hasError) {
                      //       // Handle errors
                      //       return Center(
                      //         child: Text(
                      //             'Error retrieving location: ${snapshot.error}'),
                      //       );
                      //     } else {
                      //       // Display a loading indicator while waiting for the position to be retrieved
                      //       return Center(child: CircularProgressIndicator());
                      //     }
                      //   },
                      // ),
                  _positionFuture!=null ? Column(children: [
                          Text(
                            "${_positionFuture!.latitude.roundToDouble()}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: mainFontColor),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Latitude",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w100,
                                color: black),
                          )
                        ])
                      : Center(child: CircularProgressIndicator()),
                      Container(
                        width: 0.5,
                        height: 40,
                        color: black.withOpacity(0.3),
                      ),
                      // FutureBuilder<Position>(
                      //   future: _positionFuture,
                      //   builder: (context, snapshot) {
                      //     if (snapshot.hasData) {
                      //       var position = snapshot.data!;
                      //       // Use the position to build the widget tree
                      //       return Column(children: [
                      //         Text(
                      //           "${_positionFuture.longitude.roundToDouble()}",
                      //           style: TextStyle(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.w600,
                      //               color: mainFontColor),
                      //         ),
                      //         SizedBox(
                      //           height: 5,
                      //         ),
                      //         Text(
                      //           "Longitude",
                      //           style: TextStyle(
                      //               fontSize: 12,
                      //               fontWeight: FontWeight.w100,
                      //               color: black),
                      //         )
                      //       ]);
                      //     } else if (snapshot.hasError) {
                      //       // Handle errors
                      //       return Center(
                      //         child: Text(
                      //             'Error retrieving location: ${snapshot.error}'),
                      //       );
                      //     } else {
                      //       // Display a loading indicator while waiting for the position to be retrieved
                      //       return Center(child: CircularProgressIndicator());
                      //     }
                      //   },
                      // ),
                      _positionFuture != null ?
                      Column(children: [
                                Text(
                                  "${_positionFuture!.longitude.roundToDouble()}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: mainFontColor),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Longitude",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w100,
                                      color: black),
                                )
                              ]):
                             Center(child: CircularProgressIndicator()),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text("Overview",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: mainFontColor,
                            )),
                        IconBadge(
                          icon: Icon(Icons.notifications_none),
                          itemCount: 1,
                          badgeColor: Colors.red,
                          itemColor: mainFontColor,
                          hideZero: true,
                          top: -1,
                          onTap: () {
                            print('test');
                          },
                        ),
                      ],
                    )
                  ],
                ),
                // Text("Overview",
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 20,
                //       color: mainFontColor,
                //     )),
                Text(formattedDate,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: mainFontColor,
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 20,
                          left: 25,
                          right: 25,
                        ),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: grey.withOpacity(0.03),
                                spreadRadius: 10,
                                blurRadius: 3,
                                // changes position of shadow
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 20, left: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: arrowbgColor,
                                  borderRadius: BorderRadius.circular(15),
                                  // shape: BoxShape.circle
                                ),
                                child: Center(
                                    child: Icon(CupertinoIcons.book)),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  width: (size.width - 90) * 0.7,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "A strong woman knows she has strength enough for the journey, but a woman of strength knows it is in the journey where she will become strong.",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          left: 25,
                          right: 25,
                        ),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: grey.withOpacity(0.03),
                                spreadRadius: 10,
                                blurRadius: 3,
                                // changes position of shadow
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 20, left: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: arrowbgColor,
                                  borderRadius: BorderRadius.circular(15),
                                  // shape: BoxShape.circle
                                ),
                                child: Center(
                                    child: Icon(CupertinoIcons.person)),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  width: (size.width - 90) * 0.7,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Respect for ourselves guides our morals; respect for others guides our manners.",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
