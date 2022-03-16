import 'dart:convert';
import 'dart:math';
import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiberchat/Configs/Dbkeys.dart';
import 'package:fiberchat/Configs/Dbpaths.dart';
import 'package:fiberchat/Configs/app_constants.dart';
import 'package:fiberchat/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCreditsScreen extends StatefulWidget {
  final String phoneNo;

  const AddCreditsScreen({Key? key, required this.phoneNo}) : super(key: key);

  @override
  _AddCreditsScreenState createState() => _AddCreditsScreenState();
}

class _AddCreditsScreenState extends State<AddCreditsScreen> {
  TextEditingController controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLoading = false;
  int points = 0;
  String name = '';

  //String notifyUrl = "https://test.gocashfree.com/notify";
  Future<String> _generateToken(orderId) async {
    try {
      var headers = {
        'x-client-id': '1357389dbf28d88ed08ae153bf837531',
        'x-client-secret': 'b2b39340b21cd3080161452c06ec9bb5e34ee9f7',
        'Content-Type': 'application/json'
      };
      final response = await http.post(
          Uri.parse('https://test.cashfree.com/api/v2/cftoken/order'),
          body: json.encode({
            "orderId": orderId,
            "orderAmount": int.parse(controller.text.trim()),
            "orderCurrency": "INR"
          }),
          headers: headers);
      // print('response' + response.body);
      final result = jsonDecode(response.body);
      return result['cftoken'];
    } catch (error) {
      Fiberchat.toast(error.toString());
      return "";
    }
  }

  void _setPoints(BuildContext context) async {

    //For payment
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    String stage = "TEST";

    Random rnd;
    int min = 5;
    int max = 10;
    rnd = new Random();
    int r = min + rnd.nextInt(max - min);

    int rewardPoints = int.parse(controller.text.trim()) * r ~/ 100;
    print(Dbkeys.nickname);
    String appId = "1357389dbf28d88ed08ae153bf837531";
    String tokenData = await _generateToken(orderId);
    print(tokenData);
    if (tokenData == "") {
      Fiberchat.toast('Something went wrong');
      return;
    }
    String orderAmount = controller.text.trim();
    String customerName = name;
    String orderNote = "payment with m";
    String orderCurrency = "INR";
    String customerPhone = widget.phoneNo;
    String customerEmail = "test@gmail.com";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": '',
    };
    setState(() {
      isLoading = true;
    });

    CashfreePGSDK.doPayment(inputParams).then((value) {
//       value?.forEach((key, value) {
// //        print("$key : $value");
//       });

      // print(value!['txStatus']);
      if (value!['txStatus'] == 'SUCCESS') {
        FirebaseFirestore.instance
            .collection(DbPaths.collectionusers)
            .doc(widget.phoneNo)
            .collection('wallet')
            .doc(orderId)
            .set({
          'id': orderId,
          'referenceId': value!['referenceId'],
          'paymentMode': value!['paymentMode'],
          'txStatus': value!['txStatus'],
          'signature': value!['signature'],
          'txMsg': value!['txMsg'],
          'txTime': value!['txTime'],
          'orderId': value!['orderId'],
          'orderAmount': value!['orderAmount'],
          'points': controller.text.trim(),
          'date': DateTime.now().toIso8601String(),
          'isReferred': false,
          'isReturn': false,
          'isConvertedToCredit': false,
          'isAdded': true,
          'rewardPoints': 0,
        }).then((value) {
          Navigator.pop(context);
          setState(() {
            isLoading = false;
          });
        }).catchError((error) {
          Navigator.pop(context);
          setState(() {
            isLoading = false;
          });
        });
      } else if (value!['txStatus'] == 'FAILED') {
        FirebaseFirestore.instance
            .collection(DbPaths.collectionusers)
            .doc(widget.phoneNo)
            .collection('wallet')
            .doc(orderId)
            .set({
          'id': orderId,
          'referenceId': value['referenceId'],
          'paymentMode': value['paymentMode'],
          'txStatus': value['txStatus'],
          'signature': value['signature'],
          'txMsg': value['txMsg'],
          'txTime': value['txTime'],
          'orderId': value['orderId'],
          'orderAmount': value['orderAmount'],
          'points': controller.text.trim(),
          'date': DateTime.now().toIso8601String(),
          'isReferred': false,
          'isReturn': false,
          'isConvertedToCredit': false,
          'isAdded': false,
        }).then((value) {
          Navigator.pop(context);
          setState(() {
            isLoading = false;
          });
        }).catchError((error) {
          Navigator.pop(context);
          setState(() {
            isLoading = false;
          });
        });
      }
    });

