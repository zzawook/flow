/* -------------------------------------------------------------------------- */
/*                           QuickTransferSection                             */
/* -------------------------------------------------------------------------- */

import 'package:flow_mobile/common/flow_button.dart';
import 'package:flutter/widgets.dart';

/// A placeholder section for a "Quick Transfer" feature.
class QuickTransferCard extends StatelessWidget {
  const QuickTransferCard({super.key});


  @override
  Widget build(BuildContext context) {
    return FlowButton(
      onPressed: () {
        Navigator.pushNamed(context, '/transfer');
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 24),
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
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            Image.asset('assets/icons/vector.png', width: 17, height: 17),
          ],
        ),
      ),
    );
  }
}
