import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ added
import 'package:babibeauty_app/features/auth/data/services/notification_service.dart';

import '../../data/services/service_api.dart';
import '../../data/models/service_model.dart';
import '../widgets/service_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final api = ServiceApi();

  List<ServiceModel> services = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
    setupNotifications(); 
  }

  void setupNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((message) {
      print("📩 Notification received!");

      NotificationService.show(
        message.notification?.title ?? "No title",
        message.notification?.body ?? "No body",
      );
    });
  }

  void load() async {
    final result = await api.getServices();
    setState(() {
      services = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3F5),

      appBar: AppBar(
        title: const Text("BabiBeauty"),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.push('/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.push('/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () => context.push('/orders'),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => context.push('/booking', extra: "My Bookings"),
          ),

          // ✅ FINAL LOGOUT
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (!context.mounted) return;

              context.go('/login'); // 🔁 go to login
            },
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [

                const Text(
                  "Hello Dear",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [

                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.push('/services'),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.pink.withOpacity(0.15),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.spa, color: Colors.pink),
                              Text("Services"),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.push('/products'),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.pink.withOpacity(0.15),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_bag, color: Colors.pink),
                              Text("Products"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  "Top Services",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                ...services.map(
                  (service) => ServiceCard(
                    title: service.title,
                    price: "${service.price}\$",
                    image: service.image,
                  ),
                ),
              ],
            ),
    );
  }
}