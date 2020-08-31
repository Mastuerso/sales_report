import 'dart:convert';
import 'report_item.dart';

class SaleReport {
  ReportItem item;
  String customer;
  DateTime dateTime;
  int quantity;
  SaleReport({
    this.item,
    this.customer,
    this.dateTime,
    this.quantity,
  });

  double get total => quantity * item.price;

  SaleReport copyWith({
    ReportItem item,
    String customer,
    DateTime dateTime,
    int quantity,
  }) {
    return SaleReport(
      item: item ?? this.item,
      customer: customer ?? this.customer,
      dateTime: dateTime ?? this.dateTime,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item?.toMap(),
      'customer': customer,
      'dateTime': dateTime?.millisecondsSinceEpoch,
      'quantity': quantity,
    };
  }

  factory SaleReport.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SaleReport(
      item: ReportItem.fromMap(map['item']),
      customer: map['customer'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
      quantity: map['quantity'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SaleReport.fromJson(String source) =>
      SaleReport.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SaleReport(item: $item, customer: $customer, dateTime: $dateTime, quantity: $quantity)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SaleReport &&
        o.item == item &&
        o.customer == customer &&
        o.dateTime == dateTime &&
        o.quantity == quantity;
  }

  @override
  int get hashCode {
    return item.hashCode ^
        customer.hashCode ^
        dateTime.hashCode ^
        quantity.hashCode;
  }
}
