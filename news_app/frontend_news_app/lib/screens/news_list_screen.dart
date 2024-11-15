import 'package:flutter/material.dart';
import 'package:frontend_news_app/models/news_model.dart';
import 'package:frontend_news_app/models/tags_model.dart';
import 'package:frontend_news_app/screens/detail_news.dart';
import 'package:frontend_news_app/services/news_service.dart';
import 'package:frontend_news_app/services/tags_service.dart';
import 'package:intl/intl.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  List<String> selectedTags = [];
  bool orderDesc = true;
  int page = 1;
  int pageSize = 10;

  List<NewsModel> newsList = [];
  List<TagsModel> tagsList = [];
  bool isLoading = false;
  bool filtersVisible = true;

  @override
  void initState() {
    super.initState();
    _loadTags();
    _loadNews();
  }

  Future<void> _loadTags() async {
    try {
      var tags = await TagsService.getAll();
      setState(() {
        tagsList = tags;
      });
    } catch (e) {
      print("Error loading tags: $e");
    }
  }

  Future<void> _loadNews() async {
    setState(() {
      isLoading = true;
    });

    try {
      var startDate = _startDateController.text.isNotEmpty
          ? DateFormat("yyyy-MM-dd").parse(_startDateController.text)
          : null;
      var endDate = _endDateController.text.isNotEmpty
          ? DateFormat("yyyy-MM-dd").parse(_endDateController.text)
          : null;

      var news = await NewsService.getWithFilters(
        startDate: startDate,
        endDate: endDate,
        tags: selectedTags,
        orderDesc: orderDesc,
        page: page,
        pageSize: pageSize,
      );

      setState(() {
        newsList = news;
      });
    } catch (e) {
      print("Error loading news: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildTagsFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tags:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Wrap(
          spacing: 8.0,
          children: tagsList.map((tag) {
            return ChoiceChip(
              label: Text(tag.title, style: TextStyle(fontSize: 12)),
              selected: selectedTags.contains(tag.title),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedTags.add(tag.title);
                  } else {
                    selectedTags.remove(tag.title);
                  }
                  _loadNews();
                });
              },
              selectedColor: Colors.blue,
              backgroundColor: Colors.grey[200],
            );
          }).toList(),
        ),
        SizedBox(height: 8),
        Text('Selected Tags: ${selectedTags.join(', ')}',
            style: TextStyle(fontSize: 12)),
        SizedBox(height: 16),
        _buildDatePicker('Start Date', _startDateController, 'start'),
        _buildDatePicker('End Date', _endDateController, 'end'),
        Row(
          children: [
            Text('Order Descending:', style: TextStyle(fontSize: 14)),
            Switch(
              value: orderDesc,
              onChanged: (value) {
                setState(() {
                  orderDesc = value;
                  _loadNews();
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePicker(
      String label, TextEditingController controller, String dateType) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              icon: Icon(Icons.calendar_today, size: 16),
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  controller.text = DateFormat("yyyy-MM-dd").format(pickedDate);
                  _loadNews();
                });
              }
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              if (dateType == 'start') {
                _startDateController.clear();
              } else {
                _endDateController.clear();
              }
              _loadNews();
            });
          },
        ),
      ],
    );
  }

  Widget _buildNewsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        var news = newsList[index];
        return ListTile(
          title: Text(news.title),
          subtitle: Text(news.description),
          trailing: Text(DateFormat('yyyy-MM-dd').format(news.date)),
          onTap: () {
            // Переход на экран с подробной информацией
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailScreen(news: news),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
        actions: [
          IconButton(
            icon: Icon(
                filtersVisible ? Icons.filter_list_off : Icons.filter_list),
            onPressed: () {
              setState(() {
                filtersVisible = !filtersVisible;
              });
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (filtersVisible) _buildTagsFilter(),
                  SizedBox(height: 16),
                  _buildNewsList(),
                ],
              ),
            ),
    );
  }
}
