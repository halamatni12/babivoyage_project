import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/order_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final service = OrderService();
  List orders = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    orders = await service.getOrders();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),

      body: orders.isEmpty
          ? const Center(child: Text("No orders yet"))
          : ListView(
              children: orders.map((o) {
                return Card(
                  child: ListTile(
                    title: Text(o["name"]),
                    subtitle: Text(
                        "📍 ${o["location"]}\n🛒 ${o["items"].join(", ")}"),
                  ),
                );
              }).toList(),
            ),
    );
  }
}