import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'entities/instance.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
              Container(),
            ],
          ),
        ),
      ),
      title: 'ZK App',
      initialRoute: '/',
      routes: {
        // '/': (context) => HomePage(),
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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
      // appBar: AppBar(
      //   title: Text('ЗК "Оренбургский колос"'),
      // ),
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
    // );
  }
}

class SecondScreen extends StatefulWidget {
  final String name;

  SecondScreen({this.name});

  @override
  _SecondScreen createState() => _SecondScreen();
}

class _SecondScreen extends State<SecondScreen> {
  List<Instance> _instances = List<Instance>();

  Future fetchInstances() async {
    var url = 'https://orenkolos.ru/api/instances/?format=json';
    var response = await http.get(url);

    var instances = List<Instance>();

    if (response.statusCode == 200) {
      var instancesJson = json.decode(utf8.decode(response.bodyBytes));
      for (var instanceJson in instancesJson) {
        instances.add(Instance.fromJson(instanceJson));
      }
    }
    return instances;
  }

  void initState() {
    fetchInstances().then((value) {
      setState(() {
        _instances.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.name}'),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            if (_instances[index].product == '${widget.name}') {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text(
                      //   _instances[index].product,
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //   ),
                      // ),
                      Text(
                        'Склад: ${_instances[index].storage}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Цена: ${_instances[index].price} руб.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _instances[index].description,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
          itemCount: _instances.length,
        ));
  }
}

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
