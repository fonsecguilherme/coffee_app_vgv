import 'package:flutter/material.dart';

import 'app.dart';
import 'core/notification_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  NotificationService().initiNotification();

  runApp(const App());
}
