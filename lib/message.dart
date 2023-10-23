// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';

Future showMessage(BuildContext context, String msg) async {
  final snackBar = SnackBar(
    content: Text(msg),
    duration: Duration(seconds: 5),
    action: SnackBarAction(
        label: "Close",
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          // scaffoldKey.currentState?.hideCurrentSnackBar();
        }),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // scaffoldKey.currentState?.showSnackBar(snackBar);
}

Widget snakebar(GlobalKey<ScaffoldMessengerState> scaffoldKey, String msg) {
  return SnackBar(
    content: Text(msg),
    duration: Duration(seconds: 5),
    action: SnackBarAction(
        label: "Close",
        onPressed: () {
          // ScaffoldMessenger.of(context).hideCurrentSnackBar();
          scaffoldKey.currentState?.hideCurrentSnackBar();
        }),
  );
}
