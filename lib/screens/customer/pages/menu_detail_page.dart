import 'package:flutter/material.dart';

import '../controllers/cart_controller.dart';
import '../models/addon_model.dart';
import '../models/cart_item_model.dart';
import '../models/menu_model.dart';

class MenuDetailPage extends StatefulWidget {
  final MenuModel menu;

  const MenuDetailPage({
    super.key,
    required this.menu,
  });

  @override
  State<MenuDetailPage> createState() =>
      _MenuDetailPageState();
}

class _MenuDetailPageState
    extends State<MenuDetailPage> {
  final List<AddOnModel> selectedAddOns = [];

  final TextEditingController noteController =
      TextEditingController();

  int quantity = 1;

  /// TOTAL PRICE
  double get totalPrice {
    double addonsPrice = selectedAddOns.fold(
      0,
      (sum, item) => sum + item.price,
    );

    return (widget.menu.price + addonsPrice) *
        quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            /// IMAGE
            Image.asset(
              widget.menu.image,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,

              /// ERROR IMAGE
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.grey.shade900,

                  child: const Center(
                    child: Icon(
                      Icons.fastfood,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                );
              },
            ),

            /// CONTENT
            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  /// MENU NAME
                  Text(
                    widget.menu.name,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// DESCRIPTION
                  Text(
                    widget.menu.description,

                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// BASE PRICE
                  Text(
                    'Rp ${widget.menu.price.toInt()}',

                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// ADD ONS TITLE
                  const Text(
                    'Add Ons',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// ADD ONS LIST
                  Column(
                    children:
                        widget.menu.addOns.map((
                          addon,
                        ) {
                          final isSelected =
                              selectedAddOns.contains(
                                addon,
                              );

                          return Container(
                            margin:
                                const EdgeInsets.only(
                                  bottom: 10,
                                ),

                            decoration: BoxDecoration(
                              color:
                                  Colors.grey.shade900,
                              borderRadius:
                                  BorderRadius.circular(
                                    16,
                                  ),
                            ),

                            child: CheckboxListTile(
                              activeColor:
                                  Colors.orange,

                              checkboxShape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                          5,
                                        ),
                                  ),

                              value: isSelected,

                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    selectedAddOns.add(
                                      addon,
                                    );
                                  } else {
                                    selectedAddOns
                                        .remove(
                                          addon,
                                        );
                                  }
                                });
                              },

                              title: Text(
                                addon.name,

                                style:
                                    const TextStyle(
                                      color:
                                          Colors.white,
                                      fontWeight:
                                          FontWeight
                                              .w500,
                                    ),
                              ),

                              subtitle: Text(
                                '+ Rp ${addon.price.toInt()}',

                                style: const TextStyle(
                                  color:
                                      Colors.orange,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 30),

                  /// NOTE TITLE
                  const Text(
                    'Catatan',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// NOTE INPUT
                  TextField(
                    controller: noteController,

                    maxLines: 3,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration: InputDecoration(
                      hintText:
                          'Contoh: tidak pedas, tanpa bawang',

                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                      ),

                      filled: true,
                      fillColor:
                          Colors.grey.shade900,

                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                              16,
                            ),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// QUANTITY
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                    children: [
                      const Text(
                        'Quantity',

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      Row(
                        children: [
                          /// MINUS
                          IconButton(
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },

                            icon: Container(
                              padding:
                                  const EdgeInsets.all(
                                    8,
                                  ),

                              decoration:
                                  const BoxDecoration(
                                    color:
                                        Colors.orange,
                                    shape:
                                        BoxShape.circle,
                                  ),

                              child: const Icon(
                                Icons.remove,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          /// QTY NUMBER
                          Text(
                            quantity.toString(),

                            style:
                                const TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize: 22,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                          ),

                          const SizedBox(width: 8),

                          /// PLUS
                          IconButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },

                            icon: Container(
                              padding:
                                  const EdgeInsets.all(
                                    8,
                                  ),

                              decoration:
                                  const BoxDecoration(
                                    color:
                                        Colors.orange,
                                    shape:
                                        BoxShape.circle,
                                  ),

                              child: const Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// TOTAL BOX
                  Container(
                    padding: const EdgeInsets.all(
                      20,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),

                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [
                        const Text(
                          'Total',

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Text(
                          'Rp ${totalPrice.toInt()}',

                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// BUTTON ADD CART
                  SizedBox(
                    width: double.infinity,
                    height: 60,

                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.orange,

                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    18,
                                  ),
                            ),
                          ),

                      onPressed: () {
                        CartController.addToCart(
                          CartItemModel(
                            menu: widget.menu,
                            selectedAddOns:
                                List.from(selectedAddOns),
                            quantity: quantity,
                            note: noteController.text,
                          ),
                        );

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Berhasil ditambahkan ke keranjang',
                            ),
                          ),
                        );
                      },

                      child: const Text(
                        'Tambah ke Keranjang',

                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}