import 'package:fiberchat/Configs/app_constants.dart';
import 'package:fiberchat/Screens/homepage/homepage.dart';
import 'package:fiberchat/Screens/splash_screen/splash_screen.dart';
import 'package:fiberchat/widgets/MyElevatedButton/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstTimeScreen extends StatefulWidget {
  FirstTimeScreen(
      {required this.currentUserNo,
      required this.isSecuritySetupDone,
      required this.prefs,
      key})
      : super(key: key);
  final String? currentUserNo;
  final bool isSecuritySetupDone;
  final SharedPreferences prefs;

  @override
  State<FirstTimeScreen> createState() => _FirstTimeScreenState();
}

class _FirstTimeScreenState extends State<FirstTimeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SplashBackgroundSolidColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              '$newLogo',
              width: 250,
              height: 170,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45.0),
              child: Text(
                "Simple , Secure Reliable messaging",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 28, letterSpacing: 2, color: Colors.grey.shade800),
              ),
            ),
            myNewElevatedButton(
              onPressed:() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                return Homepage(currentUserNo: widget.currentUserNo, isSecuritySetupDone: widget.isSecuritySetupDone, prefs: widget.prefs);
              })),
                color: primaryColors,
                child: Text(
                  "Start Messaging",
                  style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 1),
                ))
          ],
        ),
      ),
    );
  }
}
