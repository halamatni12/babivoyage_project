import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/favorites/favorites_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final service = FavoritesService();
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    items = await service.getFavorites();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites ❤️"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: items.isEmpty
          ? const Center(child: Text("No favorites yet"))
          : ListView(
              children: items.map((e) {
                return Card(
                  child: ListTile(
                    title: Text(e["title"]),
                    trailing: Icon(
                      e["type"] == "service"
                          ? Icons.spa
                          : Icons.shopping_bag,
                    ),

                    onTap: () {
                      if (e["type"] == "service") {
                        context.push('/booking', extra: e["title"]);
                      } else {
                        context.push('/buy', extra: e["title"]);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
    );
  }
}