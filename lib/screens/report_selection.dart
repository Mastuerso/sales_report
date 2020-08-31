import 'package:flutter/material.dart';
import 'package:sales_report/screens/general_report.dart';
import 'package:sales_report/screens/specific_report.dart';

class ReportSelection extends StatelessWidget {
  static String routeName = '/';
  const ReportSelection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Selection'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: () =>
                Navigator.pushNamed(context, GeneralReport.routeName),
            child: Text('General Report'),
          ),
          Divider(),
          RaisedButton(
            onPressed: () =>
                Navigator.pushNamed(context, SpecificReport.routeName),
            child: Text('Specific Report'),
          ),
        ],
      ),
    );
  }
}
