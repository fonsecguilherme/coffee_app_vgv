import 'package:coffee_app_vgv/core/page_controller_extension.dart';
import 'package:coffee_app_vgv/presentation/favorite/export_favorite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/home_view.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  FavoriteCubit get favoriteCubit => context.read<FavoriteCubit>();

  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: <Widget>[const HomeView(), const FavoriteView()],
      ),
      bottomNavigationBar: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, favoriteState) {
          return AnimatedBuilder(
            animation: pageController,
            builder: (context, _) {
              return NavigationBar(
                selectedIndex: pageController.currentPageIndex,
                onDestinationSelected: pageController.changePage,
                destinations: [
                  NavigationDestination(
                    selectedIcon: Icon(Icons.home),
                    icon: Icon(Icons.home_outlined),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    selectedIcon: Badge.count(
                      count: favoriteState.favorites.length,
                      child: Icon(Icons.favorite),
                    ),
                    icon: Badge.count(
                      count: favoriteState.favorites.length,
                      child: Icon(Icons.favorite_outline),
                    ),
                    label: 'Favorite',
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
