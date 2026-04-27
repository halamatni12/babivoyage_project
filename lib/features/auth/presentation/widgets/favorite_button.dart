import 'package:flutter/material.dart';
import '../../data/favorites/favorites_service.dart';

class FavoriteButton extends StatefulWidget {
  final String title;
  final String type; 

  const FavoriteButton({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final service = FavoritesService();
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    isFav = await service.isFavorite(widget.title);
    if (mounted) setState(() {});
  }

  void toggle() async {
    await service.toggle({
      "title": widget.title,
      "type": widget.type,
    });

    isFav = !isFav;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: Colors.pink,
      ),
      onPressed: toggle,
    );
  }
}