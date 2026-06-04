import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../theme/cashier_theme.dart';
import '../widgets/cashier_app_bar.dart';
import 'cash_payment_page.dart';
import 'edc_payment_page.dart';
import 'qris_payment_page.dart';

class PaymentMethodPage extends StatefulWidget {
  final Order order;

  const PaymentMethodPage({super.key, required this.order});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  PaymentMethod? _selected;

  void _proceed() {
    if (_selected == null) return;
    Widget page;
    switch (_selected!) {
      case PaymentMethod.qris:
        page = QrisPaymentPage(order: widget.order);
      case PaymentMethod.edc:
        page = EdcPaymentPage(order: widget.order);
      case PaymentMethod.cash:
        page = CashPaymentPage(order: widget.order);
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CashierTheme.background,
      appBar: const CashierAppBar(title: 'Metode Pembayaran'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AmountCard(amount: widget.order.totalAmount),
                  const SizedBox(height: 28),
                  const Text(
                    'Pilih Metode Pembayaran',
                    style: TextStyle(
                      color: CashierTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _MethodCard(
                    method: PaymentMethod.qris,
                    selected: _selected,
                    icon: Icons.qr_code_2_rounded,
                    title: 'QRIS',
                    subtitle: 'Customer scan QRIS tempelan warung',
                    accentColor: CashierTheme.accent,
                    onTap: () => setState(() => _selected = PaymentMethod.qris),
                  ),
                  const SizedBox(height: 12),
                  _MethodCard(
                    method: PaymentMethod.edc,
                    selected: _selected,
                    icon: Icons.credit_card_rounded,
                    title: 'EDC / Kartu',
                    subtitle: 'Debit, kredit, atau kartu prepaid',
                    accentColor: CashierTheme.blue,
                    onTap: () => setState(() => _selected = PaymentMethod.edc),
                  ),
                  const SizedBox(height: 12),
                  _MethodCard(
                    method: PaymentMethod.cash,
                    selected: _selected,
                    icon: Icons.payments_rounded,
                    title: 'Tunai',
                    subtitle: 'Bayar dengan uang tunai',
                    accentColor: CashierTheme.accentGold,
                    onTap: () => setState(() => _selected = PaymentMethod.cash),
                  ),
                ],
              ),
            ),
          ),
          _BottomBar(selected: _selected, onProceed: _proceed),
        ],
      ),
    );
  }
}

class _AmountCard extends StatelessWidget {
  final double amount;

  const _AmountCard({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A1A), Color(0xFF2A1800)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CashierTheme.accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Text(
            'Total Pembayaran',
            style: TextStyle(color: CashierTheme.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            CashierTheme.formatCurrency(amount),
            style: const TextStyle(
              color: CashierTheme.accentGold,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Sudah termasuk PPN 10%',
            style: TextStyle(color: CashierTheme.textTertiary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final PaymentMethod method;
  final PaymentMethod? selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  const _MethodCard({
    required this.method,
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == method;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.1)
              : CashierTheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? accentColor : CashierTheme.divider,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? accentColor : CashierTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: CashierTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? accentColor : CashierTheme.textTertiary,
                  width: 2,
                ),
                color: isSelected ? accentColor : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final PaymentMethod? selected;
  final VoidCallback onProceed;

  const _BottomBar({required this.selected, required this.onProceed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: const BoxDecoration(
        color: CashierTheme.surface,
        border: Border(top: BorderSide(color: CashierTheme.divider)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: selected != null ? onProceed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                selected != null ? CashierTheme.accent : CashierTheme.card,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: Text(
            selected != null ? 'Lanjutkan Pembayaran' : 'Pilih Metode Dulu',
          ),
        ),
      ),
    );
  }
}
