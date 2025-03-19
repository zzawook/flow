import 'package:flow_mobile/presentation/spending_screen/components/special_analysis_card/analysis/demographic_analysis_card.dart';
import 'package:flutter/widgets.dart';

class AnalysisCarousel extends StatefulWidget {
  const AnalysisCarousel({super.key});

  @override
  _AnalysisCarouselState createState() => _AnalysisCarouselState();
}

class _AnalysisCarouselState extends State<AnalysisCarousel>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Example data for each card
  final List<Widget> _cards = [
    DemographicAnalysisCard(
      demographic: 'Male of age 20-24',
      demographicAmount: 2458.68,
      myAmount: 3734.35,
    ),
    DemographicAnalysisCard(
      demographic: 'Female of age 20-24',
      demographicAmount: 1934.22,
      myAmount: 3734.35,
    ),
    DemographicAnalysisCard(
      demographic: 'Male of age 25-29',
      demographicAmount: 2750.10,
      myAmount: 3734.35,
    ),
    DemographicAnalysisCard(
      demographic: 'Female of age 25-29',
      demographicAmount: 2300.50,
      myAmount: 3734.35,
    ),
  ];

  final List<int> heights = [250, 400, 500, 600];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Wrap with AnimatedSize to smoothly animate height changes.
        AnimatedSize(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: SizedBox(
            height: heights[_currentPage].toDouble(),
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: List.generate(_cards.length, (index) {
                // Wrap each card with a Container that has a GlobalKey.
                return _cards[index];
              }),
            ),
          ),
        ),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_cards.length, (index) {
            return buildDot(index);
          }),
        ),
      ],
    );
  }

  Widget buildDot(int index) {
    bool isActive = (index == _currentPage);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF000000) : Color(0xFFD9D9D9),
        shape: BoxShape.circle,
      ),
    );
  }
}
