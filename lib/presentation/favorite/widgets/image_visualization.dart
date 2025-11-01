import 'dart:io';

import 'package:coffee_app_vgv/presentation/favorite/export_favorite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ImageVisualization extends StatelessWidget {
  final String localPath;

  const ImageVisualization({super.key, required this.localPath});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () =>
              context.read<FavoriteCubit>().removeFavorite(localPath).then((_) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }),
        ),
      ],
    ),
    body: Center(
      child: PinchZoom(child: Image.file(File(localPath), fit: BoxFit.cover)),
    ),
  );
}
