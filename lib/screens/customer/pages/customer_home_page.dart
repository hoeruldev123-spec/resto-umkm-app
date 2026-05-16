import 'package:flutter/material.dart';

import '../data/customer_dummy_data.dart';
import '../models/menu_model.dart';
import '../widgets/menu_card.dart';
import 'menu_detail_page.dart';
import 'cart_page.dart';

class CustomerHomePage extends StatelessWidget {
  const CustomerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    /// MENU FAVORIT
    final favoriteMenus =
        dummyMenus
            .where((menu) => menu.isFavorite)
            .toList();

    /// MAKANAN
    final foods =
        dummyMenus
            .where(
              (menu) =>
                  menu.category == 'Makanan',
            )
            .toList();

    /// MINUMAN
    final drinks =
        dummyMenus
            .where(
              (menu) =>
                  menu.category == 'Minuman',
            )
            .toList();

    return Scaffold(
      backgroundColor: Colors.black,

      /// APPBAR
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
                  builder:
                      (_) => const CartPage(),
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

      /// BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            /// FAVORIT
            buildSectionTitle(
              '🔥 Menu Favorit',
            ),

            const SizedBox(height: 16),

            buildMenuList(
              context,
              favoriteMenus,
            ),

            const SizedBox(height: 30),

            /// MAKANAN
            buildSectionTitle(
              '🍔 Makanan',
            ),

            const SizedBox(height: 16),

            buildMenuList(
              context,
              foods,
            ),

            const SizedBox(height: 30),

            /// MINUMAN
            buildSectionTitle(
              '🥤 Minuman',
            ),

            const SizedBox(height: 16),

            buildMenuList(
              context,
              drinks,
            ),
          ],
        ),
      ),
    );
  }

  /// TITLE SECTION
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

  /// MENU LIST
  Widget buildMenuList(
    BuildContext context,
    List<MenuModel> menus,
  ) {
    return Column(
      children:
          menus.map((menu) {
            return MenuCard(
              menu: menu,

              /// NAVIGASI DETAIL
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => MenuDetailPage(
                          menu: menu,
                        ),
                  ),
                );
              },
            );
          }).toList(),
    );
  }
}