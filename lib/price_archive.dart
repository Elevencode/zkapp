import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'constants/product_list.dart';

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