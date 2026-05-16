import '../models/menu_model.dart';
import '../models/addon_model.dart';

List<MenuModel> dummyMenus = [
  // ================= MAKANAN =================

  MenuModel(
    id: 1,
    name: 'Burger Beef',
    image:
        'assets/images/customer/foods/burger_beef.jpg',
    description: 'Burger daging sapi premium.',
    price: 35000,
    category: 'Makanan',
    isFavorite: true,

    addOns: [
      AddOnModel(
        name: 'Extra Cheese',
        price: 5000,
      ),
      AddOnModel(
        name: 'French Fries',
        price: 8000,
      ),
      AddOnModel(
        name: 'BBQ Sauce',
        price: 3000,
      ),
    ],
  ),

  MenuModel(
    id: 2,
    name: 'Pizza Italian',
    image:
        'assets/images/customer/foods/pizza_italian.jpg',
    description: 'Pizza keju mozzarella.',
    price: 55000,
    category: 'Makanan',
    isFavorite: true,

    addOns: [
      AddOnModel(
        name: 'Extra Mozzarella',
        price: 10000,
      ),
      AddOnModel(
        name: 'Saus Sambal',
        price: 3000,
      ),
    ],
  ),

  MenuModel(
    id: 3,
    name: 'Chicken Steak',
    image:
        'assets/images/customer/foods/chicken_steak.jpg',
    description: 'Steak ayam crispy.',
    price: 42000,
    category: 'Makanan',
    isFavorite: false,

    addOns: [
      AddOnModel(
        name: 'Extra Sauce',
        price: 5000,
      ),
      AddOnModel(
        name: 'Mashed Potato',
        price: 7000,
      ),
    ],
  ),

  MenuModel(
    id: 4,
    name: 'French Fries',
    image:
        'assets/images/customer/foods/french_fries.jpg',
    description: 'Kentang goreng crispy.',
    price: 18000,
    category: 'Makanan',
    isFavorite: false,

    addOns: [
      AddOnModel(
        name: 'Cheese Sauce',
        price: 4000,
      ),
      AddOnModel(
        name: 'Mayonnaise',
        price: 3000,
      ),
    ],
  ),

  MenuModel(
    id: 5,
    name: 'Fried Rice',
    image:
        'assets/images/customer/foods/fried_rice.jpg',
    description: 'Nasi goreng spesial.',
    price: 28000,
    category: 'Makanan',
    isFavorite: true,

    addOns: [
      AddOnModel(
        name: 'Telur',
        price: 5000,
      ),
      AddOnModel(
        name: 'Sosis',
        price: 7000,
      ),
    ],
  ),

  MenuModel(
    id: 6,
    name: 'Spaghetti',
    image:
        'assets/images/customer/foods/spaghetti.jpg',
    description: 'Spaghetti bolognese.',
    price: 40000,
    category: 'Makanan',
    isFavorite: false,

    addOns: [
      AddOnModel(
        name: 'Extra Meat',
        price: 9000,
      ),
      AddOnModel(
        name: 'Extra Cheese',
        price: 6000,
      ),
    ],
  ),

  MenuModel(
    id: 7,
    name: 'Hot Dog',
    image:
        'assets/images/customer/foods/hot_dog.jpg',
    description: 'Hotdog sosis jumbo.',
    price: 25000,
    category: 'Makanan',
    isFavorite: false,

    addOns: [
      AddOnModel(
        name: 'Extra Sausage',
        price: 7000,
      ),
      AddOnModel(
        name: 'Cheese',
        price: 5000,
      ),
    ],
  ),

  MenuModel(
    id: 8,
    name: 'Chicken Burger',
    image:
        'assets/images/customer/foods/chicken_burger.jpg',
    description: 'Burger ayam crispy.',
    price: 32000,
    category: 'Makanan',
    isFavorite: true,

    addOns: [
      AddOnModel(
        name: 'Cheese',
        price: 5000,
      ),
      AddOnModel(
        name: 'French Fries',
        price: 8000,
      ),
    ],
  ),

  MenuModel(
    id: 9,
    name: 'Sushi',
    image:
        'assets/images/customer/foods/sushi.jpg',
    description: 'Sushi Jepang premium.',
    price: 60000,
    category: 'Makanan',
    isFavorite: false,

    addOns: [
      AddOnModel(
        name: 'Wasabi',
        price: 3000,
      ),
      AddOnModel(
        name: 'Extra Salmon',
        price: 12000,
      ),
    ],
  ),

  MenuModel(
    id: 10,
    name: 'Ramen',
    image:
        'assets/images/customer/foods/ramen.jpg',
    description: 'Ramen kuah pedas.',
    price: 45000,
    category: 'Makanan',
    isFavorite: true,

    addOns: [
      AddOnModel(
        name: 'Egg',
        price: 5000,
      ),
      AddOnModel(
        name: 'Extra Noodles',
        price: 7000,
      ),
    ],
  ),

  // ================= MINUMAN =================

  MenuModel(
    id: 11,
    name: 'Ice Coffee',
    image:
        'assets/images/customer/drinks/ice_coffee.jpg',
    description: 'Kopi dingin segar.',
    price: 20000,
    category: 'Minuman',
    isFavorite: true,

    addOns: [
      AddOnModel(
        name: 'Extra Shot',
        price: 5000,
      ),
      AddOnModel(
        name: 'Boba',
        price: 4000,
      ),
    ],
  ),

  MenuModel(
    id: 12,
    name: 'Matcha Latte',
    image:
        'assets/images/customer/drinks/matcha_latte.jpg',
    description: 'Matcha premium Jepang.',
    price: 28000,
    category: 'Minuman',
    isFavorite: true,

    addOns: [
      AddOnModel(
        name: 'Whipped Cream',
        price: 5000,
      ),
      AddOnModel(
        name: 'Boba',
        price: 4000,
      ),
    ],
  ),

  MenuModel(
    id: 13,
    name: 'Chocolate Milk',
    image:
        'assets/images/customer/drinks/chocolate_milk.jpg',
    description: 'Susu coklat creamy.',
    price: 22000,
    category: 'Minuman',
    isFavorite: false,

    addOns: [
      AddOnModel(
        name: 'Extra Chocolate',
        price: 4000,
      ),
    ],
  ),

  MenuModel(
    id: 14,
    name: 'Orange Juice',
    image:
        'assets/images/customer/drinks/orange_juice.jpg',
    description: 'Jus jeruk segar.',
    price: 18000,
    category: 'Minuman',
    isFavorite: false,

    addOns: [
      AddOnModel(
        name: 'Extra Ice',
        price: 2000,
      ),
    ],
  ),

  MenuModel(
    id: 15,
    name: 'Avocado Juice',
    image:
        'assets/images/customer/drinks/avocado_juice.jpg',
    description: 'Jus alpukat creamy.',
    price: 25000,
    category: 'Minuman',
    isFavorite: true,

    addOns: [
      AddOnModel(
        name: 'Chocolate Syrup',
        price: 4000,
      ),
    ],
  ),

  MenuModel(
    id: 16,
    name: 'Strawberry Milkshake',
    image:
        'assets/images/customer/drinks/strawberry_milkshake.jpg',
    description: 'Milkshake strawberry.',
    price: 30000,
    category: 'Minuman',
    isFavorite: false,

    addOns: [
      AddOnModel(
        name: 'Whipped Cream',
        price: 5000,
      ),
    ],
  ),

  MenuModel(
    id: 17,
    name: 'Thai Tea',
    image:
        'assets/images/customer/drinks/thai_tea.jpg',
    description: 'Thai tea dingin.',
    price: 19000,
    category: 'Minuman',
    isFavorite: true,

    addOns: [
      AddOnModel(
        name: 'Boba',
        price: 4000,
      ),
      AddOnModel(
        name: 'Extra Milk',
        price: 3000,
      ),
    ],
  ),

  MenuModel(
    id: 18,
    name: 'Lemon Tea',
    image:
        'assets/images/customer/drinks/lemon_tea.jpg',
    description: 'Es lemon tea.',
    price: 17000,
    category: 'Minuman',
    isFavorite: false,

    addOns: [
      AddOnModel(
        name: 'Extra Lemon',
        price: 3000,
      ),
    ],
  ),

  MenuModel(
    id: 19,
    name: 'Cappuccino',
    image:
        'assets/images/customer/drinks/cappuccino.jpg',
    description: 'Cappuccino panas.',
    price: 26000,
    category: 'Minuman',
    isFavorite: true,

    addOns: [
      AddOnModel(
        name: 'Extra Shot',
        price: 5000,
      ),
    ],
  ),

  MenuModel(
    id: 20,
    name: 'Mojito',
    image:
        'assets/images/customer/drinks/mojito.jpg',
    description: 'Minuman mojito segar.',
    price: 27000,
    category: 'Minuman',
    isFavorite: false,

    addOns: [
      AddOnModel(
        name: 'Extra Mint',
        price: 3000,
      ),
      AddOnModel(
        name: 'Extra Lemon',
        price: 3000,
      ),
    ],
  ),
];