import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flow_mobile/presentation/spending_screen/components/special_analysis_card/analysis_carousel.dart';
import 'package:flutter/material.dart';

/// Special Analysis Section
class SpecialAnalysisCard extends StatelessWidget {
  const SpecialAnalysisCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Special Analysis by ',
                style: TextStyle(
                  fontFamily: 'Inter', 
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              Text(
                'FLOW',
                style: TextStyle(
                  fontFamily: 'Inter', 
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00C864),
                ),
              ),
            ],
          ),
          FlowSeparatorBox(height: 16),
          AnalysisCarousel(),
        ],
      ),
    );
  }
}
