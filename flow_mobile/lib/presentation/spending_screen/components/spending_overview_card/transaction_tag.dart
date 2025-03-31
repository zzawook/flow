import 'package:flutter/widgets.dart';

class TransactionTag extends StatelessWidget {
  final String tag;
  final tagColorMap = {
    'Food': {
      'containerColor': Color(0x4815FF00),
      'textColor': Color(0xFF228319),
    },
    'Transport': {
      'containerColor': Color(0x329747FF),
      'textColor': Color(0xFF9747FF),
    },
    'Groceries': {
      'containerColor': Color.fromARGB(120, 9, 77, 204),
      'textColor': Color.fromARGB(255, 9, 77, 204),
    },
    'Utilities': {
      'containerColor': Color(0xFF00C864),
      'textColor': Color(0xFF00C864),
    },
    'Health': {
      'containerColor': Color(0xFF00C864),
      'textColor': Color(0xFF00C864),
    },
    'Entertainment': {
      'containerColor': Color.fromARGB(120, 200, 0, 0),
      'textColor': Color.fromARGB(255, 200, 0, 0),
    },
    'Transfer': {
      'containerColor': Color(0x48BDBDBD),
      'textColor': Color(0xFF70757A),
    },
    'Others': {
      'containerColor': Color(0xFF00C864),
      'textColor': Color(0xFF00C864),
    },
  };

  TransactionTag({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tagColorMap[tag]?['containerColor'],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          tag,
          style: TextStyle(
            fontFamily: 'Inter', 
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: tagColorMap[tag]?['textColor'],
          ),
        ),
      ),
    );
  }
}
