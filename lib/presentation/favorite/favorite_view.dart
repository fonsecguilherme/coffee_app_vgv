import 'package:coffee_app_vgv/presentation/favorite/export_favorite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Favorite View')),
    body: BlocConsumer<FavoriteCubit, FavoriteState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return switch (state) {
          InitialFavoriteState() => const Center(
            child: Text('You have no favorites yet.'),
          ),
          LoadFavoriteState() => ListView.builder(
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final coffee = state.favorites[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('Coffee: ${index + 1} '),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.network(coffee.file),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          ErrorFavoriteState() => Center(
            child: Text('Error: ${state.message}'),
          ),
        };
      },
    ),
  );
}
