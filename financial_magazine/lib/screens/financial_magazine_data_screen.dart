import 'package:flutter/material.dart';
import 'package:financial_magazine/database/db_helper.dart';
import 'dialogs/create_transactions_dialog.dart';
import 'support_widget/footer_navigation_bar.dart';

class FinancialMagazineDataScreen extends StatefulWidget {
  const FinancialMagazineDataScreen({Key? key}) : super(key: key);

  @override
  State<FinancialMagazineDataScreen> createState() =>
      _FinancialMagazineDataScreenState();
}

class _FinancialMagazineDataScreenState
    extends State<FinancialMagazineDataScreen> {
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> notes = [];
  List<Map<String, dynamic>> filteredNotes = [];
  int? selectedCategoryId;
  DateTime? startDate;
  DateTime? endDate;

  bool criteria = true;
  int currIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var arg =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      criteria = arg['criteria'];
      loadData(criteria);
    });
  }

  Future<void> loadData(bool criteria) async {
    final db = await DatabaseHelper.instance;
    final categoriesList = await db.getCategoryList();
    final notesList = await db.getAllTransactions();

    setState(() {
      categories = categoriesList
          .where((cat) => cat['type'] == (criteria ? 1 : 0))
          .toList();

      notes = notesList
          .where((note) => note['type'] == (criteria ? 1 : 0))
          .toList();

      filteredNotes = notes;
      currIndex = criteria ? 0 : 2;
    });
  }

  Future<void> applyFilters() async {
    final db = await DatabaseHelper.instance;
    final filtered = await db.getFilteredTransactions(
      categoryId: selectedCategoryId,
      startDate: startDate,
      endDate: endDate,
    );

    setState(() {
      filteredNotes = filtered;
    });
  }

  void _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(criteria ? 'Income' : 'Expenses')),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _selectDateRange(context),
          ),
        ],
      ),
      body: Column(
        children: [
          DropdownButton<int>(
            hint: const Text('Select category'),
            value: selectedCategoryId,
            items: categories.map((category) {
              return DropdownMenuItem<int>(
                value: category['id'],
                child: Text(category['name']),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategoryId = value;
              });
              applyFilters();
            },
          ),
          Expanded(
            child: filteredNotes.isEmpty
                ? const Center(child: Text('No entries'))
                : ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      var note = filteredNotes[index];
                      return ListTile(
                        title: Text(note['title']),
                        subtitle: Text(
                          'Amount: ${note['amount']}\nDate: ${note['date'].toString().substring(0, 10)}',
                        ),
                        isThreeLine: true,
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: FooterNavigationBar(currIndex: currIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => TransactionsDialog(criteria: criteria));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
