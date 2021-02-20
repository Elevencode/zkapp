import 'package:flutter/material.dart';

class ButtonGenerator extends StatelessWidget {
  final String name;
  final String path;

  ButtonGenerator({this.name, this.path});
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Text(
        '$name',
        style: TextStyle(
          // color: Colors.white,
          fontSize: 20,
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '$path');
      },
      // color: Colors.yellow[700],
    );
  }
}
