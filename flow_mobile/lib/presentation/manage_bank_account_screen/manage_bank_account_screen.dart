import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/redux/actions/bank_account_action.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/bank_account_state.dart';
import 'package:flow_mobile/shared/widgets/flow_safe_area.dart';
import 'package:flow_mobile/shared/widgets/flow_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ManageBankAccountScreen extends StatefulWidget {
  final BankAccount bankAccount;

  const ManageBankAccountScreen({super.key, required this.bankAccount});

  @override
  State<ManageBankAccountScreen> createState() =>
      _ManageBankAccountScreenState();
}

class _ManageBankAccountScreenState extends State<ManageBankAccountScreen> {
  Future<void> _editNickname(String initialName) async {
    final controller = TextEditingController(text: initialName);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final primary = Theme.of(ctx).primaryColor;
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change Account Nickname',
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                cursorColor: primary,
                decoration: InputDecoration(
                  hintText: 'Enter new nickname',
                  hintStyle: TextStyle(color: primary.withAlpha(153)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(
                      48,
                    ), // thicker (default ≈ 40–48)
                    shape: RoundedRectangleBorder(
                      // 8-px corner radius
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    StoreProvider.of<FlowState>(context).dispatch(
                      SetBankAccountNameAction(
                        bankAccount: widget.bankAccount,
                        newName: controller.text.trim(),
                      ),
                    );
                    Navigator.pop(ctx);
                  },
                  child: Text('Save', style: Theme.of(ctx).textTheme.bodyLarge),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    Widget settingsRow({
      required String label,
      required Widget trailing,
      VoidCallback? onTap,
    }) {
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(color: onSurface, fontSize: 16)),
              trailing,
            ],
          ),
        ),
      );
    }

    return FlowSafeArea(
      backgroundColor: theme.canvasColor,
      child: Material(
        child: StoreConnector<FlowState, BankAccount>(
          converter: (store) {
            BankAccountState bankAccountState = store.state.bankAccountState;
            for (var bankAccount in bankAccountState.bankAccounts) {
              if (bankAccount.isEqualTo(widget.bankAccount)) {
                return bankAccount;
              }
            }
            return widget.bankAccount;
          },
          builder: (_, bankAccount) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FlowTopBar(title: const SizedBox.shrink()),

                // ── header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bankAccount.accountName,
                        style: theme.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${bankAccount.bank.name} ${bankAccount.accountNumber}',
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: onSurface.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── settings rows
                settingsRow(
                  label: 'Account Nickname',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        bankAccount.accountName,
                        style: TextStyle(
                          color: onSurface.withAlpha(153),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.chevron_right, color: onSurface),
                    ],
                  ),
                  onTap: () => _editNickname(bankAccount.accountName),
                ),

                // settingsRow(
                //   label: 'Exclude from Total Assets',
                //   trailing: Switch.adaptive(
                //     value: widget.bankAccount.isHidden,
                //     onChanged: (v) => setState(() => excludeFromTotal = v),
                //     activeColor: primary,
                //   ),
                // ),

                // ── delete row (inside settings list)
                settingsRow(
                  label: '',
                  trailing: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      // confirm & delete
                    },
                    child: const Text('Delete Account'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
