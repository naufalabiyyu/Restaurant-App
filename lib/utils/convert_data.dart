import '../data/model/detail_restaurant.dart';
import '../data/model/restaurant.dart';

Restaurant toConvertRestaurantDetailItemToRestaurant(
    DetailRestaurant restaurantDetailItem) {
  return Restaurant(
      id: restaurantDetailItem.id,
      name: restaurantDetailItem.name,
      description: restaurantDetailItem.description,
      pictureId: restaurantDetailItem.pictureId,
      city: restaurantDetailItem.city,
      rating: restaurantDetailItem.rating);
}
