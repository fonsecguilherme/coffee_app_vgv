import 'package:coffee_app_vgv/presentation/favorite/export_favorite.dart';
import 'package:coffee_app_vgv/presentation/home/export_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeCubit get cubit => context.read<HomeCubit>();
  FavoriteCubit get favoriteCubit => context.read<FavoriteCubit>();

  @override
  void initState() {
    super.initState();
    cubit.fetchCoffee();
    favoriteCubit.fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home View')),
      body: Center(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return switch (state) {
              InitialHomeState() => const Center(child: Text('Initial widget')),
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
                    onPressed: () {
                      favoriteCubit.addFavorite(coffee);
                      favoriteCubit.fetchFavorites();
                    },
                    child: const Text('Like'),
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
    );
  }
}
