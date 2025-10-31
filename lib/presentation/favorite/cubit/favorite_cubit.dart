import 'package:coffee_app_vgv/data/datasource/local_coffee_datasource.dart';
import 'package:coffee_app_vgv/domain/model/coffee_model.dart';
import 'package:coffee_app_vgv/presentation/favorite/export_favorite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final ILocalDataSource localDataSource;

  FavoriteCubit(this.localDataSource) : super(InitialFavoriteState()) {
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    try {
      final favorites = await localDataSource.getAll();

      if (favorites.isEmpty) {
        emit(InitialFavoriteState());
        return;
      }

      emit(LoadFavoriteState(favorites: favorites));
    } catch (e) {
      emit(ErrorFavoriteState(message: e.toString()));
    }
  }

  Future<void> addFavorite(CoffeeModel coffee) async {
    try {
      await localDataSource.save(coffee.bytes!);

      final updatedFavorites = await localDataSource.getAll();

      if (updatedFavorites.isEmpty) {
        emit(InitialFavoriteState());
        return;
      }

      emit(LoadFavoriteState(favorites: updatedFavorites));

      fetchFavorites();
    } catch (e) {
      emit(ErrorFavoriteState(message: e.toString()));
    }
  }

  Future<void> removeFavorite(String localPath) async {
    try {
      await localDataSource.remove(localPath);

      final updatedFavorites = await localDataSource.getAll();

      if (updatedFavorites.isEmpty) {
        emit(InitialFavoriteState());
        return;
      }

      emit(LoadFavoriteState(favorites: updatedFavorites));
    } catch (e) {
      emit(ErrorFavoriteState(message: e.toString()));
    }
  }

  Future<void> clearFavorites() async {
    try {
      await localDataSource.clear();
      emit(InitialFavoriteState());
    } catch (e) {
      emit(ErrorFavoriteState(message: e.toString()));
    }
  }
}
