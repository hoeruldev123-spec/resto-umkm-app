import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/order_model.dart';
import '../../screens/customer/controllers/cart_controller.dart';
import 'controllers/order_controller.dart';

class OrderStatusScreen extends StatefulWidget {
  final OrderModel order;

  const OrderStatusScreen({super.key, required this.order});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen>
    with TickerProviderStateMixin {
  int _statusIndex = 0;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  static const _labels = ['Menunggu', 'Diproses', 'Selesai'];
  static const _descs = [
    'Pesananmu sudah diterima, menunggu giliran diproses.',
    'Pesananmu sedang dimasak oleh dapur.',
    'Pesanan siap! Silakan lakukan pembayaran di kasir.',
  ];
  static const _icons = [
    Icons.hourglass_top_rounded,
    Icons.restaurant_rounded,
    Icons.check_circle_rounded,
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startSimulation();
  }

  void _startSimulation() {
    _timer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() => _statusIndex = 1);
      OrderController.updateStatus(
          widget.order.queueNumber, OrderStatus.diproses);

      _timer = Timer(const Duration(seconds: 7), () {
        if (!mounted) return;
        setState(() => _statusIndex = 2);
        _pulseController.stop();
        OrderController.updateStatus(
            widget.order.queueNumber, OrderStatus.selesai);
        CartController.cartItems.clear();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  Color get _statusColor {
    if (_statusIndex == 2) return Colors.green;
    if (_statusIndex == 1) return Colors.orange;
    return Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _statusIndex == 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A0A0A),
          foregroundColor: Colors.white,
          automaticallyImplyLeading: _statusIndex == 2,
          elevation: 0,
          title: const Text(
            'Status Pesanan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            if (_statusIndex < 2)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 8,
                          height: 8,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Live',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            children: [
              // --- Nomor Antrian ---
              _buildQueueCard(),
              const SizedBox(height: 20),

              // --- Status Card ---
              _buildStatusCard(),
              const SizedBox(height: 20),

              // --- Step Tracker ---
              _buildStepTracker(),
              const SizedBox(height: 24),

              // --- Detail Pesanan ---
              _buildOrderDetail(),
              const SizedBox(height: 24),

              // --- Info / CTA ---
              if (_statusIndex == 2)
                _buildDoneButton()
              else
                _buildWaitingNote(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQueueCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF1A1A1A), Colors.grey.shade900],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(
            'Nomor Antrian',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
          const SizedBox(height: 10),
          ScaleTransition(
            scale: _statusIndex < 2 ? _pulseAnim : const AlwaysStoppedAnimation(1.0),
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange.withValues(alpha: 0.1),
                border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.5), width: 2.5),
              ),
              child: Center(
                child: Text(
                  '#${widget.order.queueNumber}',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _infoChip(Icons.person_rounded, widget.order.customerName),
              const SizedBox(width: 8),
              _infoChip(
                  Icons.table_restaurant_rounded,
                  'Meja ${widget.order.tableNumber}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white60, size: 14),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _statusColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _statusColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Icon(
              _icons[_statusIndex],
              key: ValueKey(_statusIndex),
              color: _statusColor,
              size: 44,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _labels[_statusIndex],
                    key: ValueKey(_statusIndex),
                    style: TextStyle(
                      color: _statusColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _descs[_statusIndex],
                  style:
                      TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepTracker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: List.generate(3, (i) {
          final done = i <= _statusIndex;
          final isLast = i == 2;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: done ? _statusColor : Colors.grey.shade800,
                          shape: BoxShape.circle,
                          boxShadow: done
                              ? [
                                  BoxShadow(
                                    color: _statusColor.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                  )
                                ]
                              : [],
                        ),
                        child: Icon(_icons[i],
                            color: Colors.white, size: 17),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _labels[i],
                        style: TextStyle(
                          color: done ? Colors.white : Colors.grey.shade600,
                          fontSize: 11,
                          fontWeight:
                              done ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: 2,
                        decoration: BoxDecoration(
                          color: i < _statusIndex
                              ? _statusColor
                              : Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOrderDetail() {
    final order = widget.order;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Row(
              children: [
                Icon(Icons.receipt_long_rounded,
                    color: Colors.orange, size: 18),
                SizedBox(width: 8),
                Text(
                  'Detail Pesanan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          ...order.items.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            final isLast = i == order.items.length - 1;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.menu.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            if (item.selectedAddOns.isNotEmpty)
                              Text(
                                item.selectedAddOns
                                    .map((a) => a.name)
                                    .join(', '),
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 11),
                              ),
                            if (item.note.trim().isNotEmpty)
                              Text(
                                'Catatan: ${item.note}',
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'x${item.quantity}',
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 12),
                          ),
                          Text(
                            'Rp ${item.totalPrice.toInt()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  const Divider(
                      color: Colors.white10,
                      height: 1,
                      indent: 14,
                      endIndent: 14),
              ],
            );
          }),
          const Divider(color: Colors.white10, height: 1),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Tagihan',
                    style: TextStyle(
                        color: Colors.grey.shade400, fontSize: 13)),
                Text(
                  'Rp ${order.totalPrice.toInt()}',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoneButton() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: Colors.green, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Silakan menuju kasir untuk melakukan pembayaran.',
                  style: TextStyle(color: Colors.green, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            icon: const Icon(Icons.home_rounded),
            label: const Text(
              'Kembali ke Beranda',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWaitingNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_clock_rounded,
            color: Colors.grey.shade700, size: 16),
        const SizedBox(width: 6),
        Text(
          'Mohon tunggu, jangan tutup halaman ini.',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      ],
    );
  }
}
