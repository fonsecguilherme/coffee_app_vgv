import 'package:coffee_app_vgv/core/notification_service.dart';
import 'package:coffee_app_vgv/presentation/favorite/export_favorite.dart';
import 'package:coffee_app_vgv/presentation/home/export_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  HomeCubit get cubit => context.read<HomeCubit>();
  FavoriteCubit get favoriteCubit => context.read<FavoriteCubit>();
  NotificationService get notificationService =>
      context.read<NotificationService>();

  @override
  void initState() {
    super.initState();
    cubit.fetchCoffee();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Home View')),
      body: Center(
        child: BlocListener<FavoriteCubit, FavoriteState>(
          listener: (context, state) {
            if (state is SuccessAddCoffeeFavoriteState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return switch (state) {
                InitialHomeState() => const Center(
                  child: Text('Initial widget'),
                ),
                LoadingHomeState() => const CircularProgressIndicator(),
                LoadedHomeState(coffee: final coffee) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.0,
                  children: [
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: Image.network(coffee.file),
                    ),
                    const Text('Didn\'t like this coffee?'),
                    ElevatedButton(
                      onPressed: () => cubit.fetchCoffee(),
                      child: const Text('Another one'),
                    ),
                    const Text('Did you like this coffee?'),
                    ElevatedButton(
                      onPressed: () => favoriteCubit.addFavorite(coffee),
                      child: const Text('Like'),
                    ),

                    IconButton.filled(
                      onPressed: () => notificationService.showNotification(),
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
                ErrorHomeState(message: final message) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.0,
                  children: [
                    Text(
                      'Error: $message',
                      style: const TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: () => cubit.fetchCoffee(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              };
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
