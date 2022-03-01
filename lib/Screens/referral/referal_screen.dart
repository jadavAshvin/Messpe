import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiberchat/Configs/Dbpaths.dart';
import 'package:fiberchat/Configs/app_constants.dart';
import 'package:fiberchat/Screens/auth_screens/login.dart';
import 'package:fiberchat/Services/localization/language_constants.dart';
import 'package:fiberchat/Utils/utils.dart';
import 'package:fiberchat/widgets/MyElevatedButton/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen(
      {Key? key,
      this.phoneCode,
      this.phoneNo,
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
  final String? phoneNo;
  final String? phoneCode;

  @override
  _ReferralScreenState createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final _form = GlobalKey<FormState>();
  TextEditingController referralController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isReferNotFound = false;
  bool isAlreadyRegister = false;
  bool isApplied = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: SplashBackgroundSolidColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                ),
                Image.asset(
                  '$newLogo',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Have a Referral Code?",
                  style: TextStyle(
                      fontSize: 28,
                      letterSpacing: 1,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Provide referral code bellow and follow the instructions on the next screen to receive your reward",
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      wordSpacing: 2,
                      letterSpacing: 1),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 200,
                  child: TextFormField(
                    controller: referralController,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColors)),
                        hintText: 'Referral code',
                        hintStyle: TextStyle(color: Colors.grey.shade300),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                style: BorderStyle.solid))),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Align(
                    alignment: Alignment.center,
                    child: myNewElevatedButton(
                        onPressed: () async {
                          if (referralController.text.isNotEmpty) {
                            _form.currentState!.save();
                            print("number " + referralController.text);

                            final result = await FirebaseFirestore.instance
                                .collection(DbPaths.collectionusers)
                                .get();
                            final documents = result.docs;
                            for (int i = 0; i <= documents.length - 1; i++) {
                              if (widget.phoneNo == documents[i]['phone_raw']) {
                                print('in if');
                                isAlreadyRegister = true;
                                break;
                              }
                            }

                            setState(() {});
                            if(!isAlreadyRegister) {
                              isReferNotFound = true;
                              for(int i=0;i<=documents.length -1 ;i++){
                                if (documents[i]
                                    .data()
                                    .containsKey('referralCode')) {
                                  print(documents[i]['referralCode']);
                                  if (documents[i]['referralCode'] ==
                                      referralController.text.trim()) {
                                    final referralPhoneNumber =
                                    documents[i]['phone'];
                                    print('called with ' + referralPhoneNumber);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return LoginScreen(
                                            widget.phoneCode!,
                                            widget.phoneNo!,
                                            referralPhoneNumber,
                                            referralController.text.trim(),
                                            prefs: widget.prefs,
                                            accountApprovalMessage:
                                            widget.accountApprovalMessage,
                                            isaccountapprovalbyadminneeded: widget
                                                .isaccountapprovalbyadminneeded,
                                            isblocknewlogins:
                                            widget.isblocknewlogins,
                                            title: getTranslated(context, 'signin'),
                                            issecutitysetupdone:
                                            widget.issecutitysetupdone,
                                          );
                                        }));
                                    print('successfully referral code applied');
                                    isReferNotFound = false;
                                    break;
                                  }
                                  print('in if' + documents[i]['phone_raw']);
                                }
                              }
                            }
                            if (isAlreadyRegister) {
                              _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                  content: Text(
                                      'Referral code not applied because you Already registered with this number')));
                              print('Already registered with this number');
                            }

                            else if (isReferNotFound) {
                              _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                  content: Text('Referral code not found')));
                            }
                          } else {
                            Fiberchat.toast('Please enter referral code');
                          }
                        },
                        color: primaryColors,
                        child: Text(
                          "Next",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              letterSpacing: 1),
                        ))),
                SizedBox(
                  height: 30,
                ),
                Align(
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginScreen(
                              widget.phoneCode!,
                              widget.phoneNo!,
                              '',
                              referralController.text.trim(),
                              prefs: widget.prefs,
                              accountApprovalMessage:
                                  widget.accountApprovalMessage,
                              isaccountapprovalbyadminneeded:
                                  widget.isaccountapprovalbyadminneeded,
                              isblocknewlogins: widget.isblocknewlogins,
                              title: getTranslated(context, 'signin'),
                              issecutitysetupdone: widget.issecutitysetupdone,
                            );
                          }));
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(color: primaryColors, fontSize: 20),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// print('a');

// Navigator.push(context,
//     MaterialPageRoute(builder: (context) {
//   return LoginScreen(
//     widget.phoneCode!,
//     widget.phoneNo!,
//     prefs: widget.prefs,
//     accountApprovalMessage:
//         widget.accountApprovalMessage,
//     isaccountapprovalbyadminneeded:
//         widget.isaccountapprovalbyadminneeded,
//     isblocknewlogins: widget.isblocknewlogins,
//     title: getTranslated(context, 'signin'),
//     issecutitysetupdone: widget.issecutitysetupdone,
//   );
// }));

// documents.forEach((element) {
//   if (widget.phoneNo == element['phone_raw']) {
//     print('in if');
//
//     isAlreadyRegister = true;
//
//   } else {
//     print('in else');
//     if (element
//         .data()
//         .containsKey('referralCode')) {
//       print(element['referralCode']);
//       if (element['referralCode'] ==
//           referralController.text.trim()) {
//         final referralPhoneNumber =
//             element['phone'];
//         print('called with '+ referralPhoneNumber);
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) {
//           return LoginScreen(
//             widget.phoneCode!,
//             widget.phoneNo!,
//             referralPhoneNumber,
//             referralController.text.trim(),
//             prefs: widget.prefs,
//             accountApprovalMessage:
//                 widget.accountApprovalMessage,
//             isaccountapprovalbyadminneeded: widget
//                 .isaccountapprovalbyadminneeded,
//             isblocknewlogins:
//                 widget.isblocknewlogins,
//             title: getTranslated(context, 'signin'),
//             issecutitysetupdone:
//                 widget.issecutitysetupdone,
//           );
//         }));
//         print('successfully referral code applied');
//         isReferNotFound = false;
//       } else {
//         isReferNotFound = true;
//       }
//       print('in if' + element['phone_raw']);
//     }
//   }
// });
