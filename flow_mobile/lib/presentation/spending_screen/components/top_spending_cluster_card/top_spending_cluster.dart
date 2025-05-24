import 'dart:math';
import 'package:flutter/material.dart';

class TopSpendingCluster extends StatelessWidget {
  // your five transparent‐background logos
  final List<String> logos = [
    'assets/icons/transaction_icons/mcdonalds.png',
    'assets/icons/transaction_icons/mcdonalds.png',
    'assets/icons/transaction_icons/mcdonalds.png',
    'assets/icons/transaction_icons/mcdonalds.png',
    'assets/icons/transaction_icons/mcdonalds.png',
  ];

  /// “design” size used to compute relative diameters & positions
  final double size;

  TopSpendingCluster({this.size = 350, super.key});

  @override
  Widget build(BuildContext context) {
    // 1) fixed fractions for “1st > 2nd > …”
    final fractions = <double>[0.5, 0.4, 0.3, 0.25, 0.2];
    final diameters = fractions.map((f) => f * size).toList();

    // 2) how much they overlap (0 = just touch; >0 = deeper overlap)
    const overlapFactor = 0.4;

    // 3) “center” of cluster in our design-space
    final cx = size * 0.5;
    final cy = size * 0.38; // shift up slightly to reduce top-blank

    // 4) compute each child’s (left, top) in the design-space
    final positions = <Offset>[];
    for (var i = 0; i < logos.length; i++) {
      final dia = diameters[i];
      final r = dia / 2;
      double left, top;

      if (i == 0) {
        // largest one in the middle
        left = cx - r;
        top = cy - r;
      } else {
        // satellites at 45°, 135°, 225°, 315°
        final angle = pi / 4 + (i - 1) * (2 * pi / 4);
        final r0 = diameters[0] / 2;
        final distance = r0 + r - overlapFactor * min(r0, r);

        left = cx + distance * cos(angle) - r;
        top = cy + distance * sin(angle) - r;
      }

      positions.add(Offset(left, top));
    }

    // 5) figure out the bounding box of all circles
    double minTop = positions.first.dy;
    double maxBottom = positions.first.dy + diameters.first;
    for (var i = 1; i < positions.length; i++) {
      minTop = min(minTop, positions[i].dy);
      maxBottom = max(maxBottom, positions[i].dy + diameters[i]);
    }
    final clusterHeight = maxBottom - minTop;

    // 6) build a Stack in a SizedBox whose height == exactly the cluster’s height
    return SizedBox(
      width: size,
      height: clusterHeight,
      child: Stack(
        children: List.generate(logos.length, (i) {
          final pos = positions[i];
          return Positioned(
            left: pos.dx,
            // shift everything up by -minTop so the topmost circle sits at y=0
            top: pos.dy - minTop,
            child: ClipOval(
              child: Image.asset(
                logos[i],
                width: diameters[i],
                height: diameters[i],
                fit: BoxFit.cover,
              ),
            ),
          );
        }),
      ),
    );
  }
}
