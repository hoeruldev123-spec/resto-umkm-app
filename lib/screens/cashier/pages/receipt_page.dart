import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../theme/cashier_theme.dart';
import '../widgets/cashier_app_bar.dart';

class ReceiptPage extends StatelessWidget {
  final Order order;
  final PaymentMethod method;
  final double cashPaid;

  const ReceiptPage({
    super.key,
    required this.order,
    required this.method,
    this.cashPaid = 0,
  });

  String get _methodLabel {
    switch (method) {
      case PaymentMethod.qris:
        return 'QRIS';
      case PaymentMethod.edc:
        return 'EDC / Kartu';
      case PaymentMethod.cash:
        return 'Tunai';
    }
  }

  @override
  Widget build(BuildContext context) {
    final change =
        cashPaid > 0 ? cashPaid - order.totalAmount : 0.0;
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: CashierTheme.background,
      appBar: CashierAppBar(
        title: 'Struk Pembayaran',
        actions: [
          IconButton(
            onPressed: () => _showPrintDialog(context),
            icon: const Icon(Icons.print_rounded,
                color: CashierTheme.textPrimary),
            tooltip: 'Cetak Struk',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _ReceiptCard(
              order: order,
              methodLabel: _methodLabel,
              cashPaid: cashPaid,
              change: change,
              now: now,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showPrintDialog(context),
                icon: const Icon(Icons.print_rounded, size: 20),
                label: const Text('Cetak Struk'),
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
              child: OutlinedButton.icon(
                onPressed: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
                icon: const Icon(Icons.home_rounded, size: 20),
                label: const Text('Kembali ke Dashboard'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: CashierTheme.textSecondary,
                  side: const BorderSide(color: CashierTheme.divider),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showPrintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: CashierTheme.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cetak Struk',
            style: TextStyle(color: CashierTheme.textPrimary)),
        content: const Text(
          'Struk berhasil dikirim ke printer.\nPastikan printer terhubung.',
          style: TextStyle(color: CashierTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK',
                style: TextStyle(color: CashierTheme.accent)),
          ),
        ],
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final Order order;
  final String methodLabel;
  final double cashPaid;
  final double change;
  final DateTime now;

  const _ReceiptCard({
    required this.order,
    required this.methodLabel,
    required this.cashPaid,
    required this.change,
    required this.now,
  });

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${_pad(now.hour)}:${_pad(now.minute)}  ${now.day}/${_pad(now.month)}/${now.year}';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: CashierTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CashierTheme.divider),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: CashierTheme.accent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.restaurant_rounded,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Resto UMKM',
                  style: TextStyle(
                    color: CashierTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Jl. Contoh No. 123, Kota',
                  style: TextStyle(
                      color: CashierTheme.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Telp: (021) 123-4567',
                  style: TextStyle(
                      color: CashierTheme.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 16),
                const _DashedDivider(),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: CashierTheme.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: CashierTheme.success.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: CashierTheme.success, size: 14),
                      SizedBox(width: 6),
                      Text(
                        'Pembayaran Berhasil',
                        style: TextStyle(
                          color: CashierTheme.success,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('No. Struk: ${order.id}',
                        style: const TextStyle(
                            color: CashierTheme.textSecondary, fontSize: 12)),
                    Text(timeStr,
                        style: const TextStyle(
                            color: CashierTheme.textSecondary, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('Meja ${order.tableNumber} · ${order.customerName}',
                        style: const TextStyle(
                            color: CashierTheme.textSecondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          // Items
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const _ReceiptRowHeader(),
                const SizedBox(height: 10),
                const Divider(color: CashierTheme.divider, height: 1),
                const SizedBox(height: 10),
                for (final item in order.items) ...[
                  _ReceiptItemRow(item: item),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 4),
                const _DashedDivider(),
                const SizedBox(height: 14),
                _TotalRow(
                    label: 'Subtotal',
                    value: CashierTheme.formatCurrency(order.subtotal)),
                const SizedBox(height: 8),
                _TotalRow(
                    label: 'PPN 10%',
                    value: CashierTheme.formatCurrency(order.tax)),
                const SizedBox(height: 14),
                const Divider(color: CashierTheme.divider, height: 1),
                const SizedBox(height: 14),
                _TotalRow(
                  label: 'TOTAL',
                  value: CashierTheme.formatCurrency(order.totalAmount),
                  isBold: true,
                  valueColor: CashierTheme.accentGold,
                ),
                const SizedBox(height: 8),
                _TotalRow(
                    label: 'Metode Bayar', value: methodLabel),
                if (cashPaid > 0) ...[
                  const SizedBox(height: 8),
                  _TotalRow(
                      label: 'Tunai',
                      value: CashierTheme.formatCurrency(cashPaid)),
                  const SizedBox(height: 8),
                  _TotalRow(
                    label: 'Kembalian',
                    value: CashierTheme.formatCurrency(change),
                    valueColor: CashierTheme.success,
                  ),
                ],
              ],
            ),
          ),

          // Footer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: const Column(
              children: [
                _DashedDivider(),
                SizedBox(height: 16),
                Text(
                  'Terima kasih telah berkunjung!',
                  style: TextStyle(
                    color: CashierTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  'Selamat menikmati makanan Anda',
                  style: TextStyle(
                      color: CashierTheme.textSecondary, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  '★ ★ ★',
                  style: TextStyle(
                      color: CashierTheme.accentGold, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        const dashWidth = 6.0;
        const dashSpace = 4.0;
        final count =
            (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          children: List.generate(
            count,
            (_) => Container(
              width: dashWidth,
              height: 1,
              margin: const EdgeInsets.only(right: dashSpace),
              color: CashierTheme.divider,
            ),
          ),
        );
      },
    );
  }
}

class _ReceiptRowHeader extends StatelessWidget {
  const _ReceiptRowHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          flex: 5,
          child: Text('Item',
              style: TextStyle(
                  color: CashierTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ),
        Expanded(
          flex: 2,
          child: Text('Qty',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: CashierTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ),
        Expanded(
          flex: 3,
          child: Text('Subtotal',
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: CashierTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class _ReceiptItemRow extends StatelessWidget {
  final OrderItem item;

  const _ReceiptItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(
            item.name,
            style: const TextStyle(
                color: CashierTheme.textPrimary, fontSize: 13),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            '${item.quantity}',
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: CashierTheme.textSecondary, fontSize: 13),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            CashierTheme.formatCurrency(item.subtotal),
            textAlign: TextAlign.end,
            style: const TextStyle(
                color: CashierTheme.textPrimary, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _TotalRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold
                ? CashierTheme.textPrimary
                : CashierTheme.textSecondary,
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? CashierTheme.textPrimary,
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
