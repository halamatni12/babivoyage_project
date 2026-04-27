import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BuyScreen extends StatefulWidget {
  final String product;

  const BuyScreen({super.key, required this.product});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  final nameController = TextEditingController();
  final locationController = TextEditingController();

  void order() {
    if (nameController.text.isEmpty ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Order placed 🎉")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Buy ${widget.product}",
                style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Your Name"),
            ),

            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: "Location"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: order,
              child: const Text("Place Order"),
            )
          ],
        ),
      ),
    );
  }
}