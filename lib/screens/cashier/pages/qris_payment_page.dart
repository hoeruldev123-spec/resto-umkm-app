import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../theme/cashier_theme.dart';
import '../widgets/cashier_app_bar.dart';
import 'payment_success_page.dart';

class QrisPaymentPage extends StatefulWidget {
  final Order order;

  const QrisPaymentPage({super.key, required this.order});

  @override
  State<QrisPaymentPage> createState() => _QrisPaymentPageState();
}

class _QrisPaymentPageState extends State<QrisPaymentPage> {
  bool _isConfirming = false;

  void _confirm() async {
    setState(() => _isConfirming = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    widget.order.status = OrderStatus.paid;
    widget.order.paymentMethod = PaymentMethod.qris;
    widget.order.paidAt = DateTime.now();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSuccessPage(
          order: widget.order,
          method: PaymentMethod.qris,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CashierTheme.background,
      appBar: CashierAppBar(
        title: 'Pembayaran QRIS',
        subtitle: widget.order.id,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _AmountCard(amount: widget.order.totalAmount),
                  const SizedBox(height: 24),
                  const _QrisInfoBanner(),
                  const SizedBox(height: 16),
                  const _StepGuide(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          _BottomBar(isConfirming: _isConfirming, onConfirm: _confirm),
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

class _QrisInfoBanner extends StatelessWidget {
  const _QrisInfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CashierTheme.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CashierTheme.accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: CashierTheme.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.qr_code_2_rounded,
              color: CashierTheme.accent,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bayar via QRIS Tempelan',
                  style: TextStyle(
                    color: CashierTheme.accent,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Arahkan customer ke QRIS tempelan yang ada di meja atau kasir warung',
                  style: TextStyle(
                    color: CashierTheme.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepGuide extends StatelessWidget {
  const _StepGuide();

  @override
  Widget build(BuildContext context) {
    const steps = [
      (Icons.person_rounded, 'Customer buka aplikasi dompet digital'),
      (Icons.qr_code_scanner_rounded, 'Scan QRIS tempelan yang ada di warung'),
      (Icons.check_circle_outline_rounded, 'Tunggu konfirmasi pembayaran dari customer'),
      (Icons.touch_app_rounded, 'Klik "Konfirmasi Pembayaran" setelah selesai'),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CashierTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Alur Pembayaran QRIS',
            style: TextStyle(
              color: CashierTheme.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          for (int i = 0; i < steps.length; i++) ...[
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: CashierTheme.accent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: CashierTheme.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(steps[i].$1, color: CashierTheme.textSecondary, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    steps[i].$2,
                    style: const TextStyle(
                      color: CashierTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            if (i < steps.length - 1) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 13),
                child: Container(width: 1, height: 14, color: CashierTheme.divider),
              ),
              const SizedBox(height: 4),
            ],
          ],
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final bool isConfirming;
  final VoidCallback onConfirm;

  const _BottomBar({required this.isConfirming, required this.onConfirm});

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
        child: ElevatedButton.icon(
          onPressed: isConfirming ? null : onConfirm,
          icon: isConfirming
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Icon(Icons.check_circle_rounded, size: 20),
          label: Text(isConfirming ? 'Menyimpan...' : 'Konfirmasi Pembayaran'),
          style: ElevatedButton.styleFrom(
            backgroundColor: CashierTheme.success,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
