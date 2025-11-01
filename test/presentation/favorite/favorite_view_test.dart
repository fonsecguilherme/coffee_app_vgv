import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app_vgv/domain/model/coffee_model.dart';
import 'package:coffee_app_vgv/presentation/favorite/export_favorite.dart';
import 'package:coffee_app_vgv/presentation/favorite/widgets/image_visualization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share_plus/share_plus.dart';

class MockFavoriteCubit extends MockCubit<FavoriteState>
    implements FavoriteCubit {}

class MockSharePlus extends Mock implements SharePlus {}

class FakeShareParams extends Fake implements ShareParams {}

late FavoriteCubit _favoriteCubit;
late SharePlus _sharePlus;

void main() {
  setUp(() {
    _favoriteCubit = MockFavoriteCubit();
    _sharePlus = MockSharePlus();
  });

  setUpAll(() {
    registerFallbackValue(FakeShareParams());
  });

  tearDown(() {
    _favoriteCubit.close();
  });

  testWidgets('Find initial state', (tester) async {
    when(() => _favoriteCubit.state).thenReturn(InitialFavoriteState());

    await _createWidget(tester);
    await tester.pumpAndSettle();

    expect(find.text('You have no favorites yet.'), findsOneWidget);
  });

  testWidgets('Find loaded state', (tester) async {
    final favorites = [
      CoffeeModel(file: 'fakeUrl.com', localPath: '/path/to/image1.jpg'),
      CoffeeModel(file: 'fakeUrl.com', localPath: '/path/to/image2.jpg'),
      CoffeeModel(file: 'fakeUrl.com', localPath: '/path/to/image3.jpg'),
    ];

    when(
      () => _favoriteCubit.state,
    ).thenReturn(LoadFavoriteState(favorites: favorites));

    await _createWidget(tester);
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(InkWell), findsNWidgets(favorites.length));
  });

  testWidgets('Find error state', (tester) async {
    when(
      () => _favoriteCubit.state,
    ).thenReturn(ErrorFavoriteState(message: 'Error loading favorites'));

    await _createWidget(tester);
    await tester.pumpAndSettle();

    expect(find.text('Error: Error loading favorites'), findsOneWidget);
  });

  group('Interaction | ', () {
    testWidgets('Loaded state tap and hold photo', (tester) async {
      final favorites = [
        CoffeeModel(file: 'fakeUrl.com', localPath: '/path/to/image1.jpg'),
        CoffeeModel(file: 'fakeUrl.com', localPath: '/path/to/image2.jpg'),
        CoffeeModel(file: 'fakeUrl.com', localPath: '/path/to/image3.jpg'),
      ];

      when(
        () => _sharePlus.share(any()),
      ).thenAnswer((_) async => ShareResult('', ShareResultStatus.success));

      when(
        () => _favoriteCubit.state,
      ).thenReturn(LoadFavoriteState(favorites: favorites));

      await _createWidget(tester);
      await tester.pumpAndSettle();

      final firstImage = find.byType(InkWell).first;

      await tester.longPress(firstImage);
    });

    testWidgets('Tap on coffee navigates to ImageVisualization', (
      tester,
    ) async {
      final favorites = [
        CoffeeModel(file: 'fakeUrl.com', localPath: '/path/to/image1.jpg'),
      ];

      when(
        () => _favoriteCubit.state,
      ).thenReturn(LoadFavoriteState(favorites: favorites));

      await _createWidget(tester);
      await tester.pumpAndSettle();

      final firstInkWell = find.byType(InkWell).first;

      await tester.tap(firstInkWell);
      await tester.pumpAndSettle();

      expect(find.byType(ImageVisualization), findsOneWidget);

      final imageWidget = tester.widget<ImageVisualization>(
        find.byType(ImageVisualization),
      );
      expect(imageWidget.localPath, '/path/to/image1.jpg');
    });

    testWidgets('Tap delete all favorites', (tester) async {
      final favorites = [
        CoffeeModel(file: 'fakeUrl.com', localPath: '/path/to/image1.jpg'),
        CoffeeModel(file: 'fakeUrl.com', localPath: '/path/to/image2.jpg'),
        CoffeeModel(file: 'fakeUrl.com', localPath: '/path/to/image3.jpg'),
      ];

      when(
        () => _favoriteCubit.state,
      ).thenReturn(LoadFavoriteState(favorites: favorites));

      when(() => _favoriteCubit.clearFavorites()).thenAnswer((_) async {});

      await _createWidget(tester);
      await tester.pumpAndSettle();

      final deleteButton = find.byIcon(Icons.delete_forever);

      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      verify(() => _favoriteCubit.clearFavorites()).called(1);
    });
  });
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<FavoriteCubit>.value(
        value: _favoriteCubit,
        child: const FavoriteView(),
      ),
    ),
  );
}
