import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app_vgv/domain/model/coffee_model.dart';
import 'package:coffee_app_vgv/presentation/favorite/export_favorite.dart';
import 'package:coffee_app_vgv/presentation/home/export_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class MockFavoriteCubit extends MockCubit<FavoriteState>
    implements FavoriteCubit {}

late HomeCubit _homeCubit;
late FavoriteCubit _favoriteCubit;

void main() {
  setUp(() {
    _homeCubit = MockHomeCubit();
    _favoriteCubit = MockFavoriteCubit();
  });

  testWidgets('Find inital state', (tester) async {
    when(() => _homeCubit.state).thenReturn(InitialHomeState());

    when(() => _homeCubit.fetchCoffee()).thenAnswer((_) async {});

    when(() => _favoriteCubit.fetchFavorites()).thenAnswer((_) async {});

    await _createWidget(tester);

    expect(find.text('Initial widget'), findsOneWidget);
  });
  testWidgets('Find loading state', (tester) async {
    when(() => _homeCubit.state).thenReturn(LoadingHomeState());

    when(() => _homeCubit.fetchCoffee()).thenAnswer((_) async {});

    when(() => _favoriteCubit.fetchFavorites()).thenAnswer((_) async {});

    await _createWidget(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Find error state', (tester) async {
    when(
      () => _homeCubit.state,
    ).thenReturn(ErrorHomeState(message: 'Error fetching coffee'));

    when(() => _homeCubit.fetchCoffee()).thenAnswer((_) async {});

    when(() => _favoriteCubit.fetchFavorites()).thenAnswer((_) async {});

    await _createWidget(tester);

    expect(find.text('Error: Error fetching coffee'), findsOneWidget);

    final retryButton = find.widgetWithText(ElevatedButton, 'Retry');

    expect(retryButton, findsOneWidget);

    await tester.tap(retryButton);
    verify(() => _homeCubit.fetchCoffee()).called(2);
  });

  testWidgets('Find loaded state', (tester) async {
    final coffee = CoffeeModel(file: 'fakeUrl');

    when(() => _homeCubit.state).thenReturn(LoadedHomeState(coffee: coffee));

    when(() => _homeCubit.fetchCoffee()).thenAnswer((_) async {});

    when(() => _favoriteCubit.fetchFavorites()).thenAnswer((_) async {});

    await mockNetworkImages(() async => _createWidget(tester));

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Didn\'t like this coffee?'), findsOneWidget);
    expect(find.text('Did you like this coffee?'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });

  group('Interaction', () {
    testWidgets('Success state tap first and second button', (tester) async {
      final coffee = CoffeeModel(file: 'fakeUrl');

      when(() => _homeCubit.state).thenReturn(LoadedHomeState(coffee: coffee));

      when(() => _homeCubit.fetchCoffee()).thenAnswer((_) async {});

      when(() => _favoriteCubit.fetchFavorites()).thenAnswer((_) async {});

      when(() => _favoriteCubit.addFavorite(coffee)).thenAnswer((_) async {});

      await mockNetworkImages(() async => _createWidget(tester));

      final anotherOneButton = find.widgetWithText(
        ElevatedButton,
        'Another one',
      );

      expect(anotherOneButton, findsOneWidget);

      await tester.tap(anotherOneButton);
      verify(() => _homeCubit.fetchCoffee()).called(2);

      final likeButton = find.widgetWithText(ElevatedButton, 'Like');
      await tester.tap(likeButton);
    });

    testWidgets('Error state tap retry', (tester) async {
      final coffee = CoffeeModel(file: 'fakeUrl');

      when(
        () => _homeCubit.state,
      ).thenReturn(ErrorHomeState(message: 'Error fetching coffee'));

      when(() => _homeCubit.fetchCoffee()).thenAnswer((_) async {});

      when(() => _favoriteCubit.fetchFavorites()).thenAnswer((_) async {});

      when(() => _favoriteCubit.addFavorite(coffee)).thenAnswer((_) async {});

      await mockNetworkImages(() async => _createWidget(tester));

      final retryButton = find.widgetWithText(ElevatedButton, 'Retry');

      expect(retryButton, findsOneWidget);

      await tester.tap(retryButton);
      verify(() => _homeCubit.fetchCoffee()).called(2);
    });
  });
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>.value(value: _homeCubit),
        BlocProvider<FavoriteCubit>.value(value: _favoriteCubit),
      ],
      child: const MaterialApp(home: HomeView()),
    ),
  );
}
