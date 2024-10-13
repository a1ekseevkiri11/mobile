import 'package:flutter/material.dart';

import 'package:converter/features/converter_list/widgets/value_tile.dart';


final List<Value> VALUE_ARRAY = [
  Value(
    valueName: 'Length', 
    icon: 'img/length.png',
    valuesMap: {
      'mm': 1,        // миллиметры
      'cm': 10,       // сантиметры
      'm': 1000,      // метры
      'km': 1000000,  // километры
    },
    supportKey: 'mm',
  ),

  Value(
    valueName: 'Weight', 
    icon: 'img/weight.png',
    valuesMap: {
      'g': 1,          // граммы
      'kg': 1000,      // килограммы
      'ton': 1000000,  // тонны
    },
    supportKey: 'g',
  ),

  Value(
    valueName: 'Temperature', 
    icon: 'img/temperature.png',
    valuesMap: {
      'C': 1,   
      'F': 2,   
      'K': 3,
    },
    supportKey: 'C',
  ),

  Value(
    valueName: 'Area', 
    icon: 'img/area.png',
    valuesMap: {
      'cm²': 1,         // квадратные сантиметры
      'm²': 10000,      // квадратные метры
      'km²': 10000000000, // квадратные километры
    },
    supportKey: 'cm²',
  ),

  Value(
    valueName: 'Currency', 
    icon: 'img/currency.png',
    valuesMap: {
      'USD': 1,
      'EUR': 0.85,
      'RUB': 75.0,
    },
    supportKey: 'USD',
  ),

];


class ValueListScreen extends StatelessWidget {
  const ValueListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: ListView.separated(
        itemCount: VALUE_ARRAY.length,
        separatorBuilder: (context, index) => Divider(
          color: Theme.of(context).dividerColor,
        ),
        itemBuilder: (context, i) {
          final value = VALUE_ARRAY[i];
          return ValueTile(value: value);
        },
      ),
    );
  }
}