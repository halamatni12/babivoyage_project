import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/cart_service.dart';
import '../../data/services/order_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartService = CartService();
  final orderService = OrderService();

  List items = [];

  final nameController = TextEditingController();
  final locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    items = await cartService.getCart();
    setState(() {});
  }

  void removeItem(int index) async {
    await cartService.remove(index);
    load();
  }

  void checkout() async {
    if (nameController.text.isEmpty ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    await orderService.addOrder({
      "name": nameController.text,
      "location": locationController.text,
      "items": items,
    });

    await cartService.clear();
    load();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Order placed 🎉")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),

      body: items.isEmpty
          ? const Center(child: Text("Cart is empty 🛒"))
          : Column(
              children: [

                Expanded(
                  child: ListView(
                    children: items.asMap().entries.map((entry) {
                      final i = entry.key;
                      final item = entry.value;

                      return ListTile(
                        title: Text(item),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => removeItem(i),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                TextField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: "Your Name"),
                ),

                TextField(
                  controller: locationController,
                  decoration:
                      const InputDecoration(labelText: "Location"),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: checkout,
                  child: const Text("Checkout"),
                ),
              ],
            ),
    );
  }
}