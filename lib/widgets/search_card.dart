import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/provider/preference_provider.dart';
import 'package:restaurant_app/ui/detail_page.dart';

import '../common/styles.dart';
import '../data/model/restaurant.dart';

class SearchCard extends StatelessWidget {
  final Restaurant restaurant;
  final PreferencesProvider theme;

  const SearchCard({
    Key? key,
    required this.restaurant,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigation.intentWithData(DetailPage.routeName, restaurant.id!),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name!,
                    style: primaryTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                      color: theme.isDarkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xffF7CE68),
                      ),
                      Text(
                        '${restaurant.rating}',
                        style: primaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: medium,
                          color: const Color(0xff969698),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
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
                          color: const Color(0xff969698),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
