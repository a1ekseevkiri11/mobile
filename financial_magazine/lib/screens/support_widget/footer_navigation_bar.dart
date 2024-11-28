import 'package:flutter/material.dart';

class FooterNavigationBar extends StatelessWidget {
  final int currIndex;
  const FooterNavigationBar({super.key, required this.currIndex});
  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        if (currIndex != index) {
          Navigator.pushReplacementNamed(
            context,
            '/transactions',
            arguments: {
              'criteria': true,
            },
          );
        }
        break;
      case 1:
        if (currIndex != index) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        break;
      case 2:
        if (currIndex != index) {
          Navigator.pushReplacementNamed(
            context,
            '/transactions',
            arguments: {
              'criteria': false,
            },
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currIndex,
      onTap: (index) => _onTap(context, index),
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.arrow_upward),
          label: "Income",
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.pie_chart),
          label: "Statistics",
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.arrow_downward),
          label: "Expenses",
        ),
      ],
    );
  }
}
