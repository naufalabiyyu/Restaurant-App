import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/send_review_restaurant.dart';

class SendReviewRestaurantProvider extends ChangeNotifier {
  SendReviewRestaurantResult? _sendReview;
  String _message = '';

  String get message => _message;
  SendReviewRestaurantResult? get sendReview => _sendReview;

  Future<dynamic> sendRating({
    String? id,
    String? name,
    String? review,
  }) async {
    try {
      SendReviewRestaurantResult sendReview =
          await ApiService(Client()).sendReviewRestaurant(
        id: id,
        name: name,
        review: review,
      );
      notifyListeners();
      _sendReview = sendReview;
      return true;
    } catch (e) {
      notifyListeners();
      _message = 'Data not match';
      return false;
    }
  }
}
