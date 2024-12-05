import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = ""; // Kiritilgan ma'lumot
  String _result = "0"; // Hisoblash natijasi
  bool _startNewInput = false; // Yangi amal boshlash uchun bayroq

  void _onButtonPressed(String value) {
    setState(() {
      if (value == "AC") {
        _input = "";
        _result = "0";
        _startNewInput = false;
      } else if (value == "⌫") {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (value == "=") {
        _calculateResult();
      } else if (value == ".") {
        if (!_input.endsWith(".") &&
            !_input.split(RegExp(r'[+\-×÷]')).last.contains(".")) {
          _input += value;
        }
      } else if (value == "0") {
        if (!(_input.endsWith("0") &&
            (_input.isEmpty || RegExp(r'[+\-×÷]').hasMatch(_input.substring(_input.length - 2))))) {
          _input += value;
        }
      } else {
        if (_startNewInput) {
          // Yangi amal boshlanganida eski ma'lumotlarni o'chirish
          _input = "";
          _startNewInput = false;
        }
        _input += value;
      }
    });
  }

  void _calculateResult() {
    try {
      String finalInput = _input.replaceAll("×", "*").replaceAll("÷", "/");
      double evalResult = _evaluateExpression(finalInput);
      _result = evalResult.toStringAsFixed(evalResult.truncateToDouble() == evalResult ? 0 : 2);
      _startNewInput = true; // Amalni bajarib bo'lgandan keyin yangi kiritish
    } catch (e) {
      _result = "Error";
    }
  }

  double _evaluateExpression(String expression) {
    List<String> tokens = _tokenize(expression);
    List<String> postfix = _toPostfix(tokens);
    return _evaluatePostfix(postfix);
  }

  List<String> _tokenize(String expression) {
    final regex = RegExp(r'(\d+\.?\d*|[+\-*/])');
    return regex.allMatches(expression).map((m) => m.group(0)!).toList();
  }

  List<String> _toPostfix(List<String> tokens) {
    List<String> output = [];
    List<String> operators = [];
    Map<String, int> precedence = {'+': 1, '-': 1, '*': 2, '/': 2};

    for (String token in tokens) {
      if (RegExp(r'\d+\.?\d*').hasMatch(token)) {
        output.add(token);
      } else {
        while (operators.isNotEmpty &&
            precedence[operators.last]! >= precedence[token]!) {
          output.add(operators.removeLast());
        }
        operators.add(token);
      }
    }
    output.addAll(operators.reversed);
    return output;
  }

  double _evaluatePostfix(List<String> postfix) {
    List<double> stack = [];
    for (String token in postfix) {
      if (RegExp(r'\d+\.?\d*').hasMatch(token)) {
        stack.add(double.parse(token));
      } else {
        double b = stack.removeLast();
        double a = stack.removeLast();
        switch (token) {
          case '+':
            stack.add(a + b);
            break;
          case '-':
            stack.add(a - b);
            break;
          case '*':
            stack.add(a * b);
            break;
          case '/':
            stack.add(a / b);
            break;
        }
      }
    }
    return stack.single;
  }
  Widget _buildButton(String text, {bool isOperator = false}) {
    return InkWell(
      onTap: () => _onButtonPressed(text),
      child: Container(
        decoration: BoxDecoration(
          color: isOperator ? Colors.blue[100] : Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isOperator ? Colors.blue : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEqualButton() {
    return InkWell(
      onTap: () => _onButtonPressed("="),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.pink, Colors.blue],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            "=",
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 0.55,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.teal],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Attractive Design",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 120,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _input.isEmpty ? "0" : _input,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _result,
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      children: [
                        _buildButton("AC", isOperator: true),
                        _buildButton("⌫", isOperator: true),
                        _buildButton("%", isOperator: true),
                        _buildButton("÷", isOperator: true),
                        _buildButton("7"),
                        _buildButton("8"),
                        _buildButton("9"),
                        _buildButton("×", isOperator: true),
                        _buildButton("4"),
                        _buildButton("5"),
                        _buildButton("6"),
                        _buildButton("-", isOperator: true),
                        _buildButton("1"),
                        _buildButton("2"),
                        _buildButton("3"),
                        _buildButton("+", isOperator: true),
                        _buildButton("0"),
                        _buildButton("."),
                        _buildEqualButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}