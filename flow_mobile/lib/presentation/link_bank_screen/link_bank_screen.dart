import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/redux/actions/refresh_screen_action.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/link_bank_screen/webview_widget.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/service/api_service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LinkBankScreen extends StatefulWidget {
  final String url;
  final Bank bank;

  const LinkBankScreen({super.key, required this.url, required this.bank});

  @override
  State<LinkBankScreen> createState() => _LinkBankScreenState();
}

class _LinkBankScreenState extends State<LinkBankScreen> {
  final _help = _HelpPopoverController();
  String hintFromRemote = "";
  // Build the content shown inside the popover
  Widget _hintContent(Bank bank) {
    final hints = _hintsForBank(bank);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_objects_outlined, size: 18),
              const SizedBox(width: 8),
              Text('Login tips', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              IconButton(
                splashRadius: 15,
                icon: const Icon(Icons.close, size: 18),
                onPressed: _help.hide,
              ),
            ],
          ),
          const Divider(height: 12),
          const SizedBox(height: 8),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (bank.name.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        bank.name,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ...hints.map(
                    (h) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• ",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Expanded(
                            child: Text(
                              h,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 12),
                  if (hintFromRemote.isNotEmpty)
                    Text(
                      "Note from you: $hintFromRemote",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Minimal example hints per bank. Replace/extend from your own source.
  List<String> _hintsForBank(Bank bank) {
    final n = bank.name.toLowerCase();
    if (n.contains('dbs') || n.contains('posb')) {
      return [
        "User ID: 5–20 characters, letters & numbers only",
        "PIN: 4-6 digits number",
      ];
    }
    if (n.contains('ocbc')) {
      return [
        "Access Code: 6-14 alphanumeric characters, no symbols or special characters",
        "PIN: 6 digit number",
      ];
    }
    if (n.contains('uob')) {
      return [
        "Username: 8–24 alphanumeric characters",
        "Password:8-24 alphanumeric characters, no special characters",
      ];
    }
    if (n.contains('standard') || n.contains('stan chart')) {
      return ["Username, Password: 8–16 letters and/or numbers"];
    }
    if (n.contains('maybank')) {
      return [
        "Username: 6–16 alphanumeric characters",
        "Password: 8–12 alphanumeric characters, no special characters except underscore (_)",
      ];
    }
    if (n.contains('hsbc')) {
      return [
        "Username: minimum of 5 characters",
        "Password: 8-30 alphanumeric characters and these special characters: @ _ ' . - ?. Must include at least 1 number and 1 letter",
      ];
    }
    return ["Use the bank’s official username/ID and password format."];
  }

  void _toggleHintOverlay() {
    _help.toggle(
      context,
      _hintContent(widget.bank),
      // tweak the offset to position the bubble relative to your help button
      offset: const Offset(-260, 44),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadHintsForBank();
  }

  void _loadHintsForBank() async {
    final apiService = getIt<ApiService>();
    final hint = await apiService.getLoginMemoForBank(widget.bank);
    if (hint.loginMemo.isNotEmpty) {
      if (mounted) {
        StoreProvider.of<FlowState>(context, listen: false).dispatch(
          UpdateBankLoginMemoAction(bank: widget.bank, memo: hint.loginMemo),
        );
        setState(() {
          hintFromRemote = hint.loginMemo;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlowSafeArea(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          FlowTopBar(
            title: Text(""),
            showBackButton: true,
            onBackPressed: () {
              StoreProvider.of<FlowState>(
                context,
                listen: false,
              ).dispatch(CancelLinkBankingScreenAction(bank: widget.bank));
            },
            leftWidget: CompositedTransformTarget(
              link: _help.link,
              child: FlowButton(
                onPressed: _toggleHintOverlay,
                child: const Icon(Icons.emoji_objects_outlined),
              ),
            ),
          ),
          Expanded(child: WebviewWidget(url: widget.url)),
        ],
      ),
    );
  }
}

class _HelpPopoverController {
  OverlayEntry? _entry;
  final LayerLink link = LayerLink();

  bool get isShown => _entry != null;

  void show(
    BuildContext context,
    Widget content, {
    Offset offset = const Offset(-260, 44),
  }) {
    if (_entry != null) return;

    _entry = OverlayEntry(
      builder: (ctx) => Stack(
        children: [
          // Backdrop to dismiss on outside tap
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: hide,
              child: const SizedBox(),
            ),
          ),
          CompositedTransformFollower(
            link: link,
            showWhenUnlinked: false,
            offset: offset, // position relative to the help button
            child: _PopoverBubble(child: content),
          ),
        ],
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  void hide() {
    _entry?.remove();
    _entry = null;
  }

  void toggle(
    BuildContext context,
    Widget content, {
    Offset offset = const Offset(-260, 44),
  }) {
    isShown ? hide() : show(context, content, offset: offset);
  }

  void dispose() => hide();
}

class _PopoverBubble extends StatelessWidget {
  final Widget child;
  const _PopoverBubble({required this.child});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    return Material(
      elevation: 8,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 280,
            constraints: const BoxConstraints(maxHeight: 360),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: child,
          ),
          // Small arrow
          Positioned(
            top: -6,
            right: 24,
            child: Transform.rotate(
              angle: 0.785398, // 45°
              child: Container(width: 12, height: 12, color: cardColor),
            ),
          ),
        ],
      ),
    );
  }
}
