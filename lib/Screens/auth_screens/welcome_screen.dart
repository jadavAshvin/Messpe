import 'package:fiberchat/Configs/app_constants.dart';
import 'package:fiberchat/Screens/auth_screens/login.dart';
import 'package:fiberchat/Screens/referral/referal_screen.dart';
import 'package:fiberchat/Screens/splash_screen/splash_screen.dart';
import 'package:fiberchat/Services/localization/language_constants.dart';
import 'package:fiberchat/Utils/utils.dart';
import 'package:fiberchat/widgets/MyElevatedButton/MyElevatedButton.dart';
import 'package:fiberchat/widgets/PhoneField/intl_phone_field.dart';
import 'package:fiberchat/widgets/PhoneField/phone_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key,
    this.title,
    required this.issecutitysetupdone,
    required this.isaccountapprovalbyadminneeded,
    required this.accountApprovalMessage,
    required this.prefs,
    required this.isblocknewlogins})
      : super(key: key);

  final String? title;
  final bool issecutitysetupdone;
  final bool? isblocknewlogins;
  final bool? isaccountapprovalbyadminneeded;
  final String? accountApprovalMessage;
  final SharedPreferences prefs;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _form = GlobalKey<FormState>();
  final _phoneNo = TextEditingController();
  String? phoneCode = DEFAULT_COUNTTRYCODE_NUMBER;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SplashBackgroundSolidColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100,),
                Image.asset(
                  '$newLogo',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 50,),

                Text("Welcome to Messpe", style: TextStyle(fontSize: 28,
                    letterSpacing: 1,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold),)
                , SizedBox(height: 3,),
                Text(
                  "Provide your phone number, so we can be able to send your confirmation code",
                  maxLines: 2,
                  style: TextStyle(color: Colors.grey.shade500,
                      wordSpacing: 2,
                      letterSpacing: 1),),

                SizedBox(height: 10,),
                MobileInputWithOutline(
                  buttonhintTextColor: fiberchatGrey,
                  borderColor: fiberchatGrey.withOpacity(0.2),
                  controller: _phoneNo,
                  initialCountryCode:
                  DEFAULT_COUNTTRYCODE_ISO,
                  onSaved: (phone) {
                    setState(() {
                      phoneCode = phone!.countryCode;
                    });
                  },
                ),

                SizedBox(height: 10,),
                RichText(
                  text: TextSpan(
                    text: 'By continuing, you are indicating that you Agree to ',
                    style: TextStyle(color: Colors.grey.shade500,
                        wordSpacing: 2,
                        letterSpacing: 1),
                    children: const <TextSpan>[
                      TextSpan(text: 'Policy Privacy',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' and'),
                      TextSpan(text: ' Terms',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(height: 40,),
                Align(
                    alignment: Alignment.center,
                    child: myNewElevatedButton(
                        onPressed: () {
                          RegExp e164 = new RegExp(
                              r'^\+[1-9]\d{1,14}$');
                          if (_phoneNo.text.isNotEmpty &&
                              e164.hasMatch(phoneCode! +
                                  _phoneNo.text)) {
                            _form.currentState!.save();
                            print("number " + _phoneNo.text);
                            print("Country code" + phoneCode.toString());
                            Navigator.push(context, MaterialPageRoute(builder: (
                                context) {
                              return
                                ReferralScreen(
                                phoneNo:  _phoneNo.text,
                                phoneCode: phoneCode.toString(),
                                  title: getTranslated(context, 'signin'),
                                  issecutitysetupdone: widget.issecutitysetupdone,
                                  isaccountapprovalbyadminneeded: widget.isaccountapprovalbyadminneeded,
                                  accountApprovalMessage: widget.accountApprovalMessage,
                                  prefs: widget.prefs,
                                  isblocknewlogins: widget.isblocknewlogins);
                              // LoginScreen(
                              //     phoneCode.toString(),
                              //     _phoneNo.text,
                              //     prefs: widget.prefs,
                              //     accountApprovalMessage:
                              //         widget.accountApprovalMessage,
                              //     isaccountapprovalbyadminneeded:
                              //     widget.isaccountapprovalbyadminneeded,
                              //     isblocknewlogins:widget.isblocknewlogins,
                              //     title: getTranslated(context, 'signin'),
                              //     issecutitysetupdone:
                              //         widget.issecutitysetupdone,
                              //   );
                            }));
                          } else {
                            Fiberchat.toast('Please enter valid mobile no');
                          }
                        },
                        color: primaryColors, child: Text("Continue",
                      style: TextStyle(color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 1),)))
              ],
            ),
          ),
        ),
      ),

    );
  }
}

class MobileInputWithOutline extends StatefulWidget {
  final String? initialCountryCode;
  final String? hintText;
  final double? height;
  final double? width;
  final TextEditingController? controller;
  final Color? borderColor;
  final Color? buttonTextColor;
  final Color? buttonhintTextColor;
  final TextStyle? hintStyle;
  final String? buttonText;
  final Function(PhoneNumber? phone)? onSaved;

  MobileInputWithOutline({this.height,
    this.width,
    this.borderColor,
    this.buttonhintTextColor,
    this.hintStyle,
    this.buttonTextColor,
    this.onSaved,
    this.hintText,
    this.controller,
    this.initialCountryCode,
    this.buttonText});

  @override
  _MobileInputWithOutlineState createState() => _MobileInputWithOutlineState();
}

class _MobileInputWithOutlineState extends State<MobileInputWithOutline> {
  // BoxDecoration boxDecoration(
  //     {double radius = 5,
  //       Color bgColor = Colors.white,
  //       var showShadow = false}) {
  //   return BoxDecoration(
  //       color: bgColor,
  //       boxShadow: showShadow
  //           ? [
  //         BoxShadow(
  //             color: fiberchatgreen, blurRadius: 10, spreadRadius: 2)
  //       ]
  //           : [BoxShadow(color: Colors.transparent)],
  //       border:
  //       Border.all(color: widget.borderColor ?? Colors.grey, width: 1.5),
  //       borderRadius: BorderRadius.all(Radius.circular(radius)));
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsetsDirectional.only(bottom: 7, top: 5),
          height: widget.height ?? 50,
          width: widget.width ?? MediaQuery
              .of(this.context)
              .size
              .width,
          // decoration: boxDecoration(),
          child: IntlPhoneField(
              dropDownArrowColor:
              widget.buttonhintTextColor ?? Colors.grey[300],
              textAlign: TextAlign.left,
              initialCountryCode: widget.initialCountryCode,
              controller: widget.controller,
              style: TextStyle(
                  height: 1.35,
                  letterSpacing: 1,
                  fontSize: 16.0,
                  color: widget.buttonTextColor ?? Colors.black87,
                  fontWeight: FontWeight.bold),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(3, 15, 8, 0),
                  hintText: 'Phone Number',
                  hintStyle: widget.hintStyle ??
                      TextStyle(
                          letterSpacing: 1,
                          height: 0.0,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w400,
                          color: widget.buttonhintTextColor ?? fiberchatGrey),
                  fillColor: Colors.white,
                  filled: true,
                  border: new OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide.none,
                  )),
              onChanged: (phone) {
                widget.onSaved!(phone);
              },
              validator: (v) {
                return null;
              },
              onSaved: widget.onSaved),
        ),
        // Positioned(
        //     left: 110,
        //     child: Container(
        //       width: 1.5,
        //       height: widget.height ?? 48,
        //       color: widget.borderColor ?? Colors.grey,
        //     ))
      ],
    );
  }
}

