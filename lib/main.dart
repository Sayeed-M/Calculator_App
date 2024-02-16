import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Calculator(),
    );
  }
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = "0";
  String _expression = "";

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _expression = "";
      } else if (buttonText == "=") {
        _expression = _expression.replaceAll('×', '*').replaceAll('÷', '/');
        try {
          Parser p = Parser();
          Expression exp = p.parse(_expression);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          _output = eval.toString();
        } catch (e) {
          _output = "Error";
        }
        _expression = "";
      } else if (buttonText == "⌫") {
        _expression = _expression.substring(0, _expression.length - 1);
        if (_expression.isEmpty) _output = "0";
      } else {
        if (_expression == "0" && buttonText != ".") {
          _expression = buttonText;
        } else {
          _expression += buttonText;
        }
        _output = _expression;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            child: Text(
              _output,
              style: TextStyle(fontSize: 48),
            ),
          ),
          Divider(),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              children: [
                _buildButton("C"),
                _buildButton("⌫"),
                _buildButton("%"),
                _buildButton("÷"),
                _buildButton("7"),
                _buildButton("8"),
                _buildButton("9"),
                _buildButton("×"),
                _buildButton("4"),
                _buildButton("5"),
                _buildButton("6"),
                _buildButton("-"),
                _buildButton("1"),
                _buildButton("2"),
                _buildButton("3"),
                _buildButton("+"),
                _buildButton("0"),
                _buildButton("."),
                _buildButton("00"),
                _buildButton("="),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String buttonText) {
    return GestureDetector(
      onTap: () => _buttonPressed(buttonText),
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: buttonText == "=" ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: buttonText == "=" ? 24 : 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
