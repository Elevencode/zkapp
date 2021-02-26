import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'entities/instance.dart';
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
            if (_instances[index].product == '${widget.name}' && _instances[index].isArchived == false) {
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