import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_report/db/db.dart';
import 'package:sales_report/docs/models/sale_report.dart';
import 'package:permission_handler/permission_handler.dart';

class GeneralReport extends StatefulWidget {
  static String routeName = 'GeneralReport';
  const GeneralReport({Key key}) : super(key: key);

  @override
  _GeneralReportState createState() => _GeneralReportState();
}

class _GeneralReportState extends State<GeneralReport> {
  DateTimeRange _dateTimeRange;
  @override
  Widget build(BuildContext context) {
    List<SaleReport> salesToshow;
    sales.toSet().toList();
    if (_dateTimeRange != null) {
      salesToshow = sales
          .where((element) =>
              element.dateTime.millisecondsSinceEpoch >=
                  _dateTimeRange.start.millisecondsSinceEpoch &&
              element.dateTime.millisecondsSinceEpoch <=
                  _dateTimeRange.end.millisecondsSinceEpoch)
          .toList();
    } else {
      salesToshow = sales;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('General Report'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                onPressed: () async {
                  _dateTimeRange = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(DateTime.now().year),
                    lastDate: DateTime.now(),
                  );
                  setState(() {});
                },
                child: Text('Select an interval of time'),
              ),
              RaisedButton(
                onPressed: () async {
                  await saveCsvToFile(salesToshow);
                },
                child: Text('Export CSV'),
                color: Colors.green,
              ),
            ],
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: salesToshow.length,
              itemBuilder: (context, index) {
                SaleReport _saleReport = salesToshow[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_saleReport.quantity.toString() + 'x'),
                    Text(_saleReport.item.name),
                    Text(_saleReport.item.price.toString()),
                    Text(_saleReport.dateTime.month.toString()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future saveCsvToFile(List<SaleReport> salesToshow) async {
    if (await Permission.storage.request().isGranted) {
      String csv = salesReportToCsv(salesToshow);
      print(csv);
      final filePath = await FilePicker.getDirectoryPath();
      File file = File('$filePath/gereralReport.csv');
      file.writeAsString(csv);
    }
  }

  String salesReportToCsv(List<SaleReport> salesToshow) {
    List<List<dynamic>> salesInListForm = [
      [
        'Name',
        'Quantity',
        'Price/u',
        'subTotal',
        'Customer',
        'Date(millisecondsSinceEpoch)'
      ]
    ];
    salesToshow.forEach((element) {
      salesInListForm.add(element.toList());
    });

    String csv = const ListToCsvConverter().convert(salesInListForm);
    return csv;
  }
}
