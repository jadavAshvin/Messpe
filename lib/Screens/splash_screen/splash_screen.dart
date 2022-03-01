//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'package:fiberchat/Configs/app_constants.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IsSplashOnlySolidColor == true
        ? Scaffold(
            backgroundColor: SplashBackgroundSolidColor,
            body: Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(primaryColors)),
            ))
        : Scaffold(

            body: Image.asset(
              '$SplashPath',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          );
  }
}
