import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/search_restaurant.dart';

import '../utils/result_state.dart';

class SearchRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchRestaurantProvider({required this.apiService}) {
    fetchSearchRestaurant(query);
  }

  late SearchRestaurantResult _searchRestaurant;
  late ResultState _state;
  String _message = '';
  String _query = '';

  String get message => _message;
  SearchRestaurantResult get searchResult => _searchRestaurant;
  ResultState get state => _state;
  String get query => _query;

  Future<dynamic> fetchSearchRestaurant(String query) async {
    try {
      _state = ResultState.loading;
      _query = query;
      final searchRestaurant = await apiService.searchRestaurant(query);
      if (searchRestaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _searchRestaurant = searchRestaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Internet Terputus!';
    }
  }
}
