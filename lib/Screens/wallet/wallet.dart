import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiberchat/Configs/Dbkeys.dart';
import 'package:fiberchat/Configs/Dbpaths.dart';
import 'package:fiberchat/Configs/app_constants.dart';
import 'package:fiberchat/Screens/wallet/addCredits/addCrdits.dart';
import 'package:fiberchat/Screens/wallet/bankDetail/newBankDetails.dart';
import 'package:fiberchat/Screens/wallet/return/all_returnable_points.dart';
import 'package:fiberchat/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double credits = 0;
  int points = 0;
  int totalPoints = 0;
  String phoneNo = "";
  CollectionReference? walletRef;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _getPhoneNo();
    super.initState();
  }

  void _getPhoneNo() async {
    setState(() {
      isLoading = true;
    });
    final sp = await SharedPreferences.getInstance();
    phoneNo = sp.getString(Dbkeys.phone)!;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> walletStream = FirebaseFirestore.instance
        .collection(DbPaths.collectionusers)
        .doc(phoneNo)
        .collection('wallet')
        .snapshots();
    final Stream<QuerySnapshot> creditsStream = FirebaseFirestore.instance
        .collection(DbPaths.collectionusers)
        .where(Dbkeys.id, isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return Scaffold(
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
      body: isLoading
          ? SpinKitThreeBounce(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: primaryColors,
                  ),
                );
              },
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        constraints: BoxConstraints(
                          maxWidth: 400,
                          minWidth: 300,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Credits',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                                StreamBuilder(
                                  stream: creditsStream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Something went wrong');
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return SpinKitThreeBounce(
                                        size: 20,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: primaryColors,
                                            ),
                                          );
                                        },
                                      );
                                    }

                                    final List documents = snapshot.data!.docs;
                                    credits = double.parse(documents[0]
                                                ['credits']
                                            .toString()) ??
                                        0;
                                    print('credits ' +
                                        credits.toStringAsFixed(2));
                                    return Text(
                                      credits.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey.shade600,
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Current Points',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
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
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: primaryColors,
                                              ),
                                            );
                                          },
                                        );
                                      }
                                      points = 0;
                                      List data = snapshot.data!.docs;

                                      data.forEach((element) {
                                        if ((element['isAdded'] ||
                                                element['isReferred']) &&
                                            !element['isConvertedToCredit'] &&
                                            !element['isReturn']) {
                                          points = points +
                                              int.parse(element['points']
                                                  .toString()) +
                                              int.parse(element['rewardPoints']
                                                  .toString());
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
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return AddCreditsScreen(
                                phoneNo: phoneNo,
                              );
                            }));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: primaryColors,
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 8),
                            child: Text('Add',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        InkWell(
                          onTap: () async {
                            int totalTransaction = 0;
                            DateTime now = DateTime.now();
                            final result = await FirebaseFirestore.instance
                                .collection(DbPaths.collectionusers)
                                .doc(phoneNo)
                                .collection('wallet')
                                .get();
                            if (result.size > 0) {
                              result.docs.forEach((element) {
                                if ((element.data() as Map)
                                    .containsKey("returnStatus")) {
                                  DateTime date =
                                      DateTime.parse(element['date']);
                                  if (element['isAdded'] &&
                                      !element['isReturn'] &&
                                      element['returnStatus'] == 'SUCCESS') {
                                    if (now.year == date.year &&
                                        now.month == date.month) {
                                      totalTransaction++;
                                    }
                                  }
                                } else {}
                              });
                            } else {
                              print('not');
                            }

                            QuerySnapshot result2 = await FirebaseFirestore
                                .instance
                                .collection(DbPaths.collectionusers)
                                .doc(phoneNo)
                                .collection('creditsReturn')
                                .get();
                            if (result2.size > 0) {
                              result2.docs.forEach((element) {
                                DateTime date = DateTime.parse(element['date']);
                                if (element['returnStatus'] == 'SUCCESS') {
                                  if (now.year == date.year &&
                                      now.month == date.month) {
                                    totalTransaction++;
                                  }
                                }
                              });
                            } else {
                              print('not');
                            }
                            print('total'+totalTransaction.toString());
                            if (totalTransaction >= 3) {
                              Fiberchat.toast(
                                  'You have already done 3 transaction in this month');
                              return;
                            }
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0)),
                                      //this right here
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          height: 200.0,
                                          width: 200.0,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Icon(Icons.close)),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                'Select one return type',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 40,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return NewBankDetails(
                                                        phoneNo: phoneNo,
                                                        isCredits: true,
                                                      );
                                                    })),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: primaryColors,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 8),
                                                      child: Text('Credits',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  InkWell(
                                                    onTap: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return AllReturnablePoints(
                                                          phoneNo: phoneNo);
                                                      //   NewBankDetails(
                                                      //   isPoints: true,
                                                      //   phoneNo: phoneNo,
                                                      // );
                                                    })),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: primaryColors,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 8),
                                                      child: Text('Points',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                            ],
                                          )),
                                    ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 8),
                            child: Text('Withdraw',
                                style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'History',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
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

                          return Container(
                            // height: 300,
                            child: ListView(
                              shrinkWrap: true,
                              primary: false,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;

                                    return Column(
                                      children: [
                                        if (data['isConvertedToCredit'])
                                          buildHistoryCard(
                                              'Points converted to credits',
                                              data['points'].toString()),
                                        if (data['isAdded'])
                                          buildHistoryCard('Points added',
                                              data['points'].toString()),
                                        if (data['isReferred'])
                                          buildHistoryCard('Referral points',
                                              data['points'].toString()),
                                        if (data['isReturn'])
                                          buildHistoryCard(
                                              'Your withdraw points',
                                              data['points'].toString()),
                                        if (data['txtStatus'] == 'FAILED')
                                          buildHistoryCard(
                                              'Your withdraw points',
                                              data['points'].toString()),
                                      ],
                                    );

                                    print('in elseif');
                                    return Column(
                                      children: [],
                                    );
                                    {
                                      return Column(
                                        children: [],
                                      );
                                    }
                                    {
                                      return Column(
                                        children: [],
                                      );
                                    }
                                    {
                                      return Column(
                                        children: [],
                                      );
                                    }
                                    return Column(
                                      children: [],
                                    );
                                  })
                                  .toList()
                                  .reversed
                                  .toList(),
                            ),
                          );
                        })
                  ],
                ),
              ),
            ),
    );
  }
}

Widget buildHistoryCard(title, rupees) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Text(
            '$rupees',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade600,
            ),
          )
        ],
      ),
    ),
  );
}
