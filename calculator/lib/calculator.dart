import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
// import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final maxLenUserInput = 9;
  String userInput = "";
  String result = "0";
  final Set<String> digitSet = {
    '+',
    '-',
    '*',
    '/',
    '^',
    '%',
  };

  final Set<String> numberSet = {
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1d2630),
      body: Column(
        children: [
          // Верхняя часть с выводом результата
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerRight,
                  child: Text(
                    userInput, // Отображаем пользовательский ввод
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerRight,
                  child: Text(
                    result, // Отображаем результат вычисления
                    style: TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.white),

          // Основная часть с кнопками
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: GridView(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 столбца
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                children: [
                  // Обычные кнопки
                  CustomButton('AC'),
                  CustomButton('^'),
                  CustomButton('%'),
                  CustomButton('/'),
                  CustomButton('7'),
                  CustomButton('8'),
                  CustomButton('9'),
                  CustomButton('*'),
                  CustomButton('4'),
                  CustomButton('5'),
                  CustomButton('6'),
                  CustomButton('-'),
                  CustomButton('1'),
                  CustomButton('2'),
                  CustomButton('3'),
                  CustomButton('+'),
                  CustomButton('C'),
                  CustomButton('0'),
                  CustomButton('.'),
                  CustomButton('='),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget CustomButton(String text) {
    return InkWell(
      splashColor: Color.fromARGB(255, 40, 47, 47),
      onTap: () {
        setState(() {
          handleButtons(text);
        });
      },
      child: Ink(
        decoration: BoxDecoration(
          color: getBgColor(text),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 0.5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: getColor(text),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  getColor(String text) {
    if (text == "/" ||
        text == "*" ||
        text == "+" ||
        text == "-" ||
        text == "C" ||
        text == "%" ||
        text == "^") {
      return Color.fromARGB(255, 252, 100, 100);
    }
    return Colors.white;
  }

  getBgColor(String text) {
    if (text == "AC") {
      return Color.fromARGB(255, 252, 100, 100);
    }
    if (text == "=") {
      return Color.fromARGB(255, 104, 204, 159);
    }
    return Color(0xFF1d2630);
  }

  bool checkNumberBack(){
    if (userInput.isEmpty){
      return false;
    }
    if (numberSet.contains(userInput[userInput.length - 1])){
      return true;
    }
    return false;
  }

  bool checkDigitBack(){
    if (userInput.isEmpty){
      return false;
    }
    if (digitSet.contains(userInput[userInput.length - 1])){
      return true;
    }
    return false;
  }


  bool checkZeroBack(){
    if (userInput.isEmpty){
      return false;
    }
    for (int i = userInput.length - 1; i >= 0; i--){
      if (digitSet.contains(userInput[i])){
        return false;
      }
      if (userInput[i] != "0"){
        return false;
      }
    }
    return true;
  }

  void handleButtons(String text) {
    switch (text) {
      case "AC":
        userInput = "";
        result = "0";
        return;
      case "=":
        if (checkDigitBack()){
          userInput = userInput.substring(0, userInput.length - 1);
        }
        if (userInput.isEmpty) {
          return;
        }
        calculate();
        return;
      case "C":
        if (userInput.isNotEmpty) {
          userInput = userInput.substring(0, userInput.length - 1);
        }
        return;
      case ".":
        if (userInput.isEmpty){
          return;
        }
        for (int i = userInput.length - 1; i >= 0; i--){
          if (digitSet.contains(userInput[i])){
            break;
          }
          if (userInput[i] == "."){
            return;
          }
        }
        userInput += text;
    }
    
    //для операций
    if (digitSet.contains(text)){
      if (checkDigitBack()){
        return;
      }
      if (userInput.isEmpty){
        if (text == "-"){
          userInput += text;
        }
        return;
      }
      userInput += text;
    }

    if (numberSet.contains(text)){
      if (text == "0"){
        if (checkZeroBack()){
          return;
        }
      }

      if (checkZeroBack()){
        userInput = userInput.substring(0, userInput.length - 1);
      }
      
      for (int i = userInput.length - 1; i >= 0; i--){
        if (digitSet.contains(userInput[i])){
          break;
        }
        if (userInput.length - i >= maxLenUserInput){
          return;
        }
      }
      userInput += text;
    }

  }

  void calculate() {
    try {
      var exp = Parser().parse(userInput);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      result = evaluation.toString();
      if (result.endsWith(".0")) {
        result = result.replaceAll(".0", "");
      }
      return;
    } catch (e) {
      result = "Error";
    }
  }
}
