import '../models/service_model.dart';

class ServiceApi {
  Future<List<ServiceModel>> getServices() async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      return [
        ServiceModel(
          title: "Hair Styling",
          price: 50,
          image: "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e",
        ),
        ServiceModel(
          title: "Makeup",
          price: 80,
          image: "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f",
        ),
        ServiceModel(
          title: "Facial Care",
          price: 60,
          image: "https://images.unsplash.com/photo-1515377905703-c4788e51af15",
        ),
        ServiceModel(
          title: "Nail Art",
          price: 40,
          image: "https://images.unsplash.com/photo-1604654894610-df63bc536371",
        ),
        ServiceModel(
          title: "Spa Relaxation",
          price: 100,
          image: "https://images.unsplash.com/photo-1506126613408-eca07ce68773",
        ),
      ];
    } catch (e) {
      throw Exception("Failed to load services");
    }
  }
}