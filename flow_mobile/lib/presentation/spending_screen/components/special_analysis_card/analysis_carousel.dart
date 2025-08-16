import 'package:flow_mobile/presentation/spending_screen/components/special_analysis_card/analysis/demographic_analysis_card.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalysisCarousel extends ConsumerStatefulWidget {
  const AnalysisCarousel({super.key});

  @override
  ConsumerState<AnalysisCarousel> createState() => _AnalysisCarouselState();
}

class _AnalysisCarouselState extends ConsumerState<AnalysisCarousel>
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
    final transactionState = ref.watch(transactionStateProvider);
    final currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
    
    // Calculate expense for current month
    final monthExpense = transactionState.transactions
        .where((transaction) {
          return transaction.date.year == currentMonth.year &&
                 transaction.date.month == currentMonth.month &&
                 transaction.amount < 0;
        })
        .fold(0.0, (sum, transaction) => sum + transaction.amount)
        .abs();
    
    List<Widget> cards = [
      DemographicAnalysisCard(
        myAmount: monthExpense,
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
