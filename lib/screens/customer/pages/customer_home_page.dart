import 'package:flutter/material.dart';

import '../../../services/firestore_service.dart';
import '../data/customer_dummy_data.dart';
import '../models/menu_model.dart';
import '../widgets/menu_card.dart';
import 'cart_page.dart';
import 'menu_detail_page.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  late final Future<List<MenuModel>> _menusFuture;

  @override
  void initState() {
    super.initState();
    _menusFuture = FirestoreService.fetchMenus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'UMKM Restaurant',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: FutureBuilder<List<MenuModel>>(
        future: _menusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Gagal memuat menu. Coba lagi.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final menus =
              snapshot.data?.isNotEmpty == true ? snapshot.data! : dummyMenus;
          if (menus.isEmpty) {
            return const Center(
              child: Text(
                'Menu belum tersedia.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final favoriteMenus = menus.where((menu) => menu.isFavorite).toList();
          final foods = menus
              .where((menu) => menu.category.toLowerCase().contains('makanan'))
              .toList();
          final drinks = menus
              .where((menu) => menu.category.toLowerCase().contains('minuman'))
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSectionTitle('🔥 Menu Favorit'),
                const SizedBox(height: 16),
                buildMenuList(context, favoriteMenus),
                const SizedBox(height: 30),
                buildSectionTitle('🍔 Makanan'),
                const SizedBox(height: 16),
                buildMenuList(context, foods),
                const SizedBox(height: 30),
                buildSectionTitle('🥤 Minuman'),
                const SizedBox(height: 16),
                buildMenuList(context, drinks),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildMenuList(BuildContext context, List<MenuModel> menus) {
    return Column(
      children: menus.map((menu) {
        return MenuCard(
          menu: menu,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MenuDetailPage(menu: menu),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
