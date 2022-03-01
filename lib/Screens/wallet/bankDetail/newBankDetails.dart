import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiberchat/Configs/Dbkeys.dart';
import 'package:fiberchat/Configs/Dbpaths.dart';
import 'package:fiberchat/Configs/app_constants.dart';
import 'package:fiberchat/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewBankDetails extends StatefulWidget {
  final orderId;
  final orderAmount;
  final phoneNo;
  final isCredits;
  const NewBankDetails({Key? key,  this.orderId, required this.phoneNo, this.orderAmount,this.isCredits})
      : super(key: key);

  @override
  _NewBankDetailsState createState() => _NewBankDetailsState();
}

class _NewBankDetailsState extends State<NewBankDetails> {
  TextEditingController accountName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController accountReNumber = TextEditingController();
  TextEditingController accountIFSCCOde = TextEditingController();
  TextEditingController accountBranchName = TextEditingController();
  TextEditingController accountPoints = TextEditingController();
  TextEditingController credits = TextEditingController();

  final _form = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int points = 0;

  void _submit(context) async {
    points = 0;
    if (accountName.text.isNotEmpty &&
        accountNumber.text.isNotEmpty &&
        accountIFSCCOde.text.isNotEmpty &&
        accountBranchName.text.isNotEmpty) {
      if (accountNumber.text == accountReNumber.text) {
        if(!widget.isCredits){
          await FirebaseFirestore.instance
              .collection(DbPaths.collectionusers)
              .doc(widget.phoneNo)
              .collection('wallet')
              .doc(widget.orderId)
              .set({
            'returnType' : 'Points',
            'returnStatus': 'PENDING',
            'returnAmount' : widget.orderAmount,
            'bankDetails' : {
              'AccountHolderName': accountName.text.trim(),
              'AccountNumber': accountNumber.text.trim(),
              'AccountIFSCCode': accountIFSCCOde.text.trim(),
              'AccountBranchName': accountBranchName.text.trim(),
            }
          }, SetOptions(merge: true)).then((value) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();

            Navigator.of(context).pop();
            Fiberchat.toast('Your return request sent successfully');
          }).catchError((error){
            Navigator.of(context).pop();
            Navigator.of(context).pop();

            Navigator.of(context).pop();
            Fiberchat.toast('Failed to sent return request');
          });
        }


        final result2 = await FirebaseFirestore.instance
            .collection(DbPaths.collectionusers)
            .where(Dbkeys.id, isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
        final documents = result2.docs;
        final credits = double.parse(documents[0]
        ['credits'].toString());
        if(credits < double.parse(this.credits.text.trim())){
          print('Not enough points');
          Fiberchat.toast('Not enough credits to return');
        }
        else{
          final orderId = DateTime.now().millisecondsSinceEpoch.toString();
          await FirebaseFirestore.instance
              .collection(DbPaths.collectionusers)
              .doc(widget.phoneNo)
              .collection('creditsReturn')
              .doc(orderId).set({
            'returnType' : 'Credits',
            'id' : orderId,
            'date' : DateTime.now().toIso8601String(),
            'returnStatus': 'PENDING',
            'returnCredits' : this.credits.text,
            'returnAmount' : (double.parse(this.credits.text.toString()) /10),
            'bankDetails' : {
              'AccountHolderName': accountName.text.trim(),
              'AccountNumber': accountNumber.text.trim(),
              'AccountIFSCCode': accountIFSCCOde.text.trim(),
              'AccountBranchName': accountBranchName.text.trim(),
            }
          }).then((value) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();

            Fiberchat.toast('Your return request sent successfully');
          }).catchError((error){
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Fiberchat.toast('Failed to sent return request');
          });
          print('Welcome');
        }

        print('Account' + accountNumber.text);
      } else {
        Fiberchat.toast('Account number and retype account number not match');
      }
    } else {
      Fiberchat.toast('All Fields are required');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Bank Details'),
        titleSpacing: 5,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: _form,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 40,
                  width: 300,
                  child: TextFormField(
                    cursorColor: primaryColors,
                    controller: accountName,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      hintText: 'Enter Account holder name',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: FaIcon(
                          FontAwesomeIcons.user,
                          color: primaryColors,
                        ),
                      ),
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
                  height: 20,
                ),
                Container(
                  height: 40,
                  width: 300,
                  child: TextFormField(
                    cursorColor: primaryColors,
                    controller: accountNumber,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,

                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      hintText: 'Enter Account number',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: FaIcon(
                          FontAwesomeIcons.university,
                          color: primaryColors,
                        ),
                      ),
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
                  height: 20,
                ),
                Container(
                  height: 40,
                  width: 300,
                  child: TextFormField(
                    cursorColor: primaryColors,
                    controller: accountReNumber,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,

                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      hintText: 'retype Account number',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: FaIcon(
                          FontAwesomeIcons.check,
                          color: primaryColors,
                        ),
                      ),
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
                  height: 20,
                ),
                Container(
                  height: 40,
                  width: 300,
                  child: TextFormField(
                    cursorColor: primaryColors,
                    controller: accountIFSCCOde,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      hintText: 'IFSC Code',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: FaIcon(
                          FontAwesomeIcons.creditCard,
                          color: primaryColors,
                        ),
                      ),
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
                  height: 20,
                ),
                Container(
                  height: 40,
                  width: 300,
                  child: TextFormField(
                    cursorColor: primaryColors,
                    controller: accountBranchName,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      hintText: 'Branch Name',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: FaIcon(
                          FontAwesomeIcons.home,
                          color: primaryColors,
                        ),
                      ),
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
                SizedBox(height: 20,),
                if(widget.isCredits)Container(
                  height: 40,
                  width: 300,
                  child: TextFormField(
                    cursorColor: primaryColors,
                    controller: credits,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      hintText: 'Credits',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: FaIcon(
                          FontAwesomeIcons.creditCard,
                          color: primaryColors,
                        ),
                      ),
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
                  onTap: () => _submit(context),
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
      ),
    );
  }
}
