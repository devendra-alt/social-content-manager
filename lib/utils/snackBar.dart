import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.grey,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    EdgeInsetsGeometry margin = const EdgeInsets.all(10.0),
  }) {
    final snackBar = SnackBar(
      content: Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: backgroundColor,
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
