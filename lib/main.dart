import 'package:currency_converter/currency.dart';
import 'package:currency_converter_app/provider/currency_provider.dart';
import 'package:flutter/material.dart';
import 'package:currency_converter/currency_converter.dart';
import 'package:country_icons/country_icons.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  late TextEditingController inputController = TextEditingController(text: '6');
  late TextEditingController amountcontroller = TextEditingController(
      text: ref.watch(currencyProvider).convertAmount.toString());
  @override
  @override
  Widget build(BuildContext context) {
    final currencyNotifier = ref.watch(currencyProvider);
    final currencies = currencyNotifier.currencieslist;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
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
              onChanged: (value) {},
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currencies.length,
              itemBuilder: (context, index) {
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
                      'icons/flags/png100px/gh.png',
                      package: 'country_icons',
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Currency'),
                        Expanded(
                            child: TextField(
                          textAlign: TextAlign.end,
                          controller: amountcontroller,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                        )),
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
    );
  }
}
