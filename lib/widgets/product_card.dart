import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/provider/preference_provider.dart';
import 'package:restaurant_app/ui/detail_page.dart';

import '../data/model/restaurant.dart';

class ProductCard extends StatelessWidget {
  final Restaurant restaurant;
  PreferencesProvider theme;

  ProductCard({super.key, required this.restaurant, required this.theme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigation.intentWithData(DetailPage.routeName, restaurant.id!);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(28)),
              image: DecorationImage(
                image: NetworkImage(
                    'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    restaurant.name!,
                    style: primaryTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: semiBold,
                      color: theme.isDarkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                height: 38,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: const BoxDecoration(
                  color: Color(0xffFFF8E5),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xffF7CE68),
                    ),
                    Text(
                      '${restaurant.rating}',
                      style: primaryTextStyle.copyWith(
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
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
                      fontSize: 18, fontWeight: medium, color: greyColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
