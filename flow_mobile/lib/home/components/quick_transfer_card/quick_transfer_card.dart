/* -------------------------------------------------------------------------- */
/*                           QuickTransferSection                             */
/* -------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

/// A placeholder section for a "Quick Transfer" feature.
class QuickTransferCard extends StatelessWidget {
  const QuickTransferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Quick transfer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Color(0x7B7A7A7A)),
        ],
      ),
    );
  }
}
