import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime today = DateTime.now();
  DateTime selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildBackButton() {
      if (selected.year == today.year && selected.month == today.month) {
        return Container();
      }
      return IconButton(
          onPressed: () {
            setState(() {
              selected = DateTime.now();
            });
          },
          icon: const FaIcon(FontAwesomeIcons.arrowRotateLeft,
              color: Colors.black));
    }

    Widget buildYearAndMonthSelector() {
      String monthText = DateFormat('MMMM', 'ru_RU').format(selected);
      monthText = monthText[0].toUpperCase() + monthText.substring(1);
      String yearText = DateFormat('yyyy').format(selected);

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  selected = DateTime(selected.year, selected.month - 1);
                });
              },
              icon: const FaIcon(FontAwesomeIcons.arrowLeft,
                  color: Colors.white)),
          YearSelection(
            textYear: yearText,
            selected: selected,
            today: today,
            theme: theme,
            onYearSelected: (year) {
              setState(() {
                selected = DateTime(year, selected.month);
              });
            },
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  selected = DateTime(selected.year, selected.month + 1);
                });
              },
              icon: const FaIcon(FontAwesomeIcons.arrowRight,
                  color: Colors.white)),
        ],
      );
    }

    Widget buildDaysOfWeekRow() {
      const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days
            .map((item) => Text(
                  item,
                  style: const TextStyle(fontSize: 19, color: Colors.white),
                ))
            .toList(),
      );
    }

    Color determineDayColor(int day, DateTime date, bool current) {
      if (date.year == today.year &&
          date.month == today.month &&
          day == today.day) {
        return Colors.yellow;
      } else if (current) {
        return Colors.white;
      }
      return Colors.grey;
    }

    Widget buildDayCell(int day, Color color) {
      return Card(
        color: color,
        child: Center(
          child: SizedBox(
              height: 100,
              width: 100,
              child: Center(
                child: Text(
                  '$day',
                  style: const TextStyle(color: Colors.black),
                ),
              )),
        ),
      );
    }

    Widget buildDaysOfMonthGrid() {
      List<Widget> grid = [];
      int previousMonth = selected.month == 1 ? 12 : selected.month - 1;

      int daysInCurrentMonth =
          DateUtils.getDaysInMonth(selected.year, selected.month);
      int daysInPreviousMonth =
          DateUtils.getDaysInMonth(selected.year, previousMonth);

      DateTime firstDayOfMonth = DateTime(selected.year, selected.month, 1);
      DateTime lastDayOfMonth =
          DateTime(selected.year, selected.month, daysInCurrentMonth);
      int previousMonthDays = firstDayOfMonth.weekday - 1;
      int nextMonthDays = 7 - lastDayOfMonth.weekday;

      int lastPreviousMonthDay =
          DateTime(selected.year, selected.month - 1, daysInPreviousMonth).day;
      for (int i = previousMonthDays; i > 0; i--) {
        grid.add(buildDayCell(
            lastPreviousMonthDay - i + 1,
            determineDayColor(lastPreviousMonthDay - i + 1,
                DateTime(selected.year, selected.month - 1), false)));
      }
      for (int i = 1; i <= daysInCurrentMonth; i++) {
        grid.add(buildDayCell(
            i,
            determineDayColor(
                i, DateTime(selected.year, selected.month), true)));
      }
      for (int i = 1; i <= nextMonthDays; i++) {
        grid.add(buildDayCell(
            i,
            determineDayColor(
                i, DateTime(selected.year, selected.month + 1), false)));
      }

      return GridView.count(
          crossAxisCount: 7,
          physics: const NeverScrollableScrollPhysics(),
          children: grid);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [buildBackButton()],
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          buildYearAndMonthSelector(),
          buildDaysOfWeekRow(),
          Expanded(child: buildDaysOfMonthGrid()),
        ],
      ),
    );
  }
}

class YearSelection extends StatelessWidget {
  final String textYear;
  final DateTime selected;
  final DateTime today;
  final ThemeData theme;
  final Function(int) onYearSelected;

  const YearSelection({
    required this.textYear,
    required this.selected,
    required this.today,
    required this.theme,
    required this.onYearSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String monthText = DateFormat('MMMM', 'ru_RU').format(selected);
    monthText = monthText[0].toUpperCase() + monthText.substring(1);

    return Column(
      children: [
        TextButton(
          onPressed: () {
            int initialScrollIndex = 50;
            ScrollController scrollController = ScrollController(
              initialScrollOffset:
                  (initialScrollIndex - (today.year - selected.year)) *
                      54.5,
            );

            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 100,
                    itemBuilder: (BuildContext context, int index) {
                      int year = today.year + index - 50;
                      bool isSelectedYear = selected.year == year;

                      return ListTile(
                        tileColor: isSelectedYear
                            ? Colors.yellow
                            : const Color.fromARGB(255, 255, 255, 255),
                        title: Text(
                          '$year',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelectedYear
                                ? const Color.fromARGB(255, 0, 0, 0)
                                : const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: isSelectedYear
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        onTap: () {
                          onYearSelected(year);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
          child: Text(
            textYear,
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20),
          ),
        ),
        const SizedBox(height: 0),
        Text(
          monthText,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ],
    );
  }
}
