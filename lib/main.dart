import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dezmond\'s Calculator',
      home: CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';

  void _onPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '';
      } else if (value == '=') {
        try {
          final exp = Expression.parse(_expression.replaceAll('×', '*').replaceAll('÷', '/'));
          final evaluator = const ExpressionEvaluator();
          final evalResult = evaluator.eval(exp, {});
          _result = evalResult.toString();
          _expression += ' = $_result';
        } catch (e) {
          _result = 'Error';
        }
      } else {
        if (_expression.contains('='))
          _expression = '';
        _expression += value;
      }
    });
  }

  Widget _buildButton(String label, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? const Color.fromARGB(255, 251, 212, 141),
            padding: EdgeInsets.symmetric(vertical: 24),
          ),
          onPressed: () => _onPressed(label),
          child: Text(
            label,
            style: TextStyle(fontSize: 24, color: const Color.fromARGB(255, 79, 76, 76)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Dezmond\'s Calculator', style: TextStyle(fontSize: 30, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 17, 94, 157),
      ),
      body: Center(
        child: Container(
          width: 340, // Controls horizontal compression
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Display bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(200, 249, 158, 22),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _expression,
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),

              SizedBox(height: 16), // Tight spacing between display and buttons

              // Button grid
              Column(
                children: [
                  Row(children: ['7', '8', '9', '÷'].map(_buildButton).toList()),
                  Row(children: ['4', '5', '6', '×'].map(_buildButton).toList()),
                  Row(children: ['1', '2', '3', '-'].map(_buildButton).toList()),
                  Row(children: ['0', 'C', '=', '+', '%'].map((label) {
                    return _buildButton(label, color: label == 'C' ? Colors.red : null);
                  }).toList()),
                ],
              ),

              SizedBox(height: 40), // Optional bottom padding
            ],
          ),
        ),
      ),
    );
  }
}