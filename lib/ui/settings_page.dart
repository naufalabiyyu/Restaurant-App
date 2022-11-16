import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/preference_provider.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';
import 'package:restaurant_app/widgets/custom_dialog.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';

import '../common/styles.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isOn = false;

  Widget _buildList(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, child) {
        return Material(
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: primaryTextStyle.copyWith(
                      fontSize: 24,
                      fontWeight: bold,
                      color: provider.isDarkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Material(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      title: const Text('Dark Mode'),
                      trailing: Switch.adaptive(
                        value: provider.isDarkTheme,
                        onChanged: (value) {
                          provider.enableDarkTheme(value);
                        },
                      ),
                    ),
                  ),
                  Material(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      title: const Text('Daily Remainder'),
                      trailing: Consumer<SchedulingProvider>(
                        builder: (context, scheduled, child) {
                          return Switch.adaptive(
                            value: provider.isDailyRestoActive,
                            onChanged: (value) {
                              if (Platform.isIOS) {
                                customDialog(context);
                              } else {
                                scheduled.scheduledRestaurant(value);
                                provider.enableDailyResto(value);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _buildList(context),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: _buildList(context),
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
