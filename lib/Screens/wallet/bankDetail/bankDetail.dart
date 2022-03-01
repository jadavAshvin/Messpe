import 'package:awesome_card/awesome_card.dart';
import 'package:fiberchat/Configs/app_constants.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';
class BankDetail extends StatefulWidget {
  const BankDetail({Key? key}) : super(key: key);

  @override
  _BankDetailState createState() => _BankDetailState();
}

class _BankDetailState extends State<BankDetail> {
  String cardNumber = '';
  String cardHolderName = '';
  String expiryDate = '';
  String cvv = '';
  bool showBack = false;
  String month = "";
  String year = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  late FocusNode _focusNode;
  TextEditingController cardNumberCtrl = TextEditingController();
  TextEditingController expiryFieldCtrl = TextEditingController();

  TextEditingController monthFieldCtrl = TextEditingController();
  TextEditingController yearFieldCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? showBack = true : showBack = false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }


  void showInSnackBar(String value) {
    _scaffoldKey.currentState!.showSnackBar(new SnackBar(content: new Text(value)));
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: _scaffoldKey,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            CreditCard(
              cardNumber: cardNumber,
              cardExpiry: expiryDate,
              cardHolderName: cardHolderName,
              cvv: cvv,
              // bankName: 'Axis Bank',
              showBackSide: showBack,
              frontBackground: CardBackgrounds.black,
              backBackground: CardBackgrounds.white,
              showShadow: true,
              // mask: getCardTypeMask(cardType: CardType.americanExpress),
            ),
            SizedBox(
              height: 40,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(

                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Card(
                    child: TextFormField(
                      controller: cardNumberCtrl,
                      decoration:InputDecoration(

                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                        hintText: 'Card Number',
                        // prefixIcon: ,
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,

                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1, color: primaryColors),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      // maxLength: 16,
                      onChanged: (value) {
                        final newCardNumber = value.trim();
                        var newStr = '';
                        final step = 4;

                        for (var i = 0; i < newCardNumber.length; i += step) {
                          newStr += newCardNumber.substring(
                              i, math.min(i + step, newCardNumber.length));
                          if (i + step < newCardNumber.length) newStr += ' ';
                        }

                        setState(() {
                          if(newStr.length <= 19){
                            cardNumber = newStr;
                          }
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Card(
                    child: TextFormField(
                      decoration:InputDecoration(

                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                        hintText: 'Cardholder Name',
                        // prefixIcon: ,
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,

                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1, color: primaryColors),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),onChanged: (value) {
                        setState(() {
                          cardHolderName = value;
                        });
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,

                      ),
                      padding: EdgeInsets.all(10),
                      child: Card(
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: monthFieldCtrl,
                          decoration: InputDecoration(

                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                            hintText: 'MM',

                            // prefixIcon: ,
                            hintStyle: TextStyle(

                              color: Colors.grey.shade600,),
                            border: InputBorder.none,

                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1, color: primaryColors),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          // maxLength: 5,
                          onChanged: (value) {

                            var newDateValue = value.trim();
                            if( int.parse(newDateValue) < 13){

                              month = newDateValue;

                              if(monthFieldCtrl.text.length > 2){

                                monthFieldCtrl.text = newDateValue.substring(0,2);
                                newDateValue = newDateValue.substring(0,2);
                              }
                              // final isPressingBackspace =
                              //     expiryDate.length > newDateValue.length;
                              // final containsSlash = newDateValue.contains('/');
                              //
                              // if (newDateValue.length >= 2 &&
                              //     !containsSlash &&
                              //     !isPressingBackspace) {
                              //   newDateValue = newDateValue.substring(0, 2) +
                              //       '/' +
                              //       newDateValue.substring(2);
                              // }
                              setState(() {

                                if(newDateValue.length <= 2){
                                  month = newDateValue;

                                  // monthFieldCtrl.text = newDateValue;
                                  expiryFieldCtrl.text =   newDateValue;
                                  expiryFieldCtrl.selection = TextSelection.fromPosition(
                                      TextPosition(offset: newDateValue.length));

                                  expiryDate = newDateValue;
                                  if(year.isNotEmpty) {
                                    expiryFieldCtrl.text+="/"+year;
                                    expiryDate+="/"+year;
                                  }
                                }

                              }
                              );
                            }else{
                              showInSnackBar("month can't be more than 12 ");
                            }

                          },
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,

                      ),
                      padding: EdgeInsets.all(10),
                      child: Card(
                        child: TextFormField(

                          decoration: InputDecoration(

                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                            hintText: 'YY',

                            // prefixIcon: ,
                            hintStyle: TextStyle(

                              color: Colors.grey.shade600,),
                            border: InputBorder.none,

                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1, color: primaryColors),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          // maxLength: 5,
                          controller:yearFieldCtrl,
                          onChanged: (value) {
                            var newDateValue = value.trim();


                            if(yearFieldCtrl.text.length > 2){

                              yearFieldCtrl.text = newDateValue.substring(0,2);
                              newDateValue = newDateValue.substring(0,2);
                            }
                            setState(() {
                              if(newDateValue.length <= 2){
                                year = newDateValue;
                               // yearFieldCtrl.text = newDateValue;
                                expiryFieldCtrl.text = expiryFieldCtrl.text + '/'+newDateValue;
                                expiryFieldCtrl.selection = TextSelection.fromPosition(
                                    TextPosition(offset: newDateValue.length));
                                expiryDate = month + '/'+newDateValue;
                              }
                            }
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(

                        width: 100,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Card(
                          child: TextFormField(
                            decoration: InputDecoration(

                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                              hintText: 'CVV',

                              // prefixIcon: ,
                              hintStyle: TextStyle(

                                color: Colors.grey.shade600,),
                              border: InputBorder.none,

                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1, color: primaryColors),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {

                                cvv = value;
                              });
                            },
                            focusNode: _focusNode,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 20,),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      // showDialog(context: context, builder: (BuildContext context) => confirmDialog);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: primaryColors,
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                      EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                      child: Text('Pay Now', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
