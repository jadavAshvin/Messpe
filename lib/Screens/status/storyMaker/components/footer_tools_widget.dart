import 'package:fiberchat/Configs/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../extensions/context_extension.dart';

class FooterToolsWidget extends StatelessWidget {
  final AsyncCallback onDone;
  final Widget? doneButtonChild;

  const FooterToolsWidget({
    Key? key,
    required this.onDone,
    this.doneButtonChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.bottomPadding + kToolbarHeight,
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 36,
              child: ElevatedButton(

                onPressed: onDone,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                    ),
                  ),
                  shadowColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.all(primaryColors),
                ),
                child: doneButtonChild ??
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: const [
                            SizedBox(width: 4),
                            Text(
                              'Done',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              CupertinoIcons.forward,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
