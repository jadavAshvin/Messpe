//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'dart:math';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:fiberchat/Configs/Dbpaths.dart';
import 'package:fiberchat/Screens/calling_screen/audio_call.dart';
import 'package:fiberchat/Screens/calling_screen/video_call.dart';
import 'package:fiberchat/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fiberchat/Models/call.dart';
import 'package:fiberchat/Models/call_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial(
      {String? fromUID,
      String? fromFullname,
      String? fromDp,
      String? toFullname,
      String? toDp,
      String? toUID,
      bool? isvideocall,
      required String? currentuseruid,
      context}) async {
    print('in dial' + fromUID.toString());
    print('in dial' + fromFullname.toString());
    print('in dial' + fromDp.toString());
    print('in dial' + toFullname.toString());
    print('in dial' + toDp.toString());
    print('in dial' + toUID.toString());

    final result = await FirebaseFirestore.instance
        .collection(DbPaths.collectionusers)
        .doc(fromUID)
        .get();

    if (result['credits'] <= 0) {
      print('in dial if');
      String call = isvideocall! ? 'video call' : 'audio call';
      Fiberchat.toast('Not enough credit to use ' + call);
      return;
    }
    print("in else");
    int timeepoch = DateTime.now().millisecondsSinceEpoch;
    Call call = Call(
        timeepoch: timeepoch,
        callerId: fromUID,
        callerName: fromFullname,
        callerPic: fromDp,
        receiverId: toUID,
        receiverName: toFullname,
        receiverPic: toDp,
        channelId: Random().nextInt(1000).toString(),
        isvideocall: isvideocall);
    ClientRole _role = ClientRole.Broadcaster;
    bool callMade = await callMethods.makeCall(
        call: call, isvideocall: isvideocall, timeepoch: timeepoch);

    call.hasDialled = true;
    if (isvideocall == false) {
      if (callMade) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AudioCall(
              currentuseruid: currentuseruid,
              call: call,
              channelName: call.channelId,
              role: _role,
            ),
          ),
        );
      }
    } else {
      if (callMade) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoCall(
              currentuseruid: currentuseruid,
              call: call,
              channelName: call.channelId,
              role: _role,
            ),
          ),
        );
      }
    }
  }
}
