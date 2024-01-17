import 'package:intl/intl.dart';

extension NumberParsing on double {
  String asMoney({int decimal = 3}) {
    var f = NumberFormat.compactCurrency(
      symbol: "\$",
      decimalDigits: decimal,
    );

    return f.format(this);
  }

  String digit({int decimal = 3}) {
    var f = NumberFormat.currency(
      symbol: "",
      decimalDigits: decimal,
    );

    return f.format(this);
  }
}
