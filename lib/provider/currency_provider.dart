import 'package:currency_converter/currency.dart';
import 'package:currency_converter/currency_converter.dart';
import 'package:currency_converter_app/model/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyNotifier extends ChangeNotifier {
  List<CurrencyC> currencies = [];
  double _convertedAmount = 0.0;
  
  void convert(double amount) async {
    Currency myCurrency = await CurrencyConverter.getMyCurrency();
    var usdConvert = await CurrencyConverter.convert(
      from: Currency.btc,
      to: myCurrency,
      amount: amount,
    );
    _convertedAmount = usdConvert ?? 0.0;
    notifyListeners();
  }

}

final currencyProvider = ChangeNotifierProvider((ref){
  CurrencyNotifier;
});