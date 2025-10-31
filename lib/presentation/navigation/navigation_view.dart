import 'package:coffee_app_vgv/presentation/favorite/export_favorite.dart';
import 'package:coffee_app_vgv/presentation/navigation/export_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/home_view.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  NavigationCubit get navigationCubit => context.read<NavigationCubit>();
  FavoriteCubit get favoriteCubit => context.read<FavoriteCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: switch (state.navBarItem) {
            NavBarItem.home => const HomeView(),
            NavBarItem.favorite => const FavoriteView(),
          },
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationCubit.state.index,
            onDestinationSelected: (value) =>
                navigationCubit.getNavBarItem(NavBarItem.values[value]),
            destinations: [
              NavigationDestination(
                selectedIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              NavigationDestination(
                selectedIcon: Badge.count(
                  count: favoriteCubit.state.favorites.length,
                  child: Icon(Icons.favorite),
                ),
                icon: Badge.count(
                  count: favoriteCubit.state.favorites.length,
                  child: Icon(Icons.favorite_outline),
                ),
                label: 'Favorite',
              ),
            ],
          ),
        );
      },
    );
  }
}
