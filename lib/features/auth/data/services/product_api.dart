import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ProductApi {
  final Dio dio = Dio();

  Future<List<ProductModel>> getProducts() async {
    final res1 = await dio.get(
      'https://dummyjson.com/products/category/beauty',
    );

    final res2 = await dio.get(
      'https://dummyjson.com/products/category/fragrances',
    );

    final List all = [
      ...res1.data['products'],
      ...res2.data['products'],
    ];

    return all.map((e) => ProductModel.fromJson(e)).toList();
  }
}