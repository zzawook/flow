import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/presentation/spending_screen/components/special_analysis_card/analysis/demographic_analysis_card.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AnalysisCarousel extends StatefulWidget {
  const AnalysisCarousel({super.key});

  @override
  State<AnalysisCarousel> createState() => _AnalysisCarouselState();
}

class _AnalysisCarouselState extends State<AnalysisCarousel>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<FlowState, TransactionState>(
      distinct: true,
      converter: (store) => store.state.transactionState,
      builder: (context, transactionState) {
        List<Widget> cards = [
          DemographicAnalysisCard(
            myAmount:
                transactionState
                    .getExpenseForMonth(
                      DateTime(DateTime.now().year, DateTime.now().month),
                    )
                    .abs(),
          ),
        ];

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Wrap with AnimatedSize to smoothly animate height changes.
            AnimatedSize(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: SizedBox(
                height: 250, // Set a fixed height for the carousel
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: List.generate(cards.length, (index) {
                    // Wrap each card with a Container that has a GlobalKey.
                    return cards[index];
                  }),
                ),
              ),
            ),
            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(cards.length, (index) {
                return buildDot(index);
              }),
            ),
          ],
        );
      },
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
