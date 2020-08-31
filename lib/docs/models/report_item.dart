import 'dart:convert';

class ReportItem {
  String name;
  double price;
  ReportItem({
    this.name,
    this.price,
  });

  ReportItem copyWith({
    String name,
    double price,
  }) {
    return ReportItem(
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }

  factory ReportItem.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ReportItem(
      name: map['name'],
      price: map['price'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportItem.fromJson(String source) =>
      ReportItem.fromMap(json.decode(source));

  @override
  String toString() => 'ReportItem(name: $name, price: $price)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ReportItem && o.name == name && o.price == price;
  }

  @override
  int get hashCode => name.hashCode ^ price.hashCode;
}
