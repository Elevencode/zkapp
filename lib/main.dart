import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'buttongenerator.dart';
import 'entities/instance.dart';

void main() => runApp(MyApp());

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

class PriceArchive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: <Widget>[
            ProductDropDown(),
            SizedBox(
              height: 50,
            ),
            DatePicker(),
            SizedBox(
              height: 50,
            ),
            FlatButton(
              color: Colors.green[300],
              onPressed: () {},
              child: Text(
                'Показать',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProductDropDown extends StatefulWidget {
  @override
  _ProductDropDownState createState() => _ProductDropDownState();
}

String dropdownValue;
List<String> productList = [
  'Подсолнечник',
  'Пшеница 5 класс',
  'Пшеница 4 класс',
  'Пшеница 3 класс',
  'Рожь 1 класс',
  'Рожь 2 класс',
  'Гречиха',
  'Ячмень',
  'Просо',
  'Рыжик',
];

class _ProductDropDownState extends State<ProductDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: true,
      value: dropdownValue,
      hint: Text('Культура'),
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
      underline: Container(
        height: 2,
        color: Colors.green[300],
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: productList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class DatePicker extends StatefulWidget {
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime selectedDate = DateTime.now();
  DateFormat formatter = DateFormat('dd.MM.yyyy');

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    String formatted = formatter.format(selectedDate);

    return Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Expanded(
        child: Text(
          '$formatted',
          style: TextStyle(fontSize: 18),
        ),
      ),
      Expanded(
        child: RaisedButton(
          onPressed: () => _selectDate(context),
          child: Text(
            'Выбрать дату',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          color: Colors.green[300],
        ),
      )
    ]);
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
                      if (_instances[index].dateFrom != null)
                        Text(
                          'Дата: ${_instances[index].dateFrom}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                      if (_instances[index].dateTo != null)
                        Text(
                          'Дата отгрузки: до ${_instances[index].dateTo}',
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
