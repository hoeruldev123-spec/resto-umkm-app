import 'package:flutter/material.dart';
import 'pages/cashier_dashboard_page.dart';
import 'theme/cashier_theme.dart';

// ============================================================
// PETUNJUK INTEGRASI UNTUK ANGGOTA 1 (Core & Testing)
// ============================================================
// Untuk menghubungkan modul kasir ke navigasi utama,
// Anggota 1 cukup menambahkan kode berikut di file yang sesuai:
//
// Import:
//   import 'package:resto_umkm_app/screens/cashier/cashier_main.dart';
//
// Navigasi ke kasir (contoh dari role_selection_screen.dart):
//   onPressed: () => Navigator.push(
//     context,
//     MaterialPageRoute(builder: (_) => const CashierMain()),
//   ),
// ============================================================

/// Widget utama modul kasir.
/// Membungkus CashierDashboardPage dengan dark theme khusus kasir.
/// Tidak mengubah ThemeData global maupun MaterialApp.
class CashierMain extends StatelessWidget {
  const CashierMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: CashierTheme.theme,
      child: const CashierDashboardPage(),
    );
  }
}
