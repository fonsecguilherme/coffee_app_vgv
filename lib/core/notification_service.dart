import 'package:coffee_app_vgv/data/datasource/local_coffee_datasource.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final ILocalDataSource localDataSource;

  NotificationService({required this.localDataSource});

  final notificationPlugin = FlutterLocalNotificationsPlugin();

  final bool _isInitialized = false;

  final List<String> localImages = [];

  Future<void> initiNotification() async {
    if (_isInitialized) return;

    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettingsIos = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIos,
    );

    await notificationPlugin.initialize(initSettings);

    final androidImplementation = notificationPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.requestNotificationsPermission();
  }

  Future<void> fetchCoffee() async {
    final images = await localDataSource.getAll();

    for (var image in images) {
      localImages.add(image.localPath!);
    }
  }

  Future<NotificationDetails> notificationDetails() async {
    await fetchCoffee();

    if (localImages.isEmpty) {
      const androidDetails = AndroidNotificationDetails(
        'daily_chanel_id',
        'Daily notifications',
        channelDescription: 'Daily coffee suggestion',
        importance: Importance.max,
        priority: Priority.max,
      );

      return const NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );
    }

    final randomImage = await localDataSource.getSingleImagePath();

    final bigPicture = BigPictureStyleInformation(
      FilePathAndroidBitmap(randomImage),
      largeIcon: FilePathAndroidBitmap(randomImage),
    );

    return NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_chanel_id',
        'Daily notifications',
        channelDescription: 'Daily coffee suggestion',
        importance: Importance.max,
        priority: Priority.max,
        styleInformation: bigPicture,
      ),
      iOS: DarwinNotificationDetails(
        attachments: [DarwinNotificationAttachment(randomImage)],
      ),
    );
  }

  checkForNotifications() async {
    final details = await notificationPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {}
  }

  Future<void> showNotification({
    int id = 0,
    String title = 'It\'s coffee time!',
    String body = 'Have you tried this one?',
  }) async {
    final details = await notificationDetails();

    return notificationPlugin.show(id, title, body, details);
  }
}
