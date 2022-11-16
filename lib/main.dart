import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/db/favorite_helper.dart';
import 'package:restaurant_app/data/preferences/preference_helper.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';
import 'package:restaurant_app/provider/preference_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';
import 'package:restaurant_app/ui/detail_page.dart';
import 'package:restaurant_app/ui/main_page.dart';
import 'package:restaurant_app/ui/search_page.dart';
import 'package:restaurant_app/ui/settings_page.dart';
import 'package:restaurant_app/utils/background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/home_page.dart';
import 'utils/notification_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RestaurantProvider(
            apiService: ApiService(Client()),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoriteProvider(
            favoriteHelper: FavoriteHelper(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SchedulingProvider(),
          child: SettingsPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        )
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'Restaurant App',
            navigatorKey: navigatorKey,
            theme: provider.themeData,
            initialRoute: MainPage.routeName,
            routes: {
              MainPage.routeName: (_) => const MainPage(),
              HomePage.routeName: (_) => HomePage(),
              DetailPage.routeName: (_) => DetailPage(
                  idUnik: ModalRoute.of(_)!.settings.arguments == null
                      ? 'null'
                      : ModalRoute.of(_)!.settings.arguments as String),
              SearchPage.routeName: (context) => SearchPage(),
            },
          );
        },
      ),
    );
  }
}
