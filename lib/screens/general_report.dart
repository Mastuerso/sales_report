import 'package:flutter/material.dart';
import 'package:sales_report/db/db.dart';
import 'package:sales_report/docs/models/sale_report.dart';

class GeneralReport extends StatelessWidget {
  static String routeName = 'GeneralReport';
  const GeneralReport({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    sales.sort((a, b) => a.item.name.compareTo(b.item.name));
    return Scaffold(
      appBar: AppBar(
        title: Text('General Report'),
      ),
      body: ListView.builder(
        itemCount: salesCount,
        itemBuilder: (context, index) {
          SaleReport _saleReport = sales[index];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_saleReport.quantity.toString() + 'x'),
              Text(_saleReport.item.name),
              Text(_saleReport.item.price.toString()),
              Text(_saleReport.customer),
            ],
          );
        },
      ),
    );
  }
}
