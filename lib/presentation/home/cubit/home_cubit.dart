import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/i_coffee_repository.dart';
import '../export_home.dart';

class HomeCubit extends Cubit<HomeState> {
  final ICoffeeRepository _repository;

  HomeCubit({required ICoffeeRepository repository})
    : _repository = repository,
      super(InitialHomeState());

  Future<void> fetchCoffee() async {
    try {
      emit(LoadingHomeState());

      final result = await _repository.fetchCoffeeData();

      result.fold(
        (failure) => emit(ErrorHomeState(message: failure.message)),
        (coffee) => emit(LoadedHomeState(coffee: coffee)),
      );
    } catch (e) {
      emit(ErrorHomeState(message: e.toString()));
    }
  }
}
