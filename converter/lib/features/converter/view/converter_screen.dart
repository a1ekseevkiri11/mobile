import 'package:flutter/material.dart';
import 'package:converter/features/converter_list/widgets/value_tile.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _inputController = TextEditingController();

  late String _fromValue;
  late String _toValue;
  double _result = 0;

  Value? value;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    assert(args != null && args is Value, "You must provide Value args");
    value = args as Value;
    _fromValue = value!.supportKey;
    _toValue = value!.supportKey;
    super.didChangeDependencies();
  }

  void _swapValue() {
    setState(() {
      String temp = _fromValue;
      _fromValue = _toValue;
      _toValue = temp;
    });
  }

  void _convert() {
    String inputText = _inputController.text;
    double? inputNumber = double.tryParse(inputText);

    if (inputNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
      return;
    }

    setState(() {
      _result = value!.convertation(
        valueName: value?.valueName,
        key1: _fromValue,
        val1: inputNumber,
        key2: _toValue,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(value?.valueName ?? '...'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              color: Colors.black,
              value!.icon,
              height: 35,
              width: 35,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              style: Theme.of(context).textTheme.bodyMedium,
              controller: _inputController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter value',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownMenu<String>(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  initialSelection: _fromValue,
                  dropdownMenuEntries: value!.valuesMap.keys.map((String currency) {
                    return DropdownMenuEntry<String>(
                      value: currency,
                      label: currency,
                    );
                  }).toList(),
                  onSelected: (String? newValue) {
                    setState(() {
                      _fromValue = newValue!;
                    });
                  },
                ),
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: _swapValue,
                ),
                DropdownMenu<String>(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  initialSelection: _toValue,
                  dropdownMenuEntries: value!.valuesMap.keys.map((String currency) {
                    return DropdownMenuEntry<String>(
                      value: currency,
                      label: currency,
                    );
                  }).toList(),
                  onSelected: (String? newValue) {
                    setState(() {
                      _toValue = newValue!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convert,
              child: const Text(
                'Convert',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Result: $_result $_toValue',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
