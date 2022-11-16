import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/preference_provider.dart';
import 'package:restaurant_app/provider/search_restaurant_provider.dart';

import '../utils/result_state.dart';
import '../widgets/search_card.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search_page';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  String queries = '';

  Widget _searchResultData(BuildContext context, PreferencesProvider theme) {
    return Consumer<SearchRestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.state == ResultState.hasData) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.searchResult.restaurants.length,
            itemBuilder: (context, index) {
              var restaurant = state.searchResult.restaurants[index];
              return SearchCard(
                restaurant: restaurant,
                theme: theme,
              );
            },
          );
        } else if (state.state == ResultState.noData) {
          return const Center(
            child: Text('Restaurant yang kamu cari tidak tersedia'),
          );
        } else if (state.state == ResultState.error) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const Center(
            child: Text(''),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchRestaurantProvider>(
      create: (_) => SearchRestaurantProvider(
        apiService: ApiService(Client()),
      ),
      child: Consumer<SearchRestaurantProvider>(
        builder: (context, state, _) {
          return Consumer<PreferencesProvider>(
            builder: (context, theme, child) {
              return Scaffold(
                backgroundColor: theme.isDarkTheme ? darkColor : Colors.white,
                appBar: AppBar(
                  backgroundColor: theme.isDarkTheme ? darkColor : Colors.white,
                  iconTheme: const IconThemeData(
                    color: Color(0xff969698),
                  ),
                  leading: IconButton(
                    icon: Image.asset(
                      'assets/images/arrow-left.png',
                      width: 20,
                      height: 20,
                    ),
                    onPressed: () => Navigation.back(),
                  ),
                  elevation: 0,
                ),
                body: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Find Your Restaurant',
                            style: primaryTextStyle.copyWith(
                              fontSize: 32,
                              fontWeight: semiBold,
                              color: theme.isDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Enter everything here.',
                            style: primaryTextStyle.copyWith(
                              fontSize: 14,
                              color: const Color(0xff969698),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  queries = value;
                                });
                                state.fetchSearchRestaurant(value);
                              },
                              autofocus: true,
                              cursorColor: bgColor,
                              controller: _controller,
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "Cari Restaurant...",
                                hintStyle: const TextStyle(fontSize: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: queries.isEmpty
                          ? const Center(child: Text(''))
                          : _searchResultData(context, theme),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
