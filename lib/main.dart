import 'package:coffee_app_vgv/app.dart';
import 'package:coffee_app_vgv/presentation/favorite/export_favorite.dart';
import 'package:coffee_app_vgv/presentation/home/export_home.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/http_client.dart';
import 'core/notification_service.dart';
import 'data/datasource/local_coffee_datasource.dart';
import 'domain/coffee_repository.dart';
import 'domain/repositories/i_coffee_repository.dart';
import 'domain/service/i_http_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final httpClient = HttpClient();
  final localDataSource = LocalCoffeeDataSource();
  final coffeeRepository = CoffeeRepository(httpClient: httpClient);
  final notificationService = NotificationService(
    localDataSource: localDataSource,
  );

  await notificationService.initiNotification();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IHttpClient>.value(value: httpClient),
        RepositoryProvider<ICoffeeRepository>.value(value: coffeeRepository),
        RepositoryProvider<ILocalDataSource>.value(value: localDataSource),
        RepositoryProvider<NotificationService>.value(
          value: notificationService,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => HomeCubit(repository: coffeeRepository)),
          BlocProvider(create: (_) => FavoriteCubit(localDataSource)),
        ],
        child: const App(),
      ),
    ),
  );
}
