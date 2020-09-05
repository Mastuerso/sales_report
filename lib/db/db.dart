import 'dart:math';

import 'package:sales_report/docs/models/report_item.dart';

import '../docs/models/sale_report.dart';
import 'package:mock_data/mock_data.dart';

Random rng = Random();
int itemCount = 12;
int clientCount = 6;
int maxItemQty = 30;
int salesCount = 36;
int saleDays = 3;

List<SaleReport> sales = List<SaleReport>.generate(
  salesCount,
  (index) => SaleReport(
    customer: clients[rng.nextInt(clientCount)],
    dateTime: dates[rng.nextInt(saleDays)],
    item: catalog[rng.nextInt(itemCount)],
    quantity: rng.nextInt(maxItemQty),
  ),
);

List<ReportItem> catalog = List<ReportItem>.generate(
    itemCount,
    (index) => ReportItem(
          name: mockName('female') + ' doll',
          price: _calculatePrice(),
        ));

double _calculatePrice() {
  int dividend = rng.nextInt(16).clamp(1, 15);
  int divisor = rng.nextInt(16).clamp(1, 15);
  double quotient = dividend / divisor;
  return (quotient * 10).truncateToDouble();
}

List<String> clients =
    List<String>.generate(clientCount, (index) => mockName());

List<DateTime> dates = List<DateTime>.generate(
    saleDays,
    (index) => mockDate(
          DateTime(2020, 1, 1),
        ));
