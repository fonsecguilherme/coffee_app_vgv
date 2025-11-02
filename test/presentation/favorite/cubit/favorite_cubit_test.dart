import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app_vgv/data/datasource/local_coffee_datasource.dart';
import 'package:coffee_app_vgv/domain/model/coffee_model.dart';
import 'package:coffee_app_vgv/presentation/favorite/export_favorite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockILocalDataSource extends Mock implements ILocalDataSource {}

class FakeCoffeeModel extends Fake implements CoffeeModel {}

late ILocalDataSource _localDataSource;

void main() {
  setUp(() {
    _localDataSource = MockILocalDataSource();
  });

  setUpAll(() {
    registerFallbackValue(FakeCoffeeModel());
  });

  group('FetchFavorites function | ', () {
    blocTest<FavoriteCubit, FavoriteState>(
      'FetchFavorites emits [InitialFavoriteState] when datasource return an empty list',
      build: () {
        when(() => _localDataSource.getAll()).thenAnswer((_) async => []);

        return FavoriteCubit(_localDataSource);
      },
      act: (cubit) => cubit.fetchFavorites(),
      expect: () => <FavoriteState>[InitialFavoriteState()],
    );
    blocTest<FavoriteCubit, FavoriteState>(
      'FetchFavorites emits [LoadFavoriteState] when datasource return a populated list',
      build: () {
        when(
          () => _localDataSource.getAll(),
        ).thenAnswer((_) async => [CoffeeModel(file: '')]);

        return FavoriteCubit(_localDataSource);
      },
      act: (cubit) => cubit.fetchFavorites(),
      expect: () => <FavoriteState>[
        LoadFavoriteState(favorites: [CoffeeModel(file: '')]),
      ],
    );
    blocTest<FavoriteCubit, FavoriteState>(
      'FetchFavorites emits [ErrorFavoriteState] when datasource returns an exception',
      build: () {
        when(() => _localDataSource.getAll()).thenAnswer(
          (_) => Future.error(Exception('Exception in fetchFavorites')),
        );

        return FavoriteCubit(_localDataSource);
      },
      act: (cubit) => cubit.fetchFavorites(),
      expect: () => <FavoriteState>[
        ErrorFavoriteState(message: 'Exception: Exception in fetchFavorites'),
      ],
    );
  });

  group('AddFavorite function tests | ', () {
    blocTest<FavoriteCubit, FavoriteState>(
      'AddFavorite emits [InitialFavoriteState] when an empty list is returned.',
      build: () {
        when(() => _localDataSource.save(any())).thenAnswer((_) async => true);

        when(() => _localDataSource.getAll()).thenAnswer((_) async => []);

        return FavoriteCubit(_localDataSource);
      },
      act: (cubit) => cubit.addFavorite(CoffeeModel(file: 'file')),
      expect: () => <FavoriteState>[InitialFavoriteState()],
    );

    blocTest<FavoriteCubit, FavoriteState>(
      'AddFavorite emits [LoadFavoriteState] when return a populated list.',

      build: () {
        when(() => _localDataSource.save(any())).thenAnswer((_) async => true);

        when(
          () => _localDataSource.getAll(),
        ).thenAnswer((_) async => [CoffeeModel(file: 'file')]);

        return FavoriteCubit(_localDataSource);
      },
      act: (cubit) => cubit.addFavorite(CoffeeModel(file: 'file')),
      expect: () => <FavoriteState>[
        LoadFavoriteState(favorites: [CoffeeModel(file: 'file')]),
        SuccessAddCoffeeFavoriteState(favorites: [CoffeeModel(file: 'file')]),
        LoadFavoriteState(favorites: [CoffeeModel(file: 'file')]),
      ],
    );

    blocTest<FavoriteCubit, FavoriteState>(
      'AddFavorite emits [ErrorFavoriteState] when datasource returns an exception.',
      build: () {
        when(() => _localDataSource.save(any())).thenAnswer((_) async => true);

        when(() => _localDataSource.getAll()).thenAnswer(
          (_) async => Future.error(Exception('Exception in addFavorite')),
        );

        return FavoriteCubit(_localDataSource);
      },
      act: (cubit) => cubit.addFavorite(CoffeeModel(file: 'file')),
      expect: () => <FavoriteState>[
        ErrorFavoriteState(message: 'Exception: Exception in addFavorite'),
      ],
    );
  });

  group('removeFavorite function tests | ', () {
    blocTest<FavoriteCubit, FavoriteState>(
      'removeFavorite emits [InitialFavoriteState] when an empty list is returned.',
      build: () {
        when(() => _localDataSource.remove(any())).thenAnswer((_) async => {});

        when(() => _localDataSource.getAll()).thenAnswer((_) async => []);

        return FavoriteCubit(_localDataSource);
      },
      act: (cubit) => cubit.removeFavorite('file'),
      expect: () => <FavoriteState>[InitialFavoriteState()],
    );

    blocTest<FavoriteCubit, FavoriteState>(
      'removeFavorite emits [LoadFavoriteState] return a populated list.',
      build: () {
        when(() => _localDataSource.remove(any())).thenAnswer((_) async => {});

        when(
          () => _localDataSource.getAll(),
        ).thenAnswer((_) async => [CoffeeModel(file: 'file')]);

        return FavoriteCubit(_localDataSource);
      },
      act: (cubit) => cubit.removeFavorite('file'),
      expect: () => <FavoriteState>[
        LoadFavoriteState(favorites: [CoffeeModel(file: 'file')]),
      ],
    );

    blocTest<FavoriteCubit, FavoriteState>(
      'removeFavorite emits [ErrorFavoriteState] when datasource returns an exception.',
      build: () {
        when(() => _localDataSource.remove(any())).thenAnswer((_) async => {});

        when(() => _localDataSource.getAll()).thenAnswer(
          (_) async => Future.error(Exception('Exception in removeFavorite')),
        );

        return FavoriteCubit(_localDataSource);
      },
      act: (cubit) => cubit.removeFavorite('file'),
      expect: () => <FavoriteState>[
        ErrorFavoriteState(message: 'Exception: Exception in removeFavorite'),
      ],
    );
  });

  group('ClearFavorites function | ', () {
    blocTest<FavoriteCubit, FavoriteState>(
      'ClearFavorites emits [InitialFavoriteState] when clear favorite coffee list.',
      build: () {
        when(() => _localDataSource.clear()).thenAnswer((_) async => []);

        return FavoriteCubit(_localDataSource);
      },
      act: (cubit) => cubit.clearFavorites(),
      expect: () => <FavoriteState>[InitialFavoriteState()],
    );
    blocTest<FavoriteCubit, FavoriteState>(
      'ClearFavorites emits [ErrorFavoriteState] when fails to clear favorite coffee list',
      build: () {
        when(() => _localDataSource.clear()).thenAnswer(
          (_) => Future.error(Exception('Failed to clear favorites list')),
        );

        return FavoriteCubit(_localDataSource);
      },
      act: (cubit) => cubit.clearFavorites(),
      expect: () => <FavoriteState>[
        ErrorFavoriteState(
          message: 'Exception: Failed to clear favorites list',
        ),
      ],
    );
  });
}
