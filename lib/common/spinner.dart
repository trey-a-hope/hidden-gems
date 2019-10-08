import 'package:flutter/material.dart';

class Spinner extends StatefulWidget {
  @override
  State createState() => SpinnerState();
}

class SpinnerState extends State<Spinner> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: Colors.black,
            strokeWidth: 3.0,
          ),
          SizedBox(height: 20),
          Text(
            'Loading',
            style: TextStyle(fontSize: 15.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
