import 'package:flutter/material.dart';
import '../theme/cashier_theme.dart';

class CashierAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;

  const CashierAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showBack = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CashierTheme.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leading: showBack
          ? Padding(
              padding: const EdgeInsets.only(left: 16),
              child: GestureDetector(
                onTap: onBack ?? () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: CashierTheme.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: CashierTheme.divider),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                    color: CashierTheme.textPrimary,
                  ),
                ),
              ),
            )
          : null,
      title: subtitle != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: CashierTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: CashierTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            )
          : Text(
              title,
              style: const TextStyle(
                color: CashierTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
      actions: [
        if (actions != null) ...actions!,
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: CashierTheme.divider),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
