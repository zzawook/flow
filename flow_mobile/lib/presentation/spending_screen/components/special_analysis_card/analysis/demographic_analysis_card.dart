import 'package:flow_mobile/domain/redux/states/spending_screen_state.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flutter/material.dart';

class DemographicAnalysisCard extends StatelessWidget {
  final DateTime displayedMonth;
  final SpendingMedianData? median;
  final double myAmount;
  final bool isLoading;
  final String? error;
  final double height = 250;

  const DemographicAnalysisCard({
    super.key,
    required this.displayedMonth,
    required this.median,
    required this.myAmount,
    required this.isLoading,
    required this.error,
  });

  double getDemographicHeight() {
    final demographicAmount = median?.medianSpending ?? 0;
    if (myAmount == 0) return 100.0;

    if (demographicAmount > myAmount) {
      return 100.0;
    } else {
      return (demographicAmount / myAmount) * 100;
    }
  }

  double getMyHeight() {
    final demographicAmount = median?.medianSpending ?? 0;
    if (demographicAmount == 0) return 100.0;

    if (myAmount > demographicAmount) {
      return 100.0;
    } else {
      return (myAmount / demographicAmount) * 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle error state
    if (error != null) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, color: Color(0xFF565656), size: 48),
              SizedBox(height: 16),
              Text(
                error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Color(0xFF565656),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Handle loading or no data state
    if (isLoading) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF00C864)),
              SizedBox(height: 16),
              Text(
                'Loading comparison data...',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Color(0xFF565656),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (median == null) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No comparison data available yet. \nVisit again later!',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Color(0xFF565656),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final demographicAmount = median!.medianSpending;
    final ageGroupLabel = median!.formattedAgeGroup;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$ageGroupLabel spent',
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
                          ageGroupLabel,
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
