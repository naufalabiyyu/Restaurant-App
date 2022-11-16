import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/detail_restaurant_provider.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';
import 'package:restaurant_app/provider/preference_provider.dart';
import 'package:restaurant_app/provider/send_review_restaurant_provider.dart';
import 'package:restaurant_app/utils/convert_data.dart';
import 'package:restaurant_app/widgets/rating_sheet.dart';

import '../utils/result_state.dart';

enum MenuItem { item1 }

class DetailPage extends StatefulWidget {
  static const routeName = '/detail_page';

  final String idUnik;

  const DetailPage({Key? key, required this.idUnik}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController reviewController = TextEditingController(text: '');
  TextEditingController nameController = TextEditingController(text: '');

  // bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailRestaurantProvider>(
      create: (_) => DetailRestaurantProvider(
          apiService: ApiService(Client()), idUnik: widget.idUnik),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer<DetailRestaurantProvider>(
          builder: (context, value, _) {
            if (value.state == ResultState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (value.state == ResultState.hasData) {
              final restaurant = value.detailResult;
              return ListView(
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 350,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://restaurant-api.dicoding.dev/images/medium/${restaurant.restaurant.pictureId}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 20,
                              left: 16,
                              right: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back_rounded,
                                      color: Color(0xff17161B),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Consumer<FavoriteProvider>(
                                      builder: (context, provider, child) {
                                        return FutureBuilder<bool>(
                                          future: provider
                                              .isFavorite(widget.idUnik),
                                          builder: (context, snapshot) {
                                            var isFavorite =
                                                snapshot.data ?? false;
                                            return Container(
                                              height: 50,
                                              width: 50,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: isFavorite
                                                  ? IconButton(
                                                      icon: const Icon(
                                                          Icons.favorite),
                                                      color: Colors.pink,
                                                      onPressed: () {
                                                        provider.removeBookmark(
                                                            widget.idUnik);
                                                      },
                                                    )
                                                  : IconButton(
                                                      icon: const Icon(Icons
                                                          .favorite_border),
                                                      color: const Color(
                                                          0xff17161B),
                                                      onPressed: () {
                                                        provider.addFavorite(
                                                          toConvertRestaurantDetailItemToRestaurant(
                                                              restaurant
                                                                  .restaurant),
                                                        );
                                                      },
                                                    ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      padding: const EdgeInsets.all(14),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: PopupMenuButton<MenuItem>(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.more_horiz_rounded,
                                          color: Color(0xff17161B),
                                        ),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: MenuItem.item1,
                                            child: Row(
                                              children: const [
                                                Text('Beri Rating Restoran'),
                                              ],
                                            ),
                                          )
                                        ],
                                        onSelected: (value) {
                                          if (value == MenuItem.item1) {
                                            showModalBottomSheet(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      25.0))),
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) => Padding(
                                                padding: MediaQuery.of(context)
                                                    .viewInsets,
                                                child: ChangeNotifierProvider(
                                                  create: (_) =>
                                                      SendReviewRestaurantProvider(),
                                                  child: RatingSheet(
                                                    idUnik: widget.idUnik,
                                                    nameController:
                                                        nameController,
                                                    reviewController:
                                                        reviewController,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Consumer<PreferencesProvider>(
                    builder: (context, theme, child) {
                      return Transform.translate(
                        offset: const Offset(0, -54),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 28),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                            color: theme.isDarkTheme ? darkColor : Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      restaurant.restaurant.name!,
                                      style: primaryTextStyle.copyWith(
                                        fontSize: 24,
                                        fontWeight: semiBold,
                                        color: theme.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Color(0xffF7CE68),
                                  ),
                                  Text(
                                    '${restaurant.restaurant.rating!}',
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 16,
                                      fontWeight: medium,
                                      color: theme.isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
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
                                    restaurant.restaurant.city!,
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 16,
                                      fontWeight: medium,
                                      color: const Color(0xff969698),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Text(
                                'Description',
                                style: primaryTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: semiBold,
                                  color: theme.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              ReadMoreText(
                                restaurant.restaurant.description!,
                                style: primaryTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: medium,
                                  color: const Color(0xff969698),
                                ),
                                textAlign: TextAlign.justify,
                                trimLines: 4,
                                colorClickableText: const Color(0xffFF7467),
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'Show more',
                                trimExpandedText: 'Show less',
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Menus',
                                style: primaryTextStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: semiBold,
                                  color: theme.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Foods',
                                style: primaryTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: medium,
                                  color: const Color(0xff969698),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                margin: const EdgeInsets.only(right: 0),
                                height: 42,
                                child: ListView.builder(
                                    itemCount: restaurant
                                        .restaurant.menus.foods.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.only(right: 6),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 12),
                                        decoration: const BoxDecoration(
                                            color: Color(0xffF3F3F3),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            )),
                                        child: Text(
                                          restaurant.restaurant.menus
                                              .foods[index].name,
                                          style: primaryTextStyle.copyWith(
                                            fontWeight: medium,
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Drinks',
                                style: primaryTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: medium,
                                  color: const Color(0xff969698),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                margin: const EdgeInsets.only(right: 0),
                                height: 42,
                                child: ListView.builder(
                                  itemCount:
                                      restaurant.restaurant.menus.drinks.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: 6),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 12),
                                      decoration: const BoxDecoration(
                                          color: Color(0xffF3F3F3),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          )),
                                      child: Text(
                                        restaurant.restaurant.menus
                                            .drinks[index].name,
                                        style: primaryTextStyle.copyWith(
                                          fontWeight: medium,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Reviews',
                                style: primaryTextStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: semiBold,
                                  color: theme.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: restaurant
                                    .restaurant.customerReviews.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Text(
                                      '"${restaurant.restaurant.customerReviews[index].review}"',
                                      style: primaryTextStyle.copyWith(
                                        fontWeight: semiBold,
                                        color: theme.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            restaurant.restaurant
                                                .customerReviews[index].name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Container(
                                          width: 5,
                                          height: 5,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color.fromARGB(
                                                255, 183, 186, 193),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            restaurant.restaurant
                                                .customerReviews[index].date,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            } else if (value.state == ResultState.noData) {
              return Center(
                child: Material(
                  child: Text(value.message),
                ),
              );
            } else if (value.state == ResultState.error) {
              return Center(
                child: Text(value.message),
              );
            } else {
              return const Center(
                child: Material(
                  child: Text(''),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
