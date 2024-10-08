import 'package:currency_converter/currency.dart';
import 'package:currency_converter_app/provider/currency_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late TextEditingController inputController;
  bool edit = false;

  @override
  void initState() {
    super.initState();
    inputController = TextEditingController();
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyNotifier = ref.watch(currencyProvider);
    final currencies = currencyNotifier.currencieslist;
    final convertedAmounts = currencyNotifier.convertedAmounts;
    Currency convertCurrency = currencyNotifier.convertCurrency;
    String convertCurrencyText =
        convertCurrency.toString().split('.').last.toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Converter'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  edit = !edit;
                });
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: ListTile(
                tileColor: Color.alphaBlend(
                    Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.5),
                    Theme.of(context).colorScheme.surfaceContainer),
                leading: Image.asset(
                  width: 35,
                  'icons/currency/$convertCurrencyText.png',
                  package: 'currency_icons',
                ),
                title: Row(
                  children: [
                    DropdownButton<Currency>(
                      value: convertCurrency,
                      items: Currency.values
                          .map<DropdownMenuItem<Currency>>((Currency value) {
                        return DropdownMenuItem<Currency>(
                          value: value,
                          child: Text(
                              value.toString().split('.').last.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (Currency? newValue) {
                        if (newValue != null) {
                          ref
                              .read(currencyProvider)
                              .updateConvertCurrency(newValue);
                        }
                      },
                    ),
                    //  const Expanded(child: SizedBox()),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.end,
                        controller: inputController,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Enter Amount'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          double amount = double.tryParse(value) ?? 0.0;
                          currencyNotifier.convert(amount, convertCurrency);
                        },
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
            child: currencies.isEmpty
                ? const Center(
                    child: Text('No Currency',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        )))
                : ListView.builder(
                    itemCount: currencies.length,
                    itemBuilder: (context, index) {
                      final currency = currencies[index];
                      final convertedAmount =
                          convertedAmounts[currency.code] ?? 0.0;
                      return Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                          child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              //  minVerticalPadding: 10,
                              tileColor: Color.alphaBlend(
                                  Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.08),
                                  Theme.of(context).colorScheme.surface),
                              leading: Image.asset(
                                width: 35,
                                'icons/currency/${currency.code}.png',
                                package: 'currency_icons',
                              ),
                              title: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(currency.name,),
                                      Text(
                                        AllCurrency.allCurrencyWithCountries[currency.code].toString(),
                                        style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                                        ),
                                    ],
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Text(
                                    convertedAmount.toStringAsFixed(2),
                                  )
                                ],
                              ),
                             // subtitle: Text(AllCurrency.allCurrencyWithCountries[currency.code].toString()),
                              trailing: edit && currencies.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        ref.read(currencyProvider).removeCurrency(index);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                              backgroundColor: Colors.blue,
                                                content: Center(
                                                    child: Text(
                                                        ' ${currency.name} has been removed'))));
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ))
                                  :  null ));
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                Currency selectedCurrency = Currency.aave;
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: const Center(child: Text('Add Currency')),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButton<Currency>(
                            value: selectedCurrency,
                            onChanged: (Currency? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedCurrency = newValue;
                                });
                              }
                            },
                            items: Currency.values
                                .map<DropdownMenuItem<Currency>>(
                                    (Currency value) {
                              return DropdownMenuItem<Currency>(
                                value: value,
                                child: Text(value
                                    .toString()
                                    .split('.')
                                    .last
                                    .toUpperCase()),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            ref.read(currencyProvider).addCurrency(
                                selectedCurrency
                                    .toString()
                                    .split('.')
                                    .last
                                    .toLowerCase(),
                                selectedCurrency
                                    .toString()
                                    .split('.')
                                    .last
                                    .toUpperCase(),
                                selectedCurrency);
                            Navigator.pop(context);
                          },
                          child: const Text('Add'))
                    ],
                  );
                });
              },
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Currency')),
    );
  }
}
