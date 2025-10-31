import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app_vgv/core/exceptions.dart';
import 'package:coffee_app_vgv/domain/coffee_repository.dart';
import 'package:coffee_app_vgv/domain/model/coffee_model.dart';
import 'package:coffee_app_vgv/presentation/home/export_home.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockICoffeeRepository extends Mock implements ICoffeeRepository {}

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

late ICoffeeRepository _repository;
late HomeCubit _homeCubit;

void main() {
  setUp(() {
    _repository = MockICoffeeRepository();
    _homeCubit = HomeCubit(repository: _repository);
  });

  blocTest<HomeCubit, HomeState>(
    'emits [LoadingHomeState, LoadedHomeState] when fetchCoffee succeeds',
    build: () {
      _repository = MockICoffeeRepository();

      when(
        () => _repository.fetchCoffeeData(),
      ).thenAnswer((_) async => Right(CoffeeModel(file: 'fakeUrl')));

      return HomeCubit(repository: _repository);
    },
    act: (cubit) => cubit.fetchCoffee(),
    expect: () => [
      LoadingHomeState(),
      LoadedHomeState(coffee: CoffeeModel(file: 'fakeUrl')),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'emits [ErrorHomeState] when fetchCoffee fails',
    build: () {
      _repository = MockICoffeeRepository();

      when(
        () => _repository.fetchCoffeeData(),
      ).thenAnswer((_) async => Left(UnknownFailure()));

      return HomeCubit(repository: _repository);
    },
    act: (cubit) => cubit.fetchCoffee(),
    expect: () => [
      LoadingHomeState(),
      ErrorHomeState(message: 'Unknown error occurred'),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'emits [ErrorHomeState] when fetchCoffee throws an exception',
    build: () {
      _repository = MockICoffeeRepository();

      when(
        () => _repository.fetchCoffeeData(),
      ).thenThrow(Exception('Some exception'));

      return HomeCubit(repository: _repository);
    },
    act: (cubit) => cubit.fetchCoffee(),
    expect: () => [
      LoadingHomeState(),
      ErrorHomeState(message: 'Some exception'),
    ],
  );
}
