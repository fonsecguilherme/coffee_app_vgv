import 'package:coffee_app_vgv/domain/model/coffee_model.dart';
import 'package:equatable/equatable.dart';

sealed class FavoriteState extends Equatable {
  final List<CoffeeModel> favorites;

  const FavoriteState({required this.favorites});
}

final class InitialFavoriteState extends FavoriteState {
  const InitialFavoriteState() : super(favorites: const []);

  @override
  List<Object?> get props => [favorites];
}

final class LoadFavoriteState extends FavoriteState {
  LoadFavoriteState({required super.favorites})
    : assert(favorites.isNotEmpty, 'A lista de favoritos não pode estar vazia');
  @override
  List<Object?> get props => [favorites];
}

final class SuccessAddCoffeeFavoriteState extends FavoriteState {
  final String message;

  const SuccessAddCoffeeFavoriteState({
    required super.favorites,
    this.message = 'Coffee added to favorites successfully',
  });

  @override
  List<Object?> get props => [favorites, message];
}

final class ErrorFavoriteState extends FavoriteState {
  final String message;

  ErrorFavoriteState({required this.message}) : super(favorites: []);

  @override
  List<Object?> get props => [message, favorites];
}
