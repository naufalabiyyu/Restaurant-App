import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';

import '../data/model/restaurant.dart';
import '../utils/result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  late RestaurantResult _dataRestaurant;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  RestaurantResult get result => _dataRestaurant;
  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.dataRestaurant();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _dataRestaurant = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Internet Terputus';
    }
  }
}