    print('Points ' +
        controller.text +
        ' rewardPoints ' +
        rewardPoints.toString() +
        ' per ' +
        r.toString() +
        '%');
  }

  @override
  void initState() {
    // TODO: implement initState
    _getName();
    super.initState();
  }

  void _getName() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(DbPaths.collectionusers)
        .where(Dbkeys.id, isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    final List documents = result.docs;
    documents.forEach((element) {
      name = element['nickname'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> walletStream = FirebaseFirestore.instance
        .collection(DbPaths.collectionusers)
        .doc(widget.phoneNo)
        .collection('wallet')
        .snapshots();

    Dialog confirmDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 300.0,
          width: 300.0,
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.close)),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text('Credits Amount',
                          style: TextStyle(fontSize: 16))),
                  Text('\u{20B9} ${controller.text}',
                      style: TextStyle(fontSize: 18))
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Divider(),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text('Points You will get',
                          style: TextStyle(fontSize: 16))),
                  Text(
                    controller.text,
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
              Divider(),
              Spacer(),
              InkWell(
                onTap: () {
                  _setPoints(context);
                },
                child: isLoading
                    ? SpinKitThreeBounce(
                        size: 20,
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: primaryColors,
                            ),
                          );
                        },
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: primaryColors,
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                        child: Text('Continue',
                            style: TextStyle(color: Colors.white)),
                      ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'T&C Applied',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          )),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColors,
        elevation: 0,
        toolbarHeight: 70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Text('Wallet'),
        titleSpacing: 5,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Points',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: walletStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SpinKitThreeBounce(
                            size: 20,
                            itemBuilder: (BuildContext context, int index) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  color: primaryColors,
                                ),
                              );
                            },
                          );
                        }
                        points = 0;
                        final List data = snapshot.data!.docs;
                        data.forEach((element) {
                          if ((element['isAdded'] || element['isReferred']) &&
                              !element['isConvertedToCredit'] &&
                              !element['isReturn']) {
                            points = points +
                                int.parse(element['points'].toString()) +
                                int.parse(element['rewardPoints'].toString());
                          }
                        });

                        return Text(
                          points.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade600,
                          ),
                        );
                      })
                ],
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Choose a Amount',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildAmountContainer('100'),
                        SizedBox(
                          width: 10,
                        ),
                        buildAmountContainer('500'),
                        SizedBox(
                          width: 10,
                        ),
                        buildAmountContainer('1000'),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildAmountContainer('1500'),
                        SizedBox(
                          width: 10,
                        ),
                        buildAmountContainer('2000'),
                        SizedBox(
                          width: 10,
                        ),
                        buildAmountContainer('2500'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Or type the Amount',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 40,
                width: 300,
                child: TextFormField(
                  cursorColor: primaryColors,
                  keyboardType: TextInputType.number,
                  controller: controller,
                  onChanged: (value){
                    setState(() {
                      controller.text = value;
                    });
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10),
                    hintText: 'Enter amount',
                    // prefixIcon: ,
                    prefixText: '\u{20B9} ',
                    prefixStyle: TextStyle(fontSize: 20),

                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: primaryColors),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () {

                  if (controller.text.length > 0 && controller.text.isNotEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => confirmDialog);
                    print('add points');
                  } else {
                    _scaffoldKey.currentState!.showSnackBar(
                        new SnackBar(content: new Text('Please enter amount')));
                    //    Scaffold.of(context).showSnackBar(SnackBar(content: Text('please enter amount')));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: primaryColors,
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  child:
                      Text('Continue', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAmountContainer(title) {
    return InkWell(
      onTap: () {
        setState(() {
          controller.text = title;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(title, style: TextStyle(color: Colors.black87)),
      ),
    );
  }
}

// showModalBottomSheet(
//   isScrollControlled: true,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(50),
//           topRight: Radius.circular(50)),
//     ),
//     backgroundColor: Colors.white,
//     context: context,
//     builder: (context) {
//       return Container(
//         height: MediaQuery.of(context).size.height * 0.75,
//         child: Padding(
//           padding: EdgeInsets.all(30),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment:
//                     MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       'Wallet Amount',
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     '\u{20B9} 1000',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.grey.shade600,
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   'Payment Method',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.black.withOpacity(0.6),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Container(
//                 // decoration: BoxDecoration(
//                 //   border: Border(
//                 //     bottom: BorderSide( color: Colors.black.withOpacity(0.7)),
//                 //   ),
//                 // ),
//                 child: Row(
//                   children: [
//                     Image.asset(
//                       VisaImage,
//                       height: 30,
//                       width: 50,
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Text(
//                       "**** **** **** 1235",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     Spacer(),
//                     InkWell(
//                         onTap: () {},
//                         child: Icon(Icons.more_vert,
//                             color: Colors.grey))
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               Divider(
//                 color: Colors.black,
//
//               ),
//
//               SizedBox(
//                 height: 15,
//               ),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   'Promo Code',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.black.withOpacity(0.6),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20,),
//               Container(
//                 height: 40,
//
//                 child: TextFormField(
//                   cursorColor: primaryColors,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(
//                         vertical: 10.0, horizontal: 10),
//                     hintText: 'Enter your promo code',
//                     // prefixIcon: ,
//
//                     border: InputBorder.none,
//                     enabledBorder: OutlineInputBorder(
//                       borderSide:
//                       const BorderSide(width: 1, color: Colors.grey),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide:
//                       const BorderSide(width: 1, color: primaryColors),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 20,),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   'Payment Summary',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.black.withOpacity(0.6),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 15,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Credits',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   Text(
//                     '\u{20B9} 1000',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey.shade600,
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(height: 10,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Points',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   Text(
//                     '200',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey.shade600,
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(height: 40,),
//               InkWell(
//                 onTap: () {
//                   // Navigator.push(context, MaterialPageRoute(builder: (_){
//                   //   return BankDetail();
//                   // }));
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: primaryColors,
//                       borderRadius: BorderRadius.circular(10)),
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 8),
//                   child:
//                   Text('Pay Now', style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
