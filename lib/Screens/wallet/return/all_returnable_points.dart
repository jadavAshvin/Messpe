import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiberchat/Configs/Dbpaths.dart';
import 'package:fiberchat/Configs/app_constants.dart';
import 'package:fiberchat/Screens/wallet/bankDetail/newBankDetails.dart';
import 'package:fiberchat/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AllReturnablePoints extends StatefulWidget {
  final phoneNo;

  const AllReturnablePoints({Key? key, required this.phoneNo})
      : super(key: key);

  @override
  _AllReturnablePointsState createState() => _AllReturnablePointsState();
}



class _AllReturnablePointsState extends State<AllReturnablePoints> {


  void _checkAlreadySendReturnRequest(context,orderId,orderAmount)async{
    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection(DbPaths.collectionusers)
        .doc(widget.phoneNo)
        .collection('wallet')
        .doc(orderId).get();
    if((result.data() as Map).containsKey("bankDetails")){
      print('exists');
      Fiberchat.toast('Your request already has been sent');
    }else{
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      NewBankDetails(
                        phoneNo:
                            widget.phoneNo,
                        orderId:
                            orderId,
                        orderAmount:
                            orderAmount,
                        isCredits: false,
                      )));
    }
      // print(result['bankDetails']['AccountNumber']);
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> walletStream = FirebaseFirestore.instance
        .collection(DbPaths.collectionusers)
        .doc(widget.phoneNo)
        .collection('wallet')
        .snapshots();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColors,
          elevation: 0,
          toolbarHeight: 70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: Text('All added Points'),
          titleSpacing: 5,
        ),
        body: Container(
            margin: EdgeInsets.all(20),
            child: StreamBuilder<QuerySnapshot>(
                stream: walletStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                  // points = 0;
                  return Container(
                    child: ListView(
                      shrinkWrap: true,
                      primary: false,
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;

                            return Column(
                              children: [
                                if (data['isAdded'] &&
                                    !data['isConvertedToCredit'] &&
                                    !data['isReferred'] &&
                                    !data['isReturn'])
                                  Card(
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'OrderId',
                                                ),
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              Expanded(
                                                  child: Text(data['orderId']))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Order Amount',
                                                ),
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              Expanded(
                                                  child:
                                                      Text(data['orderAmount']))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Transaction Time',
                                                ),
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              Expanded(
                                                  child: Text(data['txTime']))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            onTap: () => _checkAlreadySendReturnRequest(context,data["orderId"],data["orderAmount"]),

                                            // onTap: () =>
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: primaryColors,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 40, vertical: 8),
                                              child: Text('Continue',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
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
                })));
  }
}
