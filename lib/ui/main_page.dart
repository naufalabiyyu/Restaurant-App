import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/ui/detail_page.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';

import 'favorites_page.dart';
import 'home_page.dart';
import 'settings_page.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/main_page';

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  int _selectedIndex = 0;

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon:
          Icon(Platform.isIOS ? CupertinoIcons.house_fill : Icons.home_filled),
      label: 'home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.heart_fill : Icons.favorite),
      label: 'favorite',
    ),
    BottomNavigationBarItem(
      icon:
          Icon(Platform.isIOS ? CupertinoIcons.settings_solid : Icons.settings),
      label: 'settings',
    ),
  ];

  final List<Widget> _listWidget = [
    HomePage(),
    const FavoritesPage(),
    SettingsPage(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(DetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        currentIndex: _selectedIndex,
        items: _bottomNavBarItems,
        onTap: _onItemTap,
      ),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: _bottomNavBarItems,
        activeColor: Colors.red,
      ),
      tabBuilder: (BuildContext context, int index) {
        return _listWidget[index];
      },
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
