import 'package:flutter/material.dart';
import 'package:zk_app/price_archive.dart';
import 'package:zk_app/second_screen.dart';

import 'home_page.dart';

class ZkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green[300],
            leading: Icon(Icons.local_florist, size: 30.0),
            title: Text(
              'ЗК "ОРЕНБУРГСКИЙ КОЛОС"',
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: 'ЦЕНЫ'),
                Tab(text: 'АРХИВ'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              HomePage(),
              PriceArchive(),
            ],
          ),
        ),
      ),
      title: 'ZK App',
      initialRoute: '/',
      routes: {
        '/sunflower': (context) => SecondScreen(name: 'Подсолнечник'),
        '/wheat_5': (context) => SecondScreen(name: 'Пшеница 5 класс'),
        '/wheat_4': (context) => SecondScreen(name: 'Пшеница 4 класс'),
        '/wheat_3': (context) => SecondScreen(name: 'Пшеница 3 класс'),
        '/rye': (context) => SecondScreen(name: 'Рожь'),
        '/barley': (context) => SecondScreen(name: 'Ячмень'),
        '/buckwheat': (context) => SecondScreen(name: 'Гречиха'),
      },
      theme: ThemeData(
        fontFamily: 'Oswald',
        primarySwatch: Colors.green,
        buttonTheme: ButtonThemeData(
          minWidth: double.infinity,
          height: 60,
        ),
      ),
    );
  }
}