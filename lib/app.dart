import 'package:coffee_app_vgv/presentation/favorite/export_favorite.dart';
import 'package:coffee_app_vgv/presentation/home/export_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/http_client.dart';
import 'domain/coffee_repository.dart';
import 'presentation/navigation/export_navigation.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<IHttpClient>(create: (context) => HttpClient()),
          RepositoryProvider<ICoffeeRepository>(
            create: (context) =>
                CoffeeRepository(httpClient: context.read<IHttpClient>()),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => NavigationCubit()),
            BlocProvider(
              create: (context) =>
                  HomeCubit(repository: context.read<ICoffeeRepository>()),
            ),
            BlocProvider(create: (context) => FavoriteCubit()),
          ],
          child: NavigationView(),
        ),
      ),
    );
  }
}
