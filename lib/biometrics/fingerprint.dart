// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jake_wharton/Screens/index.dart';
import 'package:local_auth/local_auth.dart';

class FingerPrintApp extends StatefulWidget {
  @override
  _FingerPrintAppState createState() => _FingerPrintAppState();
}

class _FingerPrintAppState extends State<FingerPrintApp> {
  LocalAuthentication auth = LocalAuthentication();
  bool? _canCheckBiometric;
  List<BiometricType>? _availableBiometrics; //store all type of bmtrcs
  String authorized = "Not Authorized"; //will check if we can access

  Future<void> _checkBiometric() async {
    late bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _getavailableBiometric() async {
    late List<BiometricType> availableBiometric;
    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      _availableBiometrics = availableBiometric;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
          localizedReason: 'Scan your finger to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      authorized = authenticated ? "Auth Sucess" : "Failed to auth";
      if (authenticated) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => IndexPage()));
      }
      print(authenticated);
    });
  }

  @override
  void initState() {
    _checkBiometric();
    _getavailableBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(37, 94, 111, 1),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 50.0),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/fingerprint.png',
                      width: 180.0,
                    ),
                    Text(
                      'Fingerprint Auth',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15.0),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _authenticate,
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            side: BorderSide(width: 1, color: Colors.white),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.all(10)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 24.0),
                          child: Text(
                            'Authenticate',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
