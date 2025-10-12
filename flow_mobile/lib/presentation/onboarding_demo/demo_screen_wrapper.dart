import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flutter/material.dart';

/// Configuration for an interactive zone within the demo
class InteractiveZoneConfig {
  /// Position of the interactive zone
  final Rect rect;

  /// Callback when the zone is tapped
  final VoidCallback onTap;

  /// Whether to show a visual hint (pulse/glow) on this zone
  final bool showHint;

  InteractiveZoneConfig({
    required this.rect,
    required this.onTap,
    this.showHint = false,
  });
}

/// Wraps a demo screen to control interactions and navigation
class DemoScreenWrapper extends StatefulWidget {
  /// The actual screen content to display
  final Widget child;

  /// List of interactive zones (specific buttons/areas that should work)
  final List<InteractiveZoneConfig> interactiveZones;

  /// Initial scroll offset for multi-step demos
  final double initialScrollOffset;

  /// Scroll controller from parent (if any)
  final ScrollController? scrollController;

  /// Whether to auto-scroll on mount
  final bool autoScroll;

  const DemoScreenWrapper({
    super.key,
    required this.child,
    this.interactiveZones = const [],
    this.initialScrollOffset = 0.0,
    this.scrollController,
    this.autoScroll = true,
  });

  @override
  State<DemoScreenWrapper> createState() => _DemoScreenWrapperState();
}

class _DemoScreenWrapperState extends State<DemoScreenWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    // Set up pulse animation for interactive zones
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Auto-scroll if needed
    if (widget.autoScroll &&
        widget.scrollController != null &&
        widget.initialScrollOffset > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _performAutoScroll();
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _performAutoScroll() {
    widget.scrollController?.animateTo(
      widget.initialScrollOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _onSkipTapped() {
    // Navigate directly to SignupDateOfBirthScreen
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.signupDateOfBirth, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The actual screen content
        AbsorbPointer(
          absorbing: true, // Block all interactions by default
          child: widget.child,
        ),

        // Interactive zones overlay
        ...widget.interactiveZones.map((zone) => _buildInteractiveZone(zone)),

        // Skip button at top-right
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: GestureDetector(
            onTap: _onSkipTapped,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveZone(InteractiveZoneConfig zone) {
    return Positioned(
      left: zone.rect.left,
      top: zone.rect.top,
      width: zone.rect.width,
      height: zone.rect.height,
      child: GestureDetector(
        onTap: zone.onTap,
        child: Container(
          decoration: zone.showHint
              ? BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.3 * _pulseController.value),
                      blurRadius: 12,
                      spreadRadius: 4,
                    ),
                  ],
                )
              : null,
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
