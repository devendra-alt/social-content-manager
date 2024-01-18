import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserCountWidget extends ConsumerStatefulWidget {
  const UserCountWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UserCountWidgetState();
  }
}

class _UserCountWidgetState extends ConsumerState<UserCountWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(35, 36, 35, 0.500),
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/eye.png',
            fit: BoxFit.contain,
            height: 20,
            width: 20,
          ),
          Text("15"),
        ],
      ),
    );
  }
}
