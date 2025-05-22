import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class DemographicAnalysisCard extends StatelessWidget {
  late String demographic = "";
  late double demographicAmount = 1;
  final double myAmount;
  final double height = 250;

  DemographicAnalysisCard({super.key, required this.myAmount}) {
    setDemographic();
  }

  void setDemographic() {
    demographic = "Male of age 20-24";
    demographicAmount = 2458.68;
  }

  double getDemographicHeight() {
    if (demographicAmount > myAmount) {
      return 100.0;
    } else {
      return (demographicAmount / myAmount) * 100;
    }
  }

  double getMyHeight() {
    if (myAmount > demographicAmount) {
      return 100.0;
    } else {
      return (myAmount / demographicAmount) * 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$demographic spent',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF565656),
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '\$${demographicAmount.toStringAsFixed(2)} ',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00C864),
                    ),
                  ),
                  Text(
                    'on average',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF565656),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 16),
                height: 160,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          demographicAmount.toStringAsFixed(2),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: Color(0xFF565656),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: getDemographicHeight(),
                          decoration: BoxDecoration(
                            color: Color(0xFFC6C6C6),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '20-24 Male',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Color(0xFF565656),
                          ),
                        ),
                      ],
                    ),
                    FlowSeparatorBox(width: 40),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          myAmount.toStringAsFixed(2),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: Color(0xFF565656),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: getMyHeight(),
                          decoration: BoxDecoration(
                            color: Color(0xFF50C878),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'You',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Color(0xFF565656),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
