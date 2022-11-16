import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';

import '../utils/result_state.dart';

class DetailRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  final String idUnik;

  DetailRestaurantProvider({required this.apiService, required this.idUnik}) {
    _getDetailRestaurant(idUnik);
  }

  late DetailRestaurantResult _detailRestaurant;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  DetailRestaurantResult get detailResult => _detailRestaurant;
  ResultState get state => _state;

  Future<dynamic> _getDetailRestaurant(idUnik) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final detailRestaurant = await apiService.detailRestaurant(idUnik);
      if (detailRestaurant.error) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _detailRestaurant = detailRestaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Internet Terputus!';
    }
  }
}
