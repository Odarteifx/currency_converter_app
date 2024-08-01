import 'package:currency_converter/currency.dart';
import 'package:currency_converter/currency_converter.dart';
import 'package:currency_converter_app/data/data.dart';
import 'package:currency_converter_app/model/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyNotifier extends ChangeNotifier {
  List<CurrencyC> get currencieslist => currencies;

  Map<String, double> _convertedAmounts = {};
  Map<String, double> get convertedAmounts => _convertedAmounts;

  void convert(double amount, Currency fromcurrency) async {
    //Currency myCurrency = await CurrencyConverter.getMyCurrency();
    try {
      for (var currency in currencies) {
        var converted = await CurrencyConverter.convert(
          from: fromcurrency,
          to: currency.currency,
          amount: amount,
        );
        _convertedAmounts[currency.code] = converted ?? 0.0;
      }
    } catch (e) {
       // ignore: avoid_print
       print('Error converting currency: $e');
    }
    notifyListeners();
  }

  void addCurrency(String code, String name, Currency currency){
    currencieslist.add(CurrencyC(code: code, name: name, currency: currency));
    notifyListeners();
  }
}

final currencyProvider = ChangeNotifierProvider((ref) {
  return CurrencyNotifier();
});
