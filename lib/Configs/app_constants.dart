//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'dart:ui';
import 'package:fiberchat/Configs/Enum.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//*--App Colors : Replace with your own colours---
//-**********---------- WHATSAPP Color Theme: -------------------------
final fiberchatBlack = new Color(0xFF1E1E1E);
final fiberchatBlue = new Color(0xFF02ac88);
final fiberchatDeepGreen = new Color(0xFF01826b);
final fiberchatLightGreen = new Color(0xFF02ac88);
final fiberchatgreen = new Color(0xFF01826b);
final fiberchatteagreen = Color(0xffECEAEB);
final fiberchatWhite = Colors.white;
final fiberchatGrey = Color(0xff85959f);
final fiberchatChatbackground = new Color(0xffe8ded5);

// final fiberchatBlack = primaryColors;
// final fiberchatBlue = primaryColors;
// final fiberchatDeepGreen = primaryColors;
// final fiberchatLightGreen = primaryColors;
// final fiberchatgreen = primaryColors;
// final fiberchatteagreen = primaryColors;
// final fiberchatWhite = Colors.white;
// final fiberchatGrey = primaryColors;
// final fiberchatChatbackground = Colors.grey;

const DESIGN_TYPE = Themetype.whatsapp;
const IsSplashOnlySolidColor = false;
// const SplashBackgroundSolidColor = Color(
//     0xFF086c5b);
// applies this colors if "IsSplashOnlySolidColor" is set to true. Color Code: 0xFF005f56 for Whatsapp theme & 0xFFFFFFFF for messenger theme.
const SplashBackgroundSolidColor = Color(0xFFFFFFFF);
const primaryColors = Color(0xffefa363);
//-*********---------- MESSENGER Color Theme: ---------------// Remove below comments for Messenger theme //------------
// final fiberchatBlack = new Color(0xFF353f58);
// final fiberchatBlue = new Color(0xFF3d9df5);
// final fiberchatDeepGreen = new Color(0xFF296ac6);
// final fiberchatLightGreen = new Color(0xFF036eff);
// final fiberchatgreen = new Color(0xFF06a2ff);
// final fiberchatteagreen = new Color(0xFFe0eaff);
// final fiberchatWhite = Colors.white;
// final fiberchatGrey = Colors.grey;
// final fiberchatChatbackground = new Color(0xffdde6ea);
// const DESIGN_TYPE = Themetype.messenger;
// const IsSplashOnlySolidColor = false;
// const SplashBackgroundSolidColor = Color(
//     0xFFFFFFFF); //applies this colors if "IsSplashOnlySolidColor" is set to true. Color Code: 0xFF005f56 for Whatsapp theme & 0xFFFFFFFF for messenger theme.

//*--Admob Configurations- (By default Test Ad Units pasted)----------
const IsBannerAdShow =
    false; // Set this to 'true' if you want to show Banner ads throughout the app
const Admob_BannerAdUnitID_Android =
    'ca-app-pub-3940256099942544/6300978111'; // Test Id: 'ca-app-pub-3940256099942544/6300978111'
const Admob_BannerAdUnitID_Ios =
    'ca-app-pub-3940256099942544/2934735716'; // Test Id: 'ca-app-pub-3940256099942544/2934735716'
const IsInterstitialAdShow =
    false; // Set this to 'true' if you want to show Interstitial ads throughout the app
const Admob_InterstitialAdUnitID_Android =
    'ca-app-pub-3940256099942544/1033173712'; // Test Id:  'ca-app-pub-3940256099942544/1033173712'
const Admob_InterstitialAdUnitID_Ios =
    'ca-app-pub-3940256099942544/4411468910'; // Test Id: 'ca-app-pub-3940256099942544/4411468910'
const IsVideoAdShow =
    false; // Set this to 'true' if you want to show Video ads throughout the app
const Admob_RewardedAdUnitID_Android =
    'ca-app-pub-3940256099942544/5224354917'; // Test Id: 'ca-app-pub-3940256099942544/5224354917'
const Admob_RewardedAdUnitID_Ios =
    'ca-app-pub-3940256099942544/1712485313'; // Test Id: 'ca-app-pub-3940256099942544/1712485313'
//Also don't forget to Change the Admob App Id in "fiberchat/android/app/src/main/AndroidManifest.xml" & "fiberchat/ios/Runner/Info.plist"
const cashfree_api_id = '1357389dbf28d88ed08ae153bf837531';
const cashfree_secret_key = 'b2b39340b21cd3080161452c06ec9bb5e34ee9f7';
//*--Agora Configurations---
const Agora_APP_IDD = '81df5b05d030409a9526265d2da2edb3';
// Grab it from: https://www.agora.io/en/
const dynamic Agora_TOKEN =
    null; // not required until you have planned to setup high level of authentication of users in Agora.

//*--Giphy Configurations---
const GiphyAPIKey = 'FkVHL42Dzhh9ARygjkh8bNK4zRTGKSA4';
//'PASTE_YOUR_GIPHY_API_KEY_HERE'; // Grab it from: https://developers.giphy.com/

//*--App Configurations---
const Appname = 'Messpe'; //app name shown evrywhere with the app where required
const DEFAULT_COUNTTRYCODE_ISO =
    'IN'; //default country ISO 2 letter for login screen
const DEFAULT_COUNTTRYCODE_NUMBER =
    '+91'; //default country code number for login screen
final FONTFAMILY_NAME =
// null;
    GoogleFonts.montserrat()
        .fontFamily; // make sure you have registered the font in pubspec.yaml

//--WARNING----- PLEASE DONT EDIT THE BELOW LINES UNLESS YOU ARE A DEVELOPER -------
// const SplashPath = 'assets/images/splash.jpeg';
const SplashPath = 'assets/newImages/splash.png';
const newLogo = 'assets/newImages/AppLogo1.jpeg';
// const logo2 = 'assets/newImages/logo2.png';
// const AppLogoPath = 'assets/images/applogo.png';
const BlurImage = 'assets/newImages/blur.jpeg';
const VisaImage = 'assets/newImages/visa.png';
const logo_ver = 'assets/newImages/logo_ver.png';
const ProfileImage = 'assets/newImages/profile.jpeg';
