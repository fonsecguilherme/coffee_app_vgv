import 'package:coffee_app_vgv/domain/model/coffee_model.dart';

sealed class HomeState {}

final class InitialHomeState extends HomeState {}

final class LoadingHomeState extends HomeState {}

final class LoadedHomeState extends HomeState {
  final CoffeeModel coffee;

  LoadedHomeState({required this.coffee});
}

final class ErrorHomeState extends HomeState {
  final String message;

  ErrorHomeState({required this.message});
}
