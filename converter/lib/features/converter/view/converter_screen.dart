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
      String? temp = _fromValue;
      _fromValue = _toValue;
      _toValue = temp;
    });
  }

  void _convert() {
    String inputText = _inputController.text;
    double? inputNumber = double.tryParse(inputText);

    if (inputNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        (content: const Text('Please enter a valid number')) as SnackBar,
      );
      return;
    }

    setState(() {
      _result = value!.convertation(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
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
                DropdownButton<String>(
                  value: _fromValue,
                  items: value!.valuesMap.keys.map((String currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _fromValue = newValue!;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: _swapValue,
                ),
                DropdownButton<String>(
                  value: _toValue,
                  items: value!.valuesMap.keys.map((String currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
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
              child: const Text('Convert'),
            ),
            const SizedBox(height: 16),
            Text(
              'Result: $_result $_toValue',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class LengthScreen extends StatefulWidget {
//   @override
//   _LengthScreenState createState() => _LengthScreenState();
// }

// class _LengthScreenState extends State<LengthScreen> {
//   // Контроллер для ввода значения
//   TextEditingController _inputController = TextEditingController();

//   // Доступные единицы измерения
//   String _fromUnit = 'Centimeters';
//   String _toUnit = 'Meters';

//   // Результат конвертации
//   double? _result;

//   // Метод для смены единиц местами
//   void _swapUnits() {
//     setState(() {
//       String temp = _fromUnit;
//       _fromUnit = _toUnit;
//       _toUnit = temp;
//     });
//   }

//   // Метод для конвертации
//   void _convert() {
//     String inputText = _inputController.text;
//     double? inputNumber = double.tryParse(inputText);

//     if (inputNumber == null) {
//       // Обработка ошибок при некорректном вводе
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter a valid number')),
//       );
//       return;
//     }

//     setState(() {
//       if (_fromUnit == 'Centimeters' && _toUnit == 'Meters') {
//         _result = inputNumber / 100;
//       } else if (_fromUnit == 'Meters' && _toUnit == 'Centimeters') {
//         _result = inputNumber * 100;
//       } else {
//         // Здесь можно добавить другие конверсии по необходимости
//         _result = inputNumber; // если единицы одинаковы
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Length Converter'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _inputController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Enter value',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 DropdownButton<String>(
//                   value: _fromUnit,
//                   items: ['Centimeters', 'Meters']
//                       .map((String unit) => DropdownMenuItem<String>(
//                             child: Text(unit),
//                             value: unit,
//                           ))
//                       .toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _fromUnit = newValue!;
//                     });
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.swap_horiz),
//                   onPressed: _swapUnits,
//                 ),
//                 DropdownButton<String>(
//                   value: _toUnit,
//                   items: ['Centimeters', 'Meters']
//                       .map((String unit) => DropdownMenuItem<String>(
//                             child: Text(unit),
//                             value: unit,
//                           ))
//                       .toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _toUnit = newValue!;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _convert,
//               child: Text('Convert'),
//             ),
//             SizedBox(height: 16),
//             if (_result != null)
//               Text(
//                 'Result: $_result $_toUnit',
//                 style: TextStyle(fontSize: 24),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }