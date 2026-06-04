import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../theme/cashier_theme.dart';
import 'receipt_page.dart';

class PaymentSuccessPage extends StatefulWidget {
  final Order order;
  final PaymentMethod method;
  final double cashPaid;

  const PaymentSuccessPage({
    super.key,
    required this.order,
    required this.method,
    this.cashPaid = 0,
  });

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _methodLabel {
    switch (widget.method) {
      case PaymentMethod.qris:
        return 'QRIS';
      case PaymentMethod.edc:
        return 'EDC / Kartu';
      case PaymentMethod.cash:
        return 'Tunai';
    }
  }

  IconData get _methodIcon {
    switch (widget.method) {
      case PaymentMethod.qris:
        return Icons.qr_code_rounded;
      case PaymentMethod.edc:
        return Icons.credit_card_rounded;
      case PaymentMethod.cash:
        return Icons.payments_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final change =
        widget.cashPaid > 0 ? widget.cashPaid - widget.order.totalAmount : 0.0;

    return Scaffold(
      backgroundColor: CashierTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: CashierTheme.success.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: CashierTheme.success.withOpacity(0.4),
                          width: 2),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: CashierTheme.success,
                      size: 52,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Pembayaran Berhasil!',
                  style: TextStyle(
                    color: CashierTheme.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pesanan ${widget.order.id} telah dibayar',
                  style: const TextStyle(
                    color: CashierTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                _InfoCard(
                  order: widget.order,
                  methodLabel: _methodLabel,
                  methodIcon: _methodIcon,
                  change: change,
                ),
                const Spacer(),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReceiptPage(
                              order: widget.order,
                              method: widget.method,
                              cashPaid: widget.cashPaid,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.receipt_long_rounded, size: 20),
                        label: const Text('Lihat Struk'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CashierTheme.accent,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: CashierTheme.textSecondary,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text('Kembali ke Dashboard'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Order order;
  final String methodLabel;
  final IconData methodIcon;
  final double change;

  const _InfoCard({
    required this.order,
    required this.methodLabel,
    required this.methodIcon,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CashierTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CashierTheme.divider),
      ),
      child: Column(
        children: [
          _Row(label: 'Pelanggan', value: order.customerName),
          const SizedBox(height: 10),
          _Row(label: 'Meja', value: 'Meja ${order.tableNumber}'),
          const SizedBox(height: 10),
          _Row(
            label: 'Total',
            value: CashierTheme.formatCurrency(order.totalAmount),
            valueColor: CashierTheme.accentGold,
          ),
          const SizedBox(height: 10),
          _Row(
            label: 'Metode',
            value: methodLabel,
            valueIcon: methodIcon,
          ),
          if (change > 0) ...[
            const SizedBox(height: 10),
            const Divider(color: CashierTheme.divider),
            const SizedBox(height: 10),
            _Row(
              label: 'Kembalian',
              value: CashierTheme.formatCurrency(change),
              valueColor: CashierTheme.success,
            ),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final IconData? valueIcon;

  const _Row({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                color: CashierTheme.textSecondary, fontSize: 13)),
        Row(
          children: [
            if (valueIcon != null) ...[
              Icon(valueIcon,
                  color: valueColor ?? CashierTheme.textPrimary, size: 15),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: TextStyle(
                color: valueColor ?? CashierTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
