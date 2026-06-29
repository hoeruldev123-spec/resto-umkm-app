import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../services/firestore_service.dart';
import '../models/order_model.dart';
import '../theme/cashier_theme.dart';

enum ReportPeriod { today, yesterday, thisWeek, thisMonth, thisYear, custom }

class IncomeReportPage extends StatefulWidget {
  const IncomeReportPage({super.key});

  @override
  State<IncomeReportPage> createState() => _IncomeReportPageState();
}

class _IncomeReportPageState extends State<IncomeReportPage> {
  ReportPeriod _period = ReportPeriod.today;
  DateTime _customStart = DateTime.now();
  DateTime _customEnd = DateTime.now();

  List<Order> _allOrders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    FirestoreService.streamCashierOrders().listen((orders) {
      if (mounted) {
        setState(() {
          _allOrders = orders;
          _loading = false;
        });
      }
    });
  }

  DateTimeRange _getRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (_period) {
      case ReportPeriod.today:
        return DateTimeRange(
            start: today, end: today.add(const Duration(days: 1)));
      case ReportPeriod.yesterday:
        return DateTimeRange(
            start: today.subtract(const Duration(days: 1)), end: today);
      case ReportPeriod.thisWeek:
        final weekStart = today.subtract(Duration(days: today.weekday - 1));
        return DateTimeRange(
            start: weekStart, end: today.add(const Duration(days: 1)));
      case ReportPeriod.thisMonth:
        return DateTimeRange(
            start: DateTime(now.year, now.month, 1),
            end: today.add(const Duration(days: 1)));
      case ReportPeriod.thisYear:
        return DateTimeRange(
            start: DateTime(now.year, 1, 1),
            end: today.add(const Duration(days: 1)));
      case ReportPeriod.custom:
        return DateTimeRange(
          start: DateTime(
              _customStart.year, _customStart.month, _customStart.day),
          end: DateTime(_customEnd.year, _customEnd.month, _customEnd.day)
              .add(const Duration(days: 1)),
        );
    }
  }

  List<Order> get _filteredOrders {
    final range = _getRange();
    return _allOrders.where((o) {
      if (o.status != OrderStatus.paid || o.paidAt == null) return false;
      return o.paidAt!.isAfter(range.start) && o.paidAt!.isBefore(range.end);
    }).toList();
  }

  double get _totalRevenue =>
      _filteredOrders.fold(0, (s, o) => s + o.totalAmount);
  int get _totalTransactions => _filteredOrders.length;
  double get _avgTransaction =>
      _totalTransactions == 0 ? 0 : _totalRevenue / _totalTransactions;

  // Group by day for chart/table
  Map<DateTime, _DayStat> get _byDay {
    final map = <DateTime, _DayStat>{};
    for (final o in _filteredOrders) {
      final day = DateTime(o.paidAt!.year, o.paidAt!.month, o.paidAt!.day);
      map[day] ??= _DayStat(date: day);
      map[day]!.revenue += o.totalAmount;
      map[day]!.count++;
    }
    final sorted = map.values.toList()..sort((a, b) => a.date.compareTo(b.date));
    return {for (final s in sorted) s.date: s};
  }

  // Group by month for year view
  Map<int, _MonthStat> get _byMonth {
    final map = <int, _MonthStat>{};
    for (final o in _filteredOrders) {
      final m = o.paidAt!.month;
      map[m] ??= _MonthStat(month: m);
      map[m]!.revenue += o.totalAmount;
      map[m]!.count++;
    }
    return map;
  }

  bool get _useMonthlyChart => _period == ReportPeriod.thisYear;

  String _periodLabel() {
    final fmt = DateFormat('d MMM yyyy', 'id_ID');
    switch (_period) {
      case ReportPeriod.today:
        return 'Hari Ini (${fmt.format(DateTime.now())})';
      case ReportPeriod.yesterday:
        return 'Kemarin (${fmt.format(DateTime.now().subtract(const Duration(days: 1)))})';
      case ReportPeriod.thisWeek:
        return 'Minggu Ini';
      case ReportPeriod.thisMonth:
        return 'Bulan Ini';
      case ReportPeriod.thisYear:
        return 'Tahun Ini (${DateTime.now().year})';
      case ReportPeriod.custom:
        return '${fmt.format(_customStart)} – ${fmt.format(_customEnd)}';
    }
  }

  Future<void> _pickCustomRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _customStart, end: _customEnd),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: CashierTheme.accent,
            onPrimary: Colors.white,
            surface: CashierTheme.surface,
            onSurface: CashierTheme.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _customStart = picked.start;
        _customEnd = picked.end;
        _period = ReportPeriod.custom;
      });
    }
  }

  Future<void> _exportPdf() async {
    final doc = pw.Document();
    final fmtDatetime = DateFormat('d MMM yyyy HH:mm', 'id_ID');
    final fmtTime = DateFormat('HH:mm');
    final cur = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // Sort ascending by paid time
    final orders = List<Order>.from(_filteredOrders)
      ..sort((a, b) =>
          (a.paidAt ?? a.createdAt).compareTo(b.paidAt ?? b.createdAt));

    final totalItemsSold =
        orders.fold<int>(0, (sum, o) => sum + o.totalItems);

    String payLabel(PaymentMethod? m) {
      if (m == PaymentMethod.qris) return 'QRIS';
      if (m == PaymentMethod.cash) return 'Tunai';
      if (m == PaymentMethod.edc) return 'EDC';
      return '-';
    }

    // ── Text styles ──
    const t8 = pw.TextStyle(fontSize: 8);
    final b8 = pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold);
    final b9 = pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);
    final b10 = pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);
    final b11 = pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold);

    // ── Column widths ──
    // A4 usable: 595 - 32*2 = 531pt
    // Fixed: 22+38+62+24+48 = 194; flex 4.5 units fills ~337pt (~75pt/unit)
    final txCols = <int, pw.TableColumnWidth>{
      0: const pw.FixedColumnWidth(22),  // No
      1: const pw.FixedColumnWidth(38),  // Waktu
      2: const pw.FixedColumnWidth(62),  // No. Transaksi
      3: const pw.FlexColumnWidth(2.5),  // Pelanggan
      4: const pw.FixedColumnWidth(24),  // Item
      5: const pw.FixedColumnWidth(48),  // Pembayaran
      6: const pw.FlexColumnWidth(2.0),  // Total
    };

    // Item table: indented 22pt; available ~509pt; flex 7 units ~69pt/unit
    final itemCols = <int, pw.TableColumnWidth>{
      0: const pw.FlexColumnWidth(3),   // Nama Menu
      1: const pw.FixedColumnWidth(26), // Qty
      2: const pw.FlexColumnWidth(2),   // Harga
      3: const pw.FlexColumnWidth(2),   // Subtotal
    };

    // ── Cell helper ──
    pw.Widget c(String text, pw.TextStyle style,
        {pw.TextAlign align = pw.TextAlign.left}) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: pw.Text(text, style: style, textAlign: align),
      );
    }

    // ── Build one widget block per transaction ──
    final List<pw.Widget> txBlocks =
        orders.asMap().entries.map((entry) {
      final idx = entry.key;
      final o = entry.value;
      final trxNo = 'TRX${(idx + 1).toString().padLeft(4, '0')}';
      final pelanggan =
          (o.customerName.isEmpty || o.customerName == '-')
              ? '-'
              : o.customerName;

      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Transaction summary row
          pw.Table(
            border:
                pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
            columnWidths: txCols,
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: idx.isEven ? PdfColors.grey50 : PdfColors.white,
                ),
                children: [
                  c('${idx + 1}', b8, align: pw.TextAlign.center),
                  c(fmtTime.format(o.paidAt!), t8,
                      align: pw.TextAlign.center),
                  c(trxNo, t8),
                  c(pelanggan, t8),
                  c('${o.totalItems}', t8, align: pw.TextAlign.center),
                  c(payLabel(o.paymentMethod), t8,
                      align: pw.TextAlign.center),
                  c(cur.format(o.totalAmount), b8,
                      align: pw.TextAlign.right),
                ],
              ),
            ],
          ),
          // Item detail sub-table (indented to align under col 1+)
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 22),
            child: pw.Table(
              border:
                  pw.TableBorder.all(color: PdfColors.grey400, width: 0.4),
              columnWidths: itemCols,
              children: [
                pw.TableRow(
                  decoration:
                      const pw.BoxDecoration(color: PdfColors.grey100),
                  children: [
                    c('Nama Menu', b8),
                    c('Qty', b8, align: pw.TextAlign.center),
                    c('Harga', b8, align: pw.TextAlign.right),
                    c('Subtotal', b8, align: pw.TextAlign.right),
                  ],
                ),
                ...o.items.map(
                  (item) => pw.TableRow(
                    children: [
                      c(item.name, t8),
                      c('${item.quantity}', t8,
                          align: pw.TextAlign.center),
                      c(cur.format(item.price), t8,
                          align: pw.TextAlign.right),
                      c(cur.format(item.subtotal), t8,
                          align: pw.TextAlign.right),
                    ],
                  ),
                ),
                // Total row
                pw.TableRow(
                  decoration:
                      const pw.BoxDecoration(color: PdfColors.grey100),
                  children: [
                    c('', t8),
                    c('', t8),
                    c('Total', b8, align: pw.TextAlign.right),
                    c(cur.format(o.totalAmount), b8,
                        align: pw.TextAlign.right),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
        ],
      );
    }).toList();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        build: (ctx) => [
          // ══ Header ══
          pw.Center(
            child: pw.Column(children: [
              pw.Text('LAPORAN PENDAPATAN',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 2),
              pw.Text('Restoran UMKM',
                  style: const pw.TextStyle(fontSize: 11)),
            ]),
          ),
          pw.Divider(thickness: 1.5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Periode  : ${_periodLabel()}', style: t8),
              pw.Text(
                  'Dicetak  : ${fmtDatetime.format(DateTime.now())}',
                  style: t8),
            ],
          ),
          pw.SizedBox(height: 12),

          // ══ Ringkasan Statistik ══
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey200,
              border: pw.Border.all(color: PdfColors.grey500, width: 0.8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('RINGKASAN STATISTIK', style: b9),
                pw.SizedBox(height: 5),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Transaksi', style: t8),
                      pw.Text('$_totalTransactions transaksi', style: b8),
                    ]),
                pw.SizedBox(height: 2),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Pendapatan', style: t8),
                      pw.Text(cur.format(_totalRevenue), style: b8),
                    ]),
                pw.SizedBox(height: 2),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Rata-rata Transaksi', style: t8),
                      pw.Text(cur.format(_avgTransaction), style: b8),
                    ]),
              ],
            ),
          ),
          pw.SizedBox(height: 16),

          // ══ Daftar Transaksi ══
          pw.Text('DAFTAR TRANSAKSI', style: b10),
          pw.SizedBox(height: 6),

          // Column header row (standalone table — same column widths as txCols)
          pw.Table(
            border:
                pw.TableBorder.all(color: PdfColors.grey700, width: 0.8),
            columnWidths: txCols,
            children: [
              pw.TableRow(
                decoration:
                    const pw.BoxDecoration(color: PdfColors.blueGrey100),
                children: [
                  c('No', b8, align: pw.TextAlign.center),
                  c('Waktu', b8, align: pw.TextAlign.center),
                  c('No. Transaksi', b8),
                  c('Pelanggan', b8),
                  c('Item', b8, align: pw.TextAlign.center),
                  c('Pembayaran', b8, align: pw.TextAlign.center),
                  c('Total', b8, align: pw.TextAlign.right),
                ],
              ),
            ],
          ),

          if (txBlocks.isEmpty)
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border:
                    pw.Border.all(color: PdfColors.grey400, width: 0.5),
              ),
              child: pw.Center(
                child: pw.Text(
                    'Tidak ada transaksi dalam periode ini.',
                    style: t8),
              ),
            )
          else
            ...txBlocks,

          pw.SizedBox(height: 12),

          // ══ Ringkasan Akhir ══
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
            decoration: pw.BoxDecoration(
              border:
                  pw.Border.all(color: PdfColors.grey800, width: 1.5),
            ),
            child: pw.Column(
              children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Transaksi', style: b9),
                      pw.Text('$_totalTransactions transaksi', style: b9),
                    ]),
                pw.SizedBox(height: 3),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Item Terjual', style: b9),
                      pw.Text('$totalItemsSold item', style: b9),
                    ]),
                pw.Divider(thickness: 0.8, color: PdfColors.grey600),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Pendapatan', style: b11),
                      pw.Text(cur.format(_totalRevenue), style: b11),
                    ]),
                pw.SizedBox(height: 3),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Rata-rata Transaksi', style: b9),
                      pw.Text(cur.format(_avgTransaction), style: b9),
                    ]),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => doc.save(),
      name:
          'Laporan_Pendapatan_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CashierTheme.background,
      appBar: AppBar(
        backgroundColor: CashierTheme.surface,
        title: const Text(
          'Laporan Pendapatan',
          style: TextStyle(
              color: CashierTheme.textPrimary, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: CashierTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded,
                color: CashierTheme.accent),
            tooltip: 'Export PDF',
            onPressed: _exportPdf,
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: CashierTheme.divider),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: CashierTheme.accent))
          : Column(
              children: [
                _PeriodSelector(
                  selected: _period,
                  onChanged: (p) {
                    if (p == ReportPeriod.custom) {
                      _pickCustomRange();
                    } else {
                      setState(() => _period = p);
                    }
                  },
                  periodLabel: _periodLabel(),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    children: [
                      _StatsRow(
                        totalRevenue: _totalRevenue,
                        totalTx: _totalTransactions,
                        avgTx: _avgTransaction,
                      ),
                      const SizedBox(height: 20),
                      _ChartSection(
                        byDay: _byDay,
                        byMonth: _byMonth,
                        useMonthly: _useMonthlyChart,
                      ),
                      const SizedBox(height: 20),
                      _TableSection(byDay: _byDay),
                      const SizedBox(height: 20),
                      _ExportButton(onTap: _exportPdf),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// ─── Data classes ────────────────────────────────────────────────────────────

class _DayStat {
  final DateTime date;
  double revenue = 0;
  int count = 0;
  _DayStat({required this.date});
}

class _MonthStat {
  final int month;
  double revenue = 0;
  int count = 0;
  _MonthStat({required this.month});
}

// ─── Period selector ─────────────────────────────────────────────────────────

class _PeriodSelector extends StatelessWidget {
  final ReportPeriod selected;
  final ValueChanged<ReportPeriod> onChanged;
  final String periodLabel;

  const _PeriodSelector({
    required this.selected,
    required this.onChanged,
    required this.periodLabel,
  });

  @override
  Widget build(BuildContext context) {
    final chips = [
      (ReportPeriod.today, 'Hari Ini'),
      (ReportPeriod.yesterday, 'Kemarin'),
      (ReportPeriod.thisWeek, 'Minggu'),
      (ReportPeriod.thisMonth, 'Bulan'),
      (ReportPeriod.thisYear, 'Tahun'),
      (ReportPeriod.custom, 'Custom'),
    ];

    return Container(
      color: CashierTheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: chips.map((entry) {
                final isSelected = selected == entry.$1;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => onChanged(entry.$1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? CashierTheme.accent
                            : CashierTheme.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? CashierTheme.accent
                              : CashierTheme.divider,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (entry.$1 == ReportPeriod.custom)
                            const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.date_range_rounded,
                                  size: 14, color: Colors.white),
                            ),
                          Text(
                            entry.$2,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : CashierTheme.textSecondary,
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              periodLabel,
              style: const TextStyle(
                  color: CashierTheme.textSecondary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stats row ───────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final double totalRevenue;
  final int totalTx;
  final double avgTx;

  const _StatsRow(
      {required this.totalRevenue,
      required this.totalTx,
      required this.avgTx});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A0E00), Color(0xFF2A1800)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: CashierTheme.accentGold.withOpacity(0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Pendapatan',
                  style: TextStyle(
                      color: CashierTheme.textSecondary, fontSize: 12)),
              const SizedBox(height: 6),
              Text(
                CashierTheme.formatCurrency(totalRevenue),
                style: const TextStyle(
                  color: CashierTheme.accentGold,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Total Transaksi',
                value: '$totalTx',
                unit: 'transaksi',
                icon: Icons.receipt_long_rounded,
                color: CashierTheme.accent,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: 'Rata-rata',
                value: CashierTheme.formatCurrency(avgTx),
                unit: 'per transaksi',
                icon: Icons.trending_up_rounded,
                color: CashierTheme.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CashierTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CashierTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(label,
              style: const TextStyle(
                  color: CashierTheme.textSecondary, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: CashierTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          Text(unit,
              style: const TextStyle(
                  color: CashierTheme.textTertiary, fontSize: 10)),
        ],
      ),
    );
  }
}

// ─── Chart ───────────────────────────────────────────────────────────────────

class _ChartSection extends StatelessWidget {
  final Map<DateTime, _DayStat> byDay;
  final Map<int, _MonthStat> byMonth;
  final bool useMonthly;

  const _ChartSection({
    required this.byDay,
    required this.byMonth,
    required this.useMonthly,
  });

  @override
  Widget build(BuildContext context) {
    final hasData = useMonthly ? byMonth.isNotEmpty : byDay.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CashierTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CashierTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            useMonthly ? 'Pendapatan per Bulan' : 'Pendapatan per Hari',
            style: const TextStyle(
                color: CashierTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: hasData
                ? useMonthly
                    ? _MonthlyBarChart(byMonth: byMonth)
                    : _DailyBarChart(byDay: byDay)
                : const Center(
                    child: Text('Tidak ada data untuk periode ini',
                        style: TextStyle(
                            color: CashierTheme.textSecondary,
                            fontSize: 13)),
                  ),
          ),
        ],
      ),
    );
  }
}

class _DailyBarChart extends StatelessWidget {
  final Map<DateTime, _DayStat> byDay;
  const _DailyBarChart({required this.byDay});

  @override
  Widget build(BuildContext context) {
    final entries = byDay.values.toList();
    final maxRevenue =
        entries.fold<double>(0, (m, s) => s.revenue > m ? s.revenue : m);
    final fmt = DateFormat('d/M');

    return BarChart(
      BarChartData(
        maxY: maxRevenue == 0 ? 100 : maxRevenue * 1.3,
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (_) => const FlLine(
              color: CashierTheme.divider, strokeWidth: 0.5),
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= entries.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    fmt.format(entries[i].date),
                    style: const TextStyle(
                        color: CashierTheme.textSecondary, fontSize: 9),
                  ),
                );
              },
              reservedSize: 22,
            ),
          ),
        ),
        barGroups: List.generate(entries.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: entries[i].revenue,
                color: CashierTheme.accent,
                width: entries.length > 14 ? 6 : 14,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => CashierTheme.card,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                CashierTheme.formatCurrency(rod.toY),
                const TextStyle(
                    color: CashierTheme.accentGold,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MonthlyBarChart extends StatelessWidget {
  final Map<int, _MonthStat> byMonth;
  const _MonthlyBarChart({required this.byMonth});

  static const _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
  ];

  @override
  Widget build(BuildContext context) {
    final maxRevenue =
        byMonth.values.fold<double>(0, (m, s) => s.revenue > m ? s.revenue : m);

    return BarChart(
      BarChartData(
        maxY: maxRevenue == 0 ? 100 : maxRevenue * 1.3,
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (_) => const FlLine(
              color: CashierTheme.divider, strokeWidth: 0.5),
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final m = value.toInt();
                if (m < 1 || m > 12) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _monthNames[m - 1],
                    style: const TextStyle(
                        color: CashierTheme.textSecondary, fontSize: 9),
                  ),
                );
              },
              reservedSize: 22,
            ),
          ),
        ),
        barGroups: List.generate(12, (i) {
          final m = i + 1;
          final stat = byMonth[m];
          return BarChartGroupData(
            x: m,
            barRods: [
              BarChartRodData(
                toY: stat?.revenue ?? 0,
                color: (stat?.revenue ?? 0) > 0
                    ? CashierTheme.accent
                    : CashierTheme.divider,
                width: 14,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => CashierTheme.card,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              if (rod.toY == 0) return null;
              return BarTooltipItem(
                CashierTheme.formatCurrency(rod.toY),
                const TextStyle(
                    color: CashierTheme.accentGold,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─── Table ───────────────────────────────────────────────────────────────────

class _TableSection extends StatelessWidget {
  final Map<DateTime, _DayStat> byDay;
  const _TableSection({required this.byDay});

  @override
  Widget build(BuildContext context) {
    final entries = byDay.values.toList().reversed.toList();
    final fmt = DateFormat('d MMM yyyy', 'id_ID');

    return Container(
      decoration: BoxDecoration(
        color: CashierTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CashierTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'Riwayat Pendapatan Harian',
              style: TextStyle(
                  color: CashierTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(height: 1, color: CashierTheme.divider),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text('Tanggal',
                        style: TextStyle(
                            color: CashierTheme.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 2,
                    child: Text('Transaksi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: CashierTheme.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 3,
                    child: Text('Pendapatan',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: CashierTheme.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Container(height: 1, color: CashierTheme.divider),
          if (entries.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text('Tidak ada data',
                    style: TextStyle(
                        color: CashierTheme.textSecondary, fontSize: 13)),
              ),
            )
          else
            ...entries.asMap().entries.map((e) {
              final i = e.key;
              final stat = e.value;
              final isLast = i == entries.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(fmt.format(stat.date),
                              style: const TextStyle(
                                  color: CashierTheme.textPrimary,
                                  fontSize: 13)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('${stat.count}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: CashierTheme.textPrimary,
                                  fontSize: 13)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                              CashierTheme.formatCurrency(stat.revenue),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  color: CashierTheme.accentGold,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Container(height: 1, color: CashierTheme.divider),
                ],
              );
            }),
        ],
      ),
    );
  }
}

// ─── Export button ───────────────────────────────────────────────────────────

class _ExportButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ExportButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: CashierTheme.accent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text(
              'Export PDF',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
