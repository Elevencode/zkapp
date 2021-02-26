import 'package:flutter/material.dart';

import 'button_generator.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: Center(
        child: Column(
          children: <Widget>[
            ButtonGenerator(name: 'Подсолнечник', path: '/sunflower'),
            SizedBox(
              height: 10.0,
            ),
            ButtonGenerator(name: 'Пшеница 5 класс', path: '/wheat_5'),
            SizedBox(
              height: 10.0,
            ),
            ButtonGenerator(name: 'Пшеница 4 класс', path: '/wheat_4'),
            SizedBox(
              height: 10.0,
            ),
            ButtonGenerator(name: 'Пшеница 3 класс', path: '/wheat_3'),
            SizedBox(
              height: 10.0,
            ),
            ButtonGenerator(name: 'Рожь', path: '/rye'),
            SizedBox(
              height: 10.0,
            ),
            ButtonGenerator(name: 'Ячмень', path: '/barley'),
            SizedBox(
              height: 10.0,
            ),
            ButtonGenerator(name: 'Гречиха', path: '/buckwheat'),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}