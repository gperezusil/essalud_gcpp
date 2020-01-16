import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class Metodos{
  num verificarNumero(num numero) {
    if (1 - numero < 0) {
      return 0.99;
    } else {
      return numero;
    }
  }

    FlutterMoneyFormatter formatearNumero(double variable) {
    return FlutterMoneyFormatter(amount: variable.toDouble());
  }
}