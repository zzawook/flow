import 'dart:math';

import 'package:flutter/material.dart';

class TopSpendingCluster extends StatelessWidget {
  // ── sample data you supplied ────────────────────────────
  final List<String> logos = [
    'assets/icons/transaction_icons/mcdonalds.png',
    'assets/icons/transaction_icons/mcdonalds.png',
    'assets/icons/transaction_icons/mcdonalds.png',
    'assets/icons/transaction_icons/mcdonalds.png',
    'assets/icons/transaction_icons/mcdonalds.png',
  ];

  /// Width of the design square that drives all relative maths
  final double size;

  /// Tiny negative value hides the drop-shadow seam, 0 = just touch,
  /// positive = leave a gap.
  final double edgeGap;

  TopSpendingCluster({
    super.key,
    this.size = 350,
    this.edgeGap = -24, // tighten cluster & mask the shadows
  });

  @override
  Widget build(BuildContext context) {
    // 1️⃣ exact proportions you requested
    final fractions = [0.50, 0.40, 0.30, 0.25, 0.20];
    final diameters = [for (final f in fractions) f * size];
    final radii = [for (final d in diameters) d / 2];

    // 2️⃣ (cx, cy) is the centre of the design square
    final cx = size / 2;
    final cy = size / 2;

    // 3️⃣ angles for the four satellites ─ NE, NW, SW, SE
    final angles = [pi / 4, 3 * pi / 4, 5 * pi / 4, 7 * pi / 4];

    // 4️⃣ compute top–left origins
    final positions = <Offset>[
      Offset(cx - radii[0], cy - radii[0]), // central
      for (var i = 0; i < angles.length; i++)
        () {
          final rSat = radii[i + 1];
          final orbit = radii[0] + rSat + edgeGap; // edge-to-edge rule
          final centreX = cx + orbit * cos(angles[i]);
          final centreY = cy + orbit * sin(angles[i]);
          return Offset(centreX - rSat, centreY - rSat);
        }(),
    ];

    // 5️⃣ bounding box actually required
    double minX = positions.map((p) => p.dx).reduce(min);
    double minY = positions.map((p) => p.dy).reduce(min);
    double maxX = positions
        .asMap()
        .map((i, p) => MapEntry(i, p.dx + diameters[i]))
        .values
        .reduce(max);
    double maxY = positions
        .asMap()
        .map((i, p) => MapEntry(i, p.dy + diameters[i]))
        .values
        .reduce(max);

    // 6️⃣ render
    return SizedBox(
      width: maxX - minX,
      height: maxY - minY,
      child: Stack(
        children: List.generate(logos.length, (i) {
          final p = positions[i];
          return Positioned(
            left: p.dx - minX,
            top: p.dy - minY,
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
