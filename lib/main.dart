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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Converter'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: TextField(
              controller: inputController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter Amount'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                double amount = double.tryParse(value) ?? 0.0;
                currencyNotifier.convert(amount, Currency.usd);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final currency = currencies[index];
                final convertedAmount = convertedAmounts[currency.code] ?? 0.0;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    //  minVerticalPadding: 10,
                    tileColor: Color.alphaBlend(
                        Theme.of(context).colorScheme.primary.withOpacity(0.08),
                        Theme.of(context).colorScheme.surface),
                    leading: Image.asset(
                      width: 35,
                      'icons/currency/${currency.code}.png',
                      package: 'currency_icons',
                    ),
                    title: Row(
                      children: [
                        Text(currency.name),
                        const Expanded(child: SizedBox()),
                        Text(
                          convertedAmount.toStringAsFixed(2),
                        )
                      ],
                    ),
                    trailing: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.more_vert)),
                  ),
                );
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
                return AlertDialog(
                  title: const Center(child: Text('Add Currency')),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // TextField(
                        //   controller: codeController,
                        //   maxLength: 3,
                        // ),
                        // TextField(
                        //   controller: currencyController,
                        // )
                        DropdownButton<Currency>(
                          value: selectedCurrency,
                          onChanged: (Currency? newValue) {
                            if (newValue != null) {
                              selectedCurrency = newValue;
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
              },
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Currency')),
    );
  }
}
