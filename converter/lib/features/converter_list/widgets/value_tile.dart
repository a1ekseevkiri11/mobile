import 'package:flutter/material.dart';

class Value {
  final String valueName;
  final String icon;
  final Map<String, double> valuesMap;
  final String supportKey;

  Value({
    required this.valueName,
    required this.icon,
    required this.valuesMap,
    required this.supportKey,
  }) {
    if (!valuesMap.containsKey(supportKey)) {
      throw ArgumentError('The support key "$supportKey" does not exist in the provided values map.');
    }
  }

  double convertation({
    required String key1, 
    required double val1, 
    required String key2, 
    }){
    double? multiplier1 = valuesMap[key1];
    double? multiplier2 = valuesMap[key2];

    if (multiplier1 == null || multiplier2 == null) {
      throw ArgumentError('Invalid keys provided for conversion');
    }

    val1 *= multiplier1;
    return val1 / multiplier2;
  }
}

class ValueTile extends StatelessWidget {
  const ValueTile({
    super.key,
    required this.value,
  });

  final Value value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        value.icon,
        height: 25,
        width: 25,
      ),
      title: Text(
        value.valueName,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          '/converter',
          arguments: value,
        );
      },
    );
  }
}