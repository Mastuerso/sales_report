import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sales_report/screens/general_report.dart';
import 'package:sales_report/screens/report_selection.dart';
import 'package:sales_report/screens/specific_report.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        theme: ThemeData.dark(),
        title: 'Sales Report',
        initialRoute: '/',
        routes: {
          ReportSelection.routeName: (context) => ReportSelection(),
          GeneralReport.routeName: (context) => GeneralReport(),
          SpecificReport.routeName: (context) => SpecificReport(),
        },
      ),
    );
  }
}
