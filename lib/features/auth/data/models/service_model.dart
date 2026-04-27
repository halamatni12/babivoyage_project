class ServiceModel {
  final String title;
  final double price;
  final String image;

  ServiceModel({
    required this.title,
    required this.price,
    required this.image,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
    );
  }
}