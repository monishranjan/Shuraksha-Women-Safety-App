import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'Shuraksha',
    'Women Safety App',
    importance: Importance.high,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: 'Shuraksha',
      initialNotificationTitle: 'Shuraksha',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 001,
    ),
  );
  service.startService();
}

@pragma('vm-entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  if(service is AndroidServiceInstance){
    service.on('setAsForeground').listen((event) {
      service.isForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if(service is AndroidServiceInstance) {
        if(await service.isForegroundService()) {
          flutterLocalNotificationsPlugin.show(
            001,
            'Shuraksha',
            'Women Safety App',
            NotificationDetails(
                android: AndroidNotificationDetails(
                  "script academy",
                  "foreground service",
                  icon: 'ic_bg_service_small',
                  ongoing: true,
                )
            ),
          );
        }
      }
      print("Background service is running");
      service.invoke('update');
    });
  }
}