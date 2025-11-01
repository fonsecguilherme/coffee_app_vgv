import 'dart:io';

import 'package:coffee_app_vgv/presentation/favorite/export_favorite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import 'widgets/image_visualization.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  FavoriteCubit get favoriteCubit => context.read<FavoriteCubit>();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actionsPadding: EdgeInsets.only(right: 8.0),
      title: const Text('Favorite View'),
      actions: [
        GestureDetector(
          onTap: () => context.read<FavoriteCubit>().clearFavorites(),
          child: const Icon(Icons.delete_forever),
        ),
      ],
    ),
    body: BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        return switch (state) {
          InitialFavoriteState() => const Center(
            child: Text('You have no favorites yet.'),
          ),
          LoadFavoriteState() => GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final coffee = state.favorites[index];
              return Ink.image(
                fit: BoxFit.cover,
                image: FileImage(File(coffee.localPath!)),
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: favoriteCubit,
                        child: ImageVisualization(localPath: coffee.localPath!),
                      ),
                    ),
                  ),
                  onLongPress: () async {
                    final params = ShareParams(
                      text: 'Have you tried this one?',
                      files: [XFile(coffee.localPath!)],
                    );

                    final result = await SharePlus.instance.share(params);

                    if (result.status == ShareResultStatus.dismissed) {
                      print('Did you not like the pictures?');
                    }
                  },
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
