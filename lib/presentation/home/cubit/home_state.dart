import 'package:coffee_app_vgv/domain/model/coffee_model.dart';
import 'package:equatable/equatable.dart';

sealed class HomeState extends Equatable {}

final class InitialHomeState extends HomeState {
  @override
  List<Object?> get props => [];
}

final class LoadingHomeState extends HomeState {
  @override
  List<Object?> get props => [];
}

final class LoadedHomeState extends HomeState {
  final CoffeeModel coffee;

  LoadedHomeState({required this.coffee});

  @override
  List<Object?> get props => [];
}

final class ErrorHomeState extends HomeState {
  final String message;

  ErrorHomeState({required this.message});

  @override
  List<Object?> get props => [];
}
