import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/provider/preference_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/search_page.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';

import '../utils/result_state.dart';
import '../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home_page';

  Widget _buildList(PreferencesProvider theme) {
    return Consumer<RestaurantProvider>(
      builder: (context, value, _) {
        if (value.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (value.state == ResultState.hasData) {
          return Column(
            children: value.result.restaurants
                .map(
                  (restaurant) => ProductCard(
                    restaurant: restaurant,
                    theme: theme,
                  ),
                )
                .toList(),
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
    );
  }

  Widget _content() {
    return SafeArea(
      child: Material(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    // height: 294,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffFF7467),
                          Color(0xffF7CE68),
                        ],
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                decoration: const BoxDecoration(
                                  color: Color(0xff17161B),
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/profil.png'),
                                    fit: BoxFit.fill,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  const Text('deliver to'),
                                  Text(
                                    'Home',
                                    style: primaryTextStyle.copyWith(
                                        fontSize: 16, fontWeight: bold),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                width: 54,
                                height: 54,
                                decoration: const BoxDecoration(
                                  color: Color(0xff17161B),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      Navigation.intentWithData(
                                          SearchPage.routeName, '');
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/images/search.svg',
                                      width: 32,
                                      height: 32,
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          Text(
                            "Lookin’ for something\nspecial?",
                            style: primaryTextStyle.copyWith(
                              fontSize: 24,
                              fontWeight: bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 24, left: 16, right: 16),
                    child: Consumer<PreferencesProvider>(
                      builder: (context, theme, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Material(
                              child: Text(
                                'Fastest deliver time',
                                style: primaryTextStyle.copyWith(
                                  fontSize: 24,
                                  fontWeight: semiBold,
                                  color: theme.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildList(theme),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
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
