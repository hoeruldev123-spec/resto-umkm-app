import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../theme/cashier_theme.dart';
import '../widgets/cashier_app_bar.dart';
import 'payment_success_page.dart';

class CashPaymentPage extends StatefulWidget {
  final Order order;

  const CashPaymentPage({super.key, required this.order});

  @override
  State<CashPaymentPage> createState() => _CashPaymentPageState();
}

class _CashPaymentPageState extends State<CashPaymentPage> {
  double _cashPaid = 0;
  bool _isProcessing = false;

  double get _change =>
      _cashPaid >= widget.order.totalAmount ? _cashPaid - widget.order.totalAmount : 0;

  bool get _canConfirm => _cashPaid >= widget.order.totalAmount;

  void _selectAmount(double amount) => setState(() => _cashPaid = amount);

  void _confirm() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    widget.order.status = OrderStatus.paid;
    widget.order.paymentMethod = PaymentMethod.cash;
    widget.order.paidAt = DateTime.now();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSuccessPage(
          order: widget.order,
          method: PaymentMethod.cash,
          cashPaid: _cashPaid,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.order.totalAmount;
    final suggestions = _buildSuggestions(total);

    return Scaffold(
      backgroundColor: CashierTheme.background,
      appBar: CashierAppBar(
        title: 'Bayar Tunai',
        subtitle: widget.order.id,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BillSummary(total: total),
                  const SizedBox(height: 24),
                  _CashDisplay(cashPaid: _cashPaid, change: _change, total: total),
                  const SizedBox(height: 24),
                  const Text(
                    'Nominal Uang Diterima',
                    style: TextStyle(
                      color: CashierTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SuggestionGrid(
                    suggestions: suggestions,
                    selected: _cashPaid,
                    onSelect: _selectAmount,
                  ),
                  const SizedBox(height: 20),
                  _Numpad(
                    current: _cashPaid,
                    onChanged: (v) => setState(() => _cashPaid = v),
                  ),
                ],
              ),
            ),
          ),
          _BottomBar(
            canConfirm: _canConfirm,
            isProcessing: _isProcessing,
            change: _change,
            onConfirm: _confirm,
          ),
        ],
      ),
    );
  }

  List<double> _buildSuggestions(double total) {
    final s = <double>{
      (total / 1000).ceil() * 1000.0,
      (total / 5000).ceil() * 5000.0,
      (total / 10000).ceil() * 10000.0,
      (total / 50000).ceil() * 50000.0,
    };
    return s.toList()..sort();
  }
}

class _BillSummary extends StatelessWidget {
  final double total;

  const _BillSummary({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A00), Color(0xFF2A1800)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CashierTheme.accentGold.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Text('Total yang Harus Dibayar',
              style: TextStyle(color: CashierTheme.textSecondary, fontSize: 13)),
          const SizedBox(height: 8),
          Text(
            CashierTheme.formatCurrency(total),
            style: const TextStyle(
              color: CashierTheme.accentGold,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CashDisplay extends StatelessWidget {
  final double cashPaid;
  final double change;
  final double total;

  const _CashDisplay({
    required this.cashPaid,
    required this.change,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final isEnough = cashPaid >= total;
    final diff = cashPaid - total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CashierTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cashPaid == 0
              ? CashierTheme.divider
              : isEnough
                  ? CashierTheme.success.withValues(alpha: 0.4)
                  : CashierTheme.error.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Uang Diterima',
                  style: TextStyle(
                      color: CashierTheme.textSecondary, fontSize: 13)),
              Text(
                cashPaid == 0
                    ? '—'
                    : CashierTheme.formatCurrency(cashPaid),
                style: TextStyle(
                  color: cashPaid == 0
                      ? CashierTheme.textTertiary
                      : CashierTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (cashPaid > 0) ...[
            const SizedBox(height: 12),
            const Divider(color: CashierTheme.divider, height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEnough ? 'Kembalian' : 'Kurang',
                  style: const TextStyle(
                      color: CashierTheme.textSecondary, fontSize: 13),
                ),
                Text(
                  CashierTheme.formatCurrency(diff.abs()),
                  style: TextStyle(
                    color:
                        isEnough ? CashierTheme.success : CashierTheme.error,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SuggestionGrid extends StatelessWidget {
  final List<double> suggestions;
  final double selected;
  final ValueChanged<double> onSelect;

  const _SuggestionGrid({
    required this.suggestions,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 3.5,
      children: suggestions.map((amount) {
        final isSelected = selected == amount;
        return GestureDetector(
          onTap: () => onSelect(amount),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? CashierTheme.accentGold.withValues(alpha: 0.15)
                  : CashierTheme.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? CashierTheme.accentGold
                    : CashierTheme.divider,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Center(
              child: Text(
                CashierTheme.formatCurrency(amount),
                style: TextStyle(
                  color: isSelected
                      ? CashierTheme.accentGold
                      : CashierTheme.textSecondary,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Numpad extends StatelessWidget {
  final double current;
  final ValueChanged<double> onChanged;

  const _Numpad({required this.current, required this.onChanged});

  String get _display => current == 0 ? '' : current.toStringAsFixed(0);

  void _input(BuildContext context, String digit) {
    if (digit == '⌫') {
      if (_display.isNotEmpty) {
        final newStr = _display.substring(0, _display.length - 1);
        onChanged(newStr.isEmpty ? 0 : double.parse(newStr));
      }
    } else if (digit == '000') {
      final newStr = '${_display}000';
      if (newStr.length <= 9) onChanged(double.parse(newStr));
    } else {
      final newStr = '$_display$digit';
      if (newStr.length <= 9) onChanged(double.parse(newStr));
    }
  }

  @override
  Widget build(BuildContext context) {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '000', '0', '⌫'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CashierTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('atau masukkan manual',
              style: TextStyle(
                  color: CashierTheme.textTertiary, fontSize: 12)),
          const SizedBox(height: 14),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.2,
            children: keys.map((key) {
              return GestureDetector(
                onTap: () => _input(context, key),
                child: Container(
                  decoration: BoxDecoration(
                    color: key == '⌫'
                        ? CashierTheme.error.withValues(alpha: 0.1)
                        : CashierTheme.cardElevated,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      key,
                      style: TextStyle(
                        color: key == '⌫'
                            ? CashierTheme.error
                            : CashierTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final bool canConfirm;
  final bool isProcessing;
  final double change;
  final VoidCallback onConfirm;

  const _BottomBar({
    required this.canConfirm,
    required this.isProcessing,
    required this.change,
    required this.onConfirm,
  });

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
          onPressed: (canConfirm && !isProcessing) ? onConfirm : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                canConfirm ? CashierTheme.success : CashierTheme.card,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: isProcessing
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5),
                )
              : Text(
                  canConfirm
                      ? 'Konfirmasi · Kembalian ${CashierTheme.formatCurrency(change)}'
                      : 'Nominal Belum Cukup',
                ),
        ),
      ),
    );
  }
}
