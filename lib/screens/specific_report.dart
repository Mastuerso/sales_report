import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';

import 'package:sales_report/db/db.dart';
import 'package:sales_report/docs/models/sale_report.dart';
import 'package:sales_report/screens/utils/save_image_helper.dart';

class SpecificReport extends StatefulWidget {
  static String routeName = 'SpecificReport';
  const SpecificReport({Key key}) : super(key: key);

  @override
  _SpecificReportState createState() => _SpecificReportState();
}

class _SpecificReportState extends State<SpecificReport> {
  List<DropdownMenuItem<DateTime>> dropdownDates;
  List<DropdownMenuItem<String>> dropdownCustomers;
  String customersValue = '';
  DateTime datesValue = DateTime(0);
  GlobalKey toPrint = GlobalKey();

  @override
  Widget build(BuildContext context) {
    dropdownDates = generateDropDates(context, key: customersValue);
    dropdownCustomers = generateDropCustomers(context, date: datesValue);

    return Scaffold(
      appBar: AppBar(
        title: Text('Specific Report'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Customers
              DropdownButton(
                value: customersValue,
                items: dropdownCustomers,
                onChanged: (String value) {
                  setState(() {
                    customersValue = value;
                  });
                },
              ),
              // Dates
              DropdownButton(
                value: datesValue,
                items: dropdownDates,
                onChanged: (DateTime value) {
                  setState(() {
                    datesValue = value;
                  });
                },
              ),
              // Screenshot
              IconButton(
                icon: Icon(Icons.camera_roll),
                onPressed: () async => await screenshot(
                  toPrint.currentContext.findRenderObject(),
                  onSuccess: () => showToast(
                    'Success',
                    backgroundColor: Colors.green.withOpacity(0.7),
                    radius: 13,
                  ),
                  onError: () => showToast(
                    'Failled',
                    backgroundColor: Colors.amber.withOpacity(0.7),
                    radius: 13,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: RepaintBoundary(
              key: toPrint,
              child: buildSale(customer: customersValue, date: datesValue),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSale({String customer, DateTime date}) {
    if (customer != '' && date != DateTime(0)) {
      List<SaleReport> customerSales = List<SaleReport>.from(sales.where(
          (element) =>
              element.customer == customer && element.dateTime == date));

      // print(customerSales.length);
      return buildItemList(customerSales);
    } else if (customer != '' && date == DateTime(0)) {
      List<SaleReport> customerSales = List<SaleReport>.from(
          sales.where((element) => element.customer == customer));

      // print(customerSales.length);
      // return Text('$customer with ${customerSales.length}');
      return buildItemList(customerSales);
    } else if (customer == '' && date != DateTime(0)) {
      List<SaleReport> customerSales = List<SaleReport>.from(
          sales.where((element) => element.dateTime == date));

      // print(customerSales.length);
      // return Text('$date with ${customerSales.length}');
      return buildItemList(customerSales);
    }
    return Center(
      child: Text('---'),
    );
  }

  Widget buildItemList(List<SaleReport> customerSales) {
    double total = 0;
    customerSales.forEach((element) {
      total += element.total;
    });
    double dividerTotalWidth = total.toString().length * 16.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Table(
            columnWidths: {
              0: FractionColumnWidth(0.10),
              1: FractionColumnWidth(0.90),
            },
            children: List.generate(
              customerSales.length,
              (index) {
                return TableRow(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        customerSales[index].quantity.toString(),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Text(
                            'x   ' + customerSales[index].item.name,
                            textAlign: TextAlign.left,
                          ),
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Container(
                                height: 1,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          Text(
                            NumberFormat.simpleCurrency()
                                .format(customerSales[index].total),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            height: 2.0,
            // width: MediaQuery.of(context).size.width * 0.35,
            width: dividerTotalWidth,
            color: Colors.blue[800],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              NumberFormat.simpleCurrency().format(total),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<DateTime>> generateDropDates(BuildContext context,
      {String key}) {
    List<String> listOfKeys =
        List<String>.generate(sales.length, (index) => sales[index].customer);

    List<String> uniqueKeys = listOfKeys.toSet().toList();
    List<DateTime> listOfDates =
        List<DateTime>.generate(sales.length, (index) => sales[index].dateTime);
    List<DateTime> uniqueDates = listOfDates.toSet().toList();
    uniqueDates.sort();
    Map<String, List<DateTime>> keysWithDates = {};
    uniqueKeys.forEach((String key) {
      List<DateTime> datesInKey = [];
      sales.forEach((SaleReport sale) {
        if (key == sale.customer) {
          datesInKey.add(sale.dateTime);
        }
        if (datesInKey.length > 0) {
          datesInKey.sort();
          keysWithDates.addAll({key: datesInKey});
        }
      });
    });
    // keysWithDates is very important
    // print(keysWithDates);

    List<DropdownMenuItem<DateTime>> dropList = [
      DropdownMenuItem(
        child: Text('---'),
        value: DateTime(0),
      ),
    ];

    // print(uniqueDates);

    uniqueDates.forEach((element) {
      dropList.add(
        DropdownMenuItem(
          value: element,
          child: Text(
            '${element.year}/${element.month}/${element.day} -- ${element.hour}:${element.minute}',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: key != ''
                      ? keysWithDates[key].contains(element)
                          ? Colors.green
                          : Colors.red
                      : Colors.amber,
                ),
          ),
        ),
      );
    });

    return dropList;
  }

  List<DropdownMenuItem<String>> generateDropCustomers(BuildContext context,
      {DateTime date}) {
    List<String> listOfKeys =
        List<String>.generate(sales.length, (index) => sales[index].customer);

    List<String> uniqueKeys = listOfKeys.toSet().toList();
    Map<String, List<DateTime>> keysWithDates = {};
    uniqueKeys.forEach((String key) {
      List<DateTime> datesInKey = [];
      sales.forEach((SaleReport sale) {
        if (key == sale.customer) {
          datesInKey.add(sale.dateTime);
        }
        if (datesInKey.length > 0) {
          datesInKey.sort();
          keysWithDates.addAll({key: datesInKey});
        }
      });
    });
    // keysWithDates is very important

    List<DropdownMenuItem<String>> dropList = [
      DropdownMenuItem(
        child: Text('---'),
        value: '',
      ),
    ];

    keysWithDates.forEach((customer, dateList) {
      dropList.add(
        DropdownMenuItem(
          value: customer,
          child: Text(
            customer,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: dateList.contains(date) ? Colors.green : Colors.red,
                ),
          ),
        ),
      );
    });

    dropList.sort((a, b) => a.value.compareTo(b.value));

    return dropList;
  }
}
