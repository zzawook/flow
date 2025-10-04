import 'dart:collection';
import 'dart:math';

import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/service/logo_service.dart';
import 'package:flutter/material.dart';

class TopSpendingCluster extends StatefulWidget {
  // ── sample data you supplied ────────────────────────────

  final HashMap<String, List<Transaction>> spendingByBrand;

  /// Width of the design square that drives all relative maths
  final double size;

  /// Tiny negative value hides the drop-shadow seam, 0 = just touch,
  /// positive = leave a gap.
  final double edgeGap;

  const TopSpendingCluster({
    super.key,
    required this.spendingByBrand,
    this.size = 350,
    this.edgeGap = -24, // tighten cluster & mask the shadows
  });

  @override
  State<TopSpendingCluster> createState() => _TopSpendingClusterState();
}

class _TopSpendingClusterState extends State<TopSpendingCluster> {
  List<String> logos = [];
  List<String> brandNames = [];
  List<double> fractions = [];
  @override
  void initState() {
    super.initState();
    calculateLogosAndFractions();
  }

  @override
  void didUpdateWidget(TopSpendingCluster oldWidget) {
    super.didUpdateWidget(oldWidget);
    calculateLogosAndFractions();
  }

  void calculateLogosAndFractions() {
    if (widget.spendingByBrand.isEmpty) {
      setState(() {
        logos = [];
        brandNames = [];
        fractions = [];
      });
      return;
    }
    List<String> topBrands = widget.spendingByBrand.keys.toList()
      ..sort(
        (a, b) => widget.spendingByBrand[b]!.length.compareTo(
          widget.spendingByBrand[a]!.length,
        ),
      );
    topBrands = topBrands.take(5).toList();

    LogoService logoService = getIt<LogoService>();
    final tempLogos = topBrands.map((b) {
      Transaction transaction = widget.spendingByBrand[b]!.first;
      if (transaction.brandDomain.isEmpty) {
        return transaction.brandName;
      }
      return logoService.getLogoUrl(transaction.brandDomain);
    }).toList();

    final tempBrandNames = topBrands.map((b) {
      Transaction transaction = widget.spendingByBrand[b]!.first;
      return transaction.brandName;
    }).toList();

    final top5TotalTransactionsCount = topBrands
        .map((b) => widget.spendingByBrand[b]!.length)
        .reduce((a, b) => a + b);

    setState(() {
      fractions = topBrands
          .map(
            (b) =>
                widget.spendingByBrand[b]!.length / top5TotalTransactionsCount,
          )
          .toList();

      logos = tempLogos;
      brandNames = tempBrandNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (logos.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        child: SizedBox(
          child: Center(
            child: Text(
              'No Spendings to show!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      );
    }

    final n = logos.length;

    // Calculate diameters with constraints to prevent extreme sizes
    final rawDiameters = [for (final f in fractions) f * widget.size];
    final maxRawDiameter = rawDiameters.reduce(max);
    final minRawDiameter = rawDiameters.reduce(min);

    // Apply size constraints based on number of circles
    // REQUIREMENT 2: Bigger circles
    final maxDiameter = n >= 3
        ? widget.size *
              0.30 // Increased from 0.25 to 0.30
        : widget.size * 0.40; // Increased from 0.35 to 0.40

    // Absolute minimum for logo readability (50px minimum)
    final absoluteMinDiameter = 50.0;
    final minDiameter = max(widget.size * 0.12, absoluteMinDiameter);

    // Calculate initial scaled diameters
    var diameters = rawDiameters.map((d) {
      // Scale from raw range to constrained range
      if (maxRawDiameter == minRawDiameter) {
        return maxDiameter; // All equal, use max size
      }
      final normalized =
          (d - minRawDiameter) / (maxRawDiameter - minRawDiameter);
      return minDiameter + normalized * (maxDiameter - minDiameter);
    }).toList();

    // SOLUTION 1: Enforce maximum size ratio to prevent extreme disparities
    // Largest circle should not be more than 2.5x the smallest
    final maxSizeRatio = 2.5;
    final currentMaxDiameter = diameters.reduce(max);
    final currentMinDiameter = diameters.reduce(min);

    if (currentMaxDiameter / currentMinDiameter > maxSizeRatio) {
      // Recalculate with tighter constraints
      final targetMaxDiameter = currentMinDiameter * maxSizeRatio;
      final cappedMaxDiameter = min(targetMaxDiameter, maxDiameter);

      diameters = rawDiameters.map((d) {
        if (maxRawDiameter == minRawDiameter) {
          return cappedMaxDiameter;
        }
        final normalized =
            (d - minRawDiameter) / (maxRawDiameter - minRawDiameter);
        return minDiameter + normalized * (cappedMaxDiameter - minDiameter);
      }).toList();
    }

    final radii = [for (final d in diameters) d / 2];

    final cx = widget.size / 2;
    final cy = widget.size / 2;

    late List<Offset> positions;

    if (n == 1) {
      // Single circle: center it
      positions = [Offset(cx - radii[0], cy - radii[0])];
    } else if (n == 2) {
      // REQUIREMENT 1: Circles meet at border (gap = 0)
      const gap = 0.0;
      final offset = (radii[0] + radii[1] + gap) / 2;
      positions = [
        Offset(cx - offset - radii[0], cy - radii[0]),
        Offset(cx + offset - radii[1], cy - radii[1]),
      ];
    } else if (n == 3) {
      // Horizontal line: biggest on the left, others to the right
      // Calculate center positions first, then convert to top-left
      positions = [];
      const minGap = 0.0;

      // FIX #1: Check for horizontal overflow and scale down if needed
      var workingRadii = List<double>.from(radii);
      var workingDiameters = List<double>.from(diameters);

      var totalSpan =
          workingRadii[0] +
          (workingRadii[0] + workingRadii[1] + minGap) +
          (workingRadii[1] + workingRadii[2] + minGap) +
          workingRadii[2];

      // If span exceeds 90% of container, scale down proportionally
      if (totalSpan > widget.size * 0.9) {
        final scaleFactor = (widget.size * 0.9) / totalSpan;
        workingDiameters = workingDiameters
            .map((d) => d * scaleFactor)
            .toList();
        workingRadii = workingDiameters.map((d) => d / 2).toList();

        // Recalculate totalSpan (should now fit)
        totalSpan =
            workingRadii[0] +
            (workingRadii[0] + workingRadii[1] + minGap) +
            (workingRadii[1] + workingRadii[2] + minGap) +
            workingRadii[2];

        // Update diameters array for rendering
        for (var i = 0; i < 3; i++) {
          diameters[i] = workingDiameters[i];
          radii[i] = workingRadii[i];
        }
      }

      // Calculate center X positions for each circle (touching)
      List<double> centerXPositions = [];
      final startX = cx - totalSpan / 2 + workingRadii[0];

      // Circle 0 (leftmost, biggest)
      centerXPositions.add(startX);

      // Circle 1 (middle) - center-to-center distance from circle 0
      centerXPositions.add(startX + workingRadii[0] + workingRadii[1] + minGap);

      // Circle 2 (rightmost) - center-to-center distance from circle 1
      centerXPositions.add(
        centerXPositions[1] + workingRadii[1] + workingRadii[2] + minGap,
      );

      // Convert center positions to top-left corners (Offset needs top-left)
      for (var i = 0; i < 3; i++) {
        positions.add(
          Offset(centerXPositions[i] - workingRadii[i], cy - workingRadii[i]),
        );
      }
    } else {
      // Four or more: largest at center, others distributed around
      positions = [];

      // Largest circle at center
      positions.add(Offset(cx - radii[0], cy - radii[0]));

      // Calculate orbit radius for satellites
      final satelliteCount = n - 1;
      final angleStep = 2 * pi / satelliteCount;

      // For n=5 (4 satellites): Start at 45° to get 45°, 135°, 225°, 315°
      // For other n≥4: Use 45° offset for diagonal distribution
      final angleOffset = pi / 4; // 45 degrees

      const minGap = 0.0;

      // Find maximum orbit needed to prevent satellite collisions with center
      double orbit = 0;
      for (var i = 1; i < n; i++) {
        final baseOrbit = radii[0] + radii[i] + minGap;
        orbit = max(orbit, baseOrbit);
      }

      // SOLUTION 3: Iterative orbit calculation to handle satellite-to-satellite collisions
      // FIX #4: Increased from 10 to 50 iterations for complex arrangements
      const maxIterations = 50;
      var iteration = 0;
      var hasCollision = true;

      while (hasCollision && iteration < maxIterations) {
        hasCollision = false;
        iteration++;

        for (var i = 1; i < n; i++) {
          for (var j = i + 1; j < n; j++) {
            final angle1 = angleStep * (i - 1) + angleOffset;
            final angle2 = angleStep * (j - 1) + angleOffset;

            final angleDiff = (angle2 - angle1).abs();

            // SOLUTION 4: Protect against division by zero
            if (angleDiff < 0.001) continue;

            final sinHalfAngle = sin(angleDiff / 2);
            if (sinHalfAngle.abs() < 0.001) continue;

            final chordLength = 2 * orbit * sinHalfAngle;
            final minChord = radii[i] + radii[j] + minGap;

            if (chordLength < minChord) {
              final neededOrbit = minChord / (2 * sinHalfAngle);
              orbit = max(orbit, neededOrbit);
              hasCollision = true;
            }
          }
        }
      }

      // FIX #3: Check for orbit overflow and scale down if needed
      // Maximum extent = orbit + max satellite radius (from center to edge of furthest satellite)
      final maxSatelliteRadius = radii.skip(1).reduce(max);
      final clusterRadius = orbit + maxSatelliteRadius;
      final requiredSize = clusterRadius * 2;

      // If cluster exceeds 90% of container, scale everything down
      if (requiredSize > widget.size * 0.9) {
        final scaleFactor = (widget.size * 0.9) / requiredSize;

        // Scale down all diameters and radii
        for (var i = 0; i < n; i++) {
          diameters[i] = diameters[i] * scaleFactor;
          radii[i] = radii[i] * scaleFactor;
        }

        // Recalculate orbit with scaled radii (circles still touch)
        orbit = 0;
        for (var i = 1; i < n; i++) {
          final baseOrbit = radii[0] + radii[i] + minGap;
          orbit = max(orbit, baseOrbit);
        }

        // Re-run collision detection with scaled sizes
        iteration = 0;
        hasCollision = true;

        while (hasCollision && iteration < maxIterations) {
          hasCollision = false;
          iteration++;

          for (var i = 1; i < n; i++) {
            for (var j = i + 1; j < n; j++) {
              final angle1 = angleStep * (i - 1) + angleOffset;
              final angle2 = angleStep * (j - 1) + angleOffset;

              final angleDiff = (angle2 - angle1).abs();

              if (angleDiff < 0.001) continue;

              final sinHalfAngle = sin(angleDiff / 2);
              if (sinHalfAngle.abs() < 0.001) continue;

              final chordLength = 2 * orbit * sinHalfAngle;
              final minChord = radii[i] + radii[j] + minGap;

              if (chordLength < minChord) {
                final neededOrbit = minChord / (2 * sinHalfAngle);
                orbit = max(orbit, neededOrbit);
                hasCollision = true;
              }
            }
          }
        }
      }

      // Position satellites around the center with angular offset
      for (var i = 1; i < n; i++) {
        final angle = angleStep * (i - 1) + angleOffset;
        final centerX = cx + orbit * cos(angle);
        final centerY = cy + orbit * sin(angle);
        positions.add(Offset(centerX - radii[i], centerY - radii[i]));
      }
    }

    // Calculate bounding box
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

    // SOLUTION 6: Smart rendering order - smaller circles on top
    // Create indices sorted by diameter (largest to smallest)
    final indicesWithSizes = List.generate(
      n,
      (i) => {'index': i, 'diameter': diameters[i]},
    );
    indicesWithSizes.sort(
      (a, b) => (b['diameter'] as double).compareTo(a['diameter'] as double),
    );
    final renderOrder = indicesWithSizes
        .map((item) => item['index'] as int)
        .toList();

    // REQUIREMENT 3: Logo sizes proportional to circle diameter
    // Logo = 50% of circle diameter, purely proportional (no minimum)
    final logoSizes = diameters.map((d) => d * 0.5).toList();

    return Container(
      color: Theme.of(context).cardColor,
      width: maxX - minX,
      height: maxY - minY,
      child: Stack(
        children: renderOrder.map((i) {
          final p = positions[i];
          return Positioned(
            left: p.dx - minX,
            top: p.dy - minY,
            child: Container(
              width: diameters[i],
              height: diameters[i],
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: logos[i].startsWith('http')
                    ? ClipOval(
                        child: Image.network(
                          logos[i],
                          width: logoSizes[i],
                          height: logoSizes[i],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: diameters[i] * 0.8,
                                height: diameters[i] * 0.8,
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(0.0),
                                child: Text(
                                  brandNames[i],
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                        ),
                      )
                    : Container(
                        width: diameters[i] * 0.8,
                        height: diameters[i] * 0.8,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          brandNames[i],
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
