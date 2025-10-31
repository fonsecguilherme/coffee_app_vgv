import 'package:coffee_app_vgv/domain/coffee_model.dart';

sealed class FavoriteState {
  final List<CoffeeModel> favorites;

  FavoriteState({required this.favorites});
}

final class InitialFavoriteState extends FavoriteState {
  InitialFavoriteState() : super(favorites: const []);
}

final class LoadFavoriteState extends FavoriteState {
  LoadFavoriteState({required super.favorites})
    : assert(favorites.isNotEmpty, 'A lista de favoritos não pode estar vazia');
}

final class ErrorFavoriteState extends FavoriteState {
  final String message;

  ErrorFavoriteState({required this.message}) : super(favorites: []);
}
