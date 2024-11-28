import 'package:financial_magazine/database/db_helper.dart';
import 'package:flutter/material.dart';

class CategoryDialog extends StatefulWidget {
  final bool criteria;
  final VoidCallback onCategoryAdded;

  const CategoryDialog(
      {super.key, required this.criteria, required this.onCategoryAdded});

  @override
  _CategoryDialogState createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final _nameController = TextEditingController();

  Future<void> addData(name) async {
    final db = DatabaseHelper.instance;
    await db.addCategory(name, widget.criteria);
    widget.onCategoryAdded();
  }

  void _saveCategory() async {
    String name = _nameController.text;
    if (name.isNotEmpty) {
      addData(name);
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Category name'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _saveCategory,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
