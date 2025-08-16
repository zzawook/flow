import 'package:flow_mobile/domain/entities/entities.dart';
import 'package:flow_mobile/presentation/setting_screen/shared.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/shared/flow_text_edit_bottom_sheet.dart';

class ManageBankAccountScreen extends ConsumerStatefulWidget {
  final BankAccount bankAccount;

  const ManageBankAccountScreen({super.key, required this.bankAccount});

  @override
  ConsumerState<ManageBankAccountScreen> createState() =>
      _ManageBankAccountScreenState();
}

class _ManageBankAccountScreenState extends ConsumerState<ManageBankAccountScreen> {
  Future<void> _editNickname(String initialName) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (ctx) => FlowTextEditBottomSheet(
            title: 'Change Account Nickname',
            initialValue: initialName,
            hintText: 'Enter new nickname',
            saveButtonText: 'Save',
            onSave: (newName) {
              final updatedAccount = widget.bankAccount.copyWith(accountName: newName);
              ref.read(bankAccountNotifierProvider.notifier)
                  .updateBankAccount(updatedAccount);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return FlowSafeArea(
      backgroundColor: theme.canvasColor,
      child: Material(
        child: Consumer(
          builder: (context, ref, child) {
            final bankAccounts = ref.watch(bankAccountsProvider);
            final bankAccount = bankAccounts.firstWhere(
              (account) => account.accountNumber == widget.bankAccount.accountNumber,
              orElse: () => widget.bankAccount,
            );
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
                SettingTab(
                  title: 'Account Nickname',
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
                SettingTab(
                  title: '',
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
