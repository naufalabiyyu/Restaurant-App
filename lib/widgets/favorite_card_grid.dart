import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../common/navigation.dart';
import '../common/styles.dart';
import '../data/model/restaurant.dart';
import '../provider/favorite_provider.dart';
import '../provider/preference_provider.dart';
import '../ui/detail_page.dart';

class FavoriteCardGrid extends StatelessWidget {
  // final int gridCount;
  Restaurant restaurant;
  PreferencesProvider theme;

  FavoriteCardGrid({
    Key? key,
    // required this.gridCount,
    required this.restaurant,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavorite(restaurant.id!),
          builder: (context, snapshot) {
            var isFavorite = snapshot.data ?? false;
            return GestureDetector(
              onTap: () {
                Navigation.intentWithData(DetailPage.routeName, restaurant.id!);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: theme.isDarkTheme ? secondartDarkColor : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                            width: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: isFavorite
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.favorite,
                                        size: 24,
                                      ),
                                      color: Colors.pink,
                                      onPressed: () {
                                        provider.removeBookmark(restaurant.id!);
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.favorite_border),
                                      onPressed: () {
                                        provider.addFavorite(restaurant);
                                      },
                                    ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      restaurant.name!,
                      style: primaryTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                        color: theme.isDarkTheme ? Colors.white : Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/map_marker.svg',
                          width: 14,
                          height: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          restaurant.city!,
                          style: primaryTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: medium,
                              color: greyColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
