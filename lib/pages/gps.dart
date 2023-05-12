import 'dart:math' show cos, sqrt, asin;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Stream<QuerySnapshot> _usersStream;
  late Position _currentPosition;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('uid', isNotEqualTo: _auth.currentUser?.uid)
        .where('status', isEqualTo: 'online')
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Online Users'),
        ),
        body: StreamBuilder<QuerySnapshot>(
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

            return ListView(
              children: users.map((user) {
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.online ? 'Online' : 'Offline'),
                  trailing: Text('${_calculateDistance(
                    user.latitude,
                    user.longitude,
                    _currentPosition.latitude,
                    _currentPosition.longitude,
                  ).toStringAsFixed(2)} km'),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }}
