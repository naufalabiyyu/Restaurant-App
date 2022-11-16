import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

import 'api_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  group('fetchRestaurant', () {
    test(
      'returns an Restaurant if the http call completes successfully',
      () async {
        final client = MockClient();

        when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
            .thenAnswer(
          (_) async => http.Response(
              '{"error": false,"message": "success","count": 20,"restaurants": []}',
              200),
        );

        expect(
            await ApiService(client).dataRestaurant(), isA<RestaurantResult>());
      },
    );
  });
}
