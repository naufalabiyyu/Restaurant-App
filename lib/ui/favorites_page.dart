import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/preference_provider.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';

import '../common/styles.dart';
import '../provider/favorite_provider.dart';
import '../utils/result_state.dart';
import '../widgets/favorite_card_grid.dart';

class FavoritesPage extends StatelessWidget {
  static const String favoriteTitle = 'Favorite';

  const FavoritesPage({super.key});

  Widget _buildList(PreferencesProvider theme) {
    return Consumer<FavoriteProvider>(
      builder: (context, provider, _) {
        if (provider.state == ResultState.hasData) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 214,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: provider.favorite.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              return FavoriteCardGrid(
                restaurant: provider.favorite[index],
                theme: theme,
              );
            },
          );
        } else if (provider.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Text(provider.message),
          );
        }
      },
    );
  }

  Widget _content() {
    return SafeArea(
      child: Material(
        child: ListView(
          children: [
            Consumer<PreferencesProvider>(
              builder: (context, provider, child) {
                return Container(
                  margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Favorites',
                        style: primaryTextStyle.copyWith(
                          fontSize: 24,
                          fontWeight: bold,
                          color: provider.isDarkTheme
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildList(provider)
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _content(),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: _content(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }
}
