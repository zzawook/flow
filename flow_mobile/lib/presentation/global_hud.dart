import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class GlobalHud extends StatelessWidget {
  const GlobalHud({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<FlowState, List<Bank>>(
      converter: (store) =>
          store.state.screenState.refreshScreenState.banksOnLink,
      distinct: true,
      builder: (context, banksOnLink) {
        return IgnorePointer(
          ignoring: true,
          child: FlowSafeArea(
            backgroundColor: Colors.transparent,
            child: Align(
              alignment: Alignment.bottomRight,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: banksOnLink.isNotEmpty
                    ? _HudPill(
                        banksOnLink: banksOnLink,
                        key: const ValueKey('hud-pill'),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HudPill extends StatelessWidget {
  final List<Bank> banksOnLink;
  const _HudPill({super.key, required this.banksOnLink});

  @override
  Widget build(BuildContext context) {
    // Semi-transparent pill with stadium shape (semi-circles top & bottom given narrow width)
    final bg = Theme.of(context).primaryColor.withValues(alpha: 0.2);
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, bottom: 100),
      child: Material(
        color: bg,
        elevation: 6,
        shadowColor: const Color(0x33000000),
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 56, maxWidth: 72),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOutCubic,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final bankOnLink in banksOnLink) ...[
                    _LogoSpinner(assetPath: bankOnLink.assetPath),
                    if (bankOnLink != banksOnLink.last)
                      const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoSpinner extends StatelessWidget {
  final String assetPath;
  const _LogoSpinner({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    const double logoSize = 38;
    const double ringSize = 40; // slightly larger than logo
    return Semantics(
      container: true,
      label: 'Loading',
      liveRegion: true,
      child: SizedBox(
        width: ringSize,
        height: ringSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Subtle circular backdrop for contrast
            Container(
              width: logoSize + 6,
              height: logoSize + 6,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
            ),
            // Bank logo
            Image.asset(
              assetPath,
              width: logoSize,
              height: logoSize,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
            ),
            // Spinner ring
            SizedBox(
              width: ringSize,
              height: ringSize,
              child: CircularProgressIndicator(
                strokeWidth: 2.25,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
