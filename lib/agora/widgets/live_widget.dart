import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LiveAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromRGBO(35, 36, 35, 0.500),
        padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RiveAnimation.network(
           'https://rive.app/community/7280-14001-live-in-red/',
           fit: BoxFit.contain,
             
          ),
          Image.asset(
            'assets/live.png',
            fit: BoxFit.contain,
            width: 50,
            height: 50,

          ),
        ],
      ),
    );
  }
}
