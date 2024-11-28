import 'package:financial_magazine/database/db_helper.dart';
import 'package:flutter/material.dart';
import 'create_category_dialog.dart';

class TransactionsDialog extends StatefulWidget {
  final bool criteria;
  const TransactionsDialog({
    super.key,
    required this.criteria,
  });

  @override
  State<TransactionsDialog> createState() => _TransactionsDialogState();
}

class _TransactionsDialogState extends State<TransactionsDialog> {
  List<Map<String, dynamic>> arr = [];
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  int? selectedCategoryId;

  Future<void> addNote(
      int categoryId, String title, double amount, DateTime date) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('transactions', {
      'category_id': categoryId,
      'title': title,
      'amount': amount,
      'date': date.toString(),
    });

    Navigator.pushReplacementNamed(context, '/transactions',
        arguments: {'criteria': widget.criteria});
  }

  Future<void> getList(criteria) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> data =
        await db.query('categories', where: 'type = ?', whereArgs: [criteria]);
    setState(() {
      arr = data;
      selectedCategoryId = arr[0]['id'];
    });
  }

  @override
  void initState() {
    super.initState();
    getList(widget.criteria);
  }

  @override
  Widget build(BuildContext context) {
    return arr.isEmpty
        ? const CircularProgressIndicator()
        : AlertDialog(
            title: const Text('Add transaction'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount'),
                ),
                ListTile(
                  title: Text("${selectedDate.toLocal()}".substring(0, 10)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
                DropdownButton<int>(
                  hint: const Text("Select category"),
                  value: selectedCategoryId,
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategoryId = newValue;
                    });
                  },
                  items: arr.map((category) {
                    return DropdownMenuItem<int>(
                      value: category['id'],
                      child: Text(category['name']),
                    );
                  }).toList()
                    ..add(
                      DropdownMenuItem<int>(
                        value: null,
                        child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => CategoryDialog(
                                  criteria: widget.criteria,
                                  onCategoryAdded: () {
                                    getList(widget.criteria);
                                    setState(() {
                                      arr = arr;
                                    });
                                  },
                                ),
                              );
                            },
                            child: const Text('Create a category')),
                      ),
                    ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  String title = titleController.text;
                  String sumText = amountController.text;
                  if (title.isNotEmpty &&
                      sumText.isNotEmpty &&
                      selectedCategoryId != null) {
                    double? sum = double.tryParse(sumText);
                    if (sum != null) {
                      addNote(selectedCategoryId!, title, sum, selectedDate);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Enter the correct amount')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Fill in all fields')),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
  }
}
