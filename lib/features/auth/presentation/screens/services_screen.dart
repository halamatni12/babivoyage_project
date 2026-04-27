import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/service_api.dart';
import '../widgets/service_card.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ServiceApi();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: const Text("Services"),
      ),
      body: FutureBuilder(
        future: api.getServices(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final services = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: services.map((s) {
              return ServiceCard(
                title: s.title,
                price: "${s.price}\$",
                image: s.image,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}