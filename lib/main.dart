import 'package:currency_converter/currency.dart';
import 'package:flutter/material.dart';
import 'package:currency_converter/currency_converter.dart';
import 'package:country_icons/country_icons.dart';

void main() {
  runApp(const MyApp());
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _convertedAmount = 0.0;
  @override
  void initState() {
    super.initState();
    convert();
  }

  void convert() async {
    Currency myCurrency = await CurrencyConverter.getMyCurrency();
    var usdConvert = await CurrencyConverter.convert(
      from: Currency.gbp,
      to: myCurrency,
      amount: 5,
    );
    setState(() {
      _convertedAmount = usdConvert!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        title: const Text('Converter'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit))],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              minTileHeight: 60,
              tileColor: Color.alphaBlend(
                  Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  Theme.of(context).colorScheme.surface),
              leading: CircleAvatar(
                radius: 30,
                child: Image.asset(
                  fit: BoxFit.fill,
                  'icons/flags/png100px/gb.png',
                  package: 'country_icons',
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Currency'),
                  Text('$_convertedAmount'),
                ],
              ),
              trailing:
                  IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
            ),
          );
        },
      ),
    );
  }
}
