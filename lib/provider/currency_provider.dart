import 'package:currency_converter/currency.dart';
import 'package:currency_converter/currency_converter.dart';
import 'package:currency_converter_app/data/data.dart';
import 'package:currency_converter_app/model/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyNotifier extends ChangeNotifier {
  List<CurrencyC> get currencieslist => currencies;

  

  double _convertedAmount = 0.0;

  double get convertAmount => _convertedAmount;
  
  void convert(double amount, Currency currency, Currency newcurrency) async {
    //Currency myCurrency = await CurrencyConverter.getMyCurrency();
    var usdConvert = await CurrencyConverter.convert(
      from: currency,
      to: newcurrency,
      amount: amount,
    );
    _convertedAmount = usdConvert ?? 0.0;
    notifyListeners();
  }

}

final currencyProvider = ChangeNotifierProvider((ref){
  return CurrencyNotifier();
});