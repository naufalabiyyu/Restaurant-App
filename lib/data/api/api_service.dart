import 'dart:convert';

import 'package:http/http.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:http/http.dart' show Client;
import 'package:restaurant_app/data/model/search_restaurant.dart';
import 'package:restaurant_app/data/model/send_review_restaurant.dart';

class ApiService {
  final Client client;
  ApiService(this.client);

  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantResult> dataRestaurant() async {
    final response = await client.get(Uri.parse(_baseUrl + '/list'));
    if (response.statusCode == 200) {
      return RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant result');
    }
  }

  Future<DetailRestaurantResult> detailRestaurant(String idUnik) async {
    final response =
        await client.get(Uri.parse(_baseUrl + '/detail/' + idUnik));
    if (response.statusCode == 200) {
      var result = DetailRestaurantResult.fromJson(json.decode(response.body));
      return result;
    } else {
      throw Exception('Failed to load detail restaurant result');
    }
  }

  Future<SearchRestaurantResult> searchRestaurant(String query) async {
    final response =
        await client.get(Uri.parse(_baseUrl + '/search?q=' + query));
    if (response.statusCode == 200) {
      return SearchRestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load search restaurant result');
    }
  }

  Future<SendReviewRestaurantResult> sendReviewRestaurant({
    String? id,
    String? name,
    String? review,
  }) async {
    var body = {
      'id': id,
      'name': name,
      'review': review,
    };
    final response = await client.post(
        Uri.parse('https://restaurant-api.dicoding.dev/review'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body);

    if (response.statusCode == 201) {
      return SendReviewRestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to send rating restaurant');
    }
  }
}
