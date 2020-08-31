import 'package:flutter/material.dart';
import 'package:sales_report/db/db.dart';
import 'package:sales_report/docs/models/sale_report.dart';
// import 'package:sales_report/docs/models/sale_report.dart';

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

  @override
  void initState() {
    super.initState();
    // dropdownCustomers = generateDropCustomers(context);
    // dropdownDates = generateDropDates(context);
  }

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
            ],
          ),
          buildSale(customer: customersValue, date: datesValue),
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
      return Text('$customer @ $date with ${customerSales.length}');
    } else if (customer != '' && date == DateTime(0)) {
      List<SaleReport> customerSales = List<SaleReport>.from(
          sales.where((element) => element.customer == customer));

      print(customerSales.length);
      return Text('$customer with ${customerSales.length}');
    } else if (customer == '' && date != DateTime(0)) {
      List<SaleReport> customerSales = List<SaleReport>.from(
          sales.where((element) => element.dateTime == date));

      print(customerSales.length);
      return Text('$date with ${customerSales.length}');
    }
    return Container();
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

    List<DropdownMenuItem<DateTime>> dropList = [
      DropdownMenuItem(
        child: Text('---'),
        value: DateTime(0),
      )
    ];

    uniqueDates.forEach((element) {
      dropList.add(
        DropdownMenuItem(
          value: element,
          child: Text(
            '${element.year}/${element.month}/${element.day} -- ${element.hour}:${element.minute}',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: keysWithDates[key].contains(element)
                      ? Colors.green
                      : Colors.red,
                ),
          ),
        ),
      );
    });

    // keysWithDates.forEach((customer, dateList) {
    //   dateList.forEach((element) {
    //     dropList.add(
    //       DropdownMenuItem(
    //         value: element,
    //         child: Text(
    //           '${element.year}/${element.month}/${element.day} -- ${element.hour}:${element.minute}',
    //           style: Theme.of(context).textTheme.bodyText1.copyWith(
    //                 color: customer == key ? Colors.green : Colors.red,
    //               ),
    //         ),
    //       ),
    //     );
    //   });
    // });

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
      )
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
