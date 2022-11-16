import 'package:flutter/material.dart';
import 'package:restaurant_app/data/db/favorite_helper.dart';
import 'package:restaurant_app/utils/result_state.dart';

import '../data/model/restaurant.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteHelper favoriteHelper;

  FavoriteProvider({required this.favoriteHelper}) {
    _getFavorite();
  }

  ResultState _state = ResultState.loading;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _favorite = [];
  List<Restaurant> get favorite => _favorite;

  void _getFavorite() async {
    _favorite = await favoriteHelper.getFavorite();
    if (_favorite.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void addFavorite(Restaurant restaurant) async {
    try {
      await favoriteHelper.insertFavorite(restaurant);
      _getFavorite();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    final favoriteRestaurant = await favoriteHelper.getFavoriteById(id);
    return favoriteRestaurant.isNotEmpty;
  }

  void removeBookmark(String id) async {
    try {
      await favoriteHelper.removeFavorite(id);
      _getFavorite();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
