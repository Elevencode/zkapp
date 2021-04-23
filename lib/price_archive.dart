import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'constants/product_list.dart';
import 'entities/instance.dart';

class PriceArchive extends StatefulWidget {
  @override
  _PriceArchiveState createState() => _PriceArchiveState();
}

class _PriceArchiveState extends State<PriceArchive> {
  Widget priceView;

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
              onPressed: () {
                if (dropdownValue != null)
                  setState(() {
                    showMaterialModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        height: 665,
                        child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: Text(
                                  '$dropdownValue',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              PriceArchiveView(),
                            ],
                          ),
                        ),
                      ),
                    );
                    priceView = PriceArchiveView();
                  });
              },
              child: Text(
                'Показать',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
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

DateTime selectedDate = DateTime.now();
DateFormat formatter = DateFormat('dd.MM.yyyy');
String formatted = formatter.format(selectedDate);

class _DatePickerState extends State<DatePicker> {
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

class PriceArchiveView extends StatefulWidget {
  @override
  _PriceArchiveViewState createState() => _PriceArchiveViewState();
}

class _PriceArchiveViewState extends State<PriceArchiveView> {
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
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          String formattedDateFrom =
              formatter.format(_instances[index].dateFrom);
          String formattedDateTo = formatter.format(_instances[index].dateTo);

          if (_instances[index].product == '$dropdownValue' &&
              _instances[index].isArchived == true &&
              !selectedDate.isBefore(_instances[index].dateFrom) &&
              !selectedDate.isAfter(_instances[index].dateTo)) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (_instances[index].dateFrom != null)
                      Text(
                        'Дата: $formattedDateFrom',
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
                        'Дата отгрузки: до $formattedDateTo',
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

              // child: Center(child: Text('Нет данных')),);
          }
          
        },
        itemCount: _instances.length,
      ),
    );
  }
}
