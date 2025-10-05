import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyAssetBarChart extends StatelessWidget {
  /// six points, newest is usually today
  final Map<DateTime, double> last6MonthlyAssetData;

  /// normal bar colour
  final Color normalBarColor;

  /// colour for the bar whose date == today
  final Color todayBarColor;

  /// width of each bar in logical pixels
  final double barWidth;

  /// vertical space between bar and labels
  final double labelGap;

  const MonthlyAssetBarChart({
    super.key,
    required this.last6MonthlyAssetData,
    this.normalBarColor = const Color(0xFF5A5A5A),
    this.todayBarColor = const Color(0xFF50C878),
    this.barWidth = 45,
    this.labelGap = 8,
  });

  @override
  Widget build(BuildContext context) {
    // chronological order, oldest → newest
    final entries = last6MonthlyAssetData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final maxY = entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    final numberFmt = NumberFormat.compact(locale: 'en_SG');
    final monthFmt = DateFormat('MMM'); // Jan, Feb …

    return LayoutBuilder(
      builder: (context, constraints) {
        // leave vertical room for both labels
        final availableH = constraints.maxHeight - 2 * (20 + labelGap);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: entries.map((e) {
            final date = e.key;
            final value = e.value;
            final height = (value / maxY) * availableH;

            final isToday =
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day;

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // ── top label
                Text(
                  numberFmt.format(value),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.labelMedium?.color?.withValues(alpha: 80),
                  ),
                ),
                SizedBox(height: labelGap),

                // ── bar
                Container(
                  width: barWidth,
                  height: height,
                  decoration: BoxDecoration(
                    color: isToday ? todayBarColor : normalBarColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(height: labelGap),

                // ── month label
                Text(
                  monthFmt.format(date),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
