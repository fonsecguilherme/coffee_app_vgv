import 'package:coffee_app_vgv/domain/coffee_model.dart';
import 'package:coffee_app_vgv/presentation/favorite/export_favorite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(InitialFavoriteState());

  Future<void> fetchFavorites() async {
    try {
      final favorites = state.favorites;

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
      final updatedFavorites = List<CoffeeModel>.from(state.favorites)
        ..add(coffee);

      if (updatedFavorites.isEmpty) {
        emit(InitialFavoriteState());
        return;
      }
      emit(LoadFavoriteState(favorites: updatedFavorites));
    } catch (e) {
      emit(ErrorFavoriteState(message: e.toString()));
    }
  }
}
