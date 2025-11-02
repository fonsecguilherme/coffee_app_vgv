import 'dart:convert';
import 'dart:typed_data';

import 'package:coffee_app_vgv/core/exceptions.dart';
import 'package:coffee_app_vgv/data/repositories/coffee_repository.dart';
import 'package:coffee_app_vgv/domain/service/i_http_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements IHttpClient {}

late MockHttpClient _httpClient;
late CoffeeRepository _repository;

void main() {
  setUp(() {
    _httpClient = MockHttpClient();
    _repository = CoffeeRepository(httpClient: _httpClient);

    registerFallbackValue(
      HttpResponse(statusCode: 200, body: '', bodyBytes: Uint8List(0)),
    );
  });

  const String coffeeApiUrl = 'https://coffee.alexflipnote.dev/random.json';
  const String imageUrl = 'https://fake.coffee.image.url/image.jpg';

  test('Success when both requests return 200', () async {
    final coffeeJson = {'file': imageUrl};
    final imageBytes = Uint8List.fromList([1, 2, 3, 4, 5]);

    when(() => _httpClient.get(url: coffeeApiUrl)).thenAnswer(
      (_) async => HttpResponse(
        statusCode: 200,
        body: jsonEncode(coffeeJson),
        bodyBytes: Uint8List(0),
      ),
    );

    when(() => _httpClient.get(url: imageUrl)).thenAnswer(
      (_) async =>
          HttpResponse(statusCode: 200, body: '', bodyBytes: imageBytes),
    );

    final result = await _repository.fetchCoffeeData();

    expect(result.isRight(), true);
    final model = result.getOrElse(() => throw Exception());
    expect(model.file, imageUrl);
    expect(model.bytes, imageBytes);

    verify(() => _httpClient.get(url: coffeeApiUrl)).called(1);
    verify(() => _httpClient.get(url: imageUrl)).called(1);
  });

  test('Throws an HTTPError when first request statusCode != 200 ', () async {
    when(() => _httpClient.get(url: coffeeApiUrl)).thenAnswer(
      (_) async =>
          HttpResponse(statusCode: 400, body: '', bodyBytes: Uint8List(0)),
    );

    final result = await _repository.fetchCoffeeData();

    expect(result.isLeft(), true);
    result.fold((failure) {
      expect(failure, isA<HttpFailure>());
      expect((failure as HttpFailure).statusCode, 400);
    }, (r) {});

    verify(() => _httpClient.get(url: coffeeApiUrl)).called(1);
  });
  test('Throws an HTTPError when second request statusCode != 200 ', () async {
    final coffeeJson = {'file': imageUrl};
    final imageBytes = Uint8List.fromList([1, 2, 3, 4, 5]);

    when(() => _httpClient.get(url: coffeeApiUrl)).thenAnswer(
      (_) async => HttpResponse(
        statusCode: 200,
        body: jsonEncode(coffeeJson),
        bodyBytes: Uint8List(0),
      ),
    );

    when(() => _httpClient.get(url: imageUrl)).thenAnswer(
      (_) async =>
          HttpResponse(statusCode: 400, body: '', bodyBytes: imageBytes),
    );

    final result = await _repository.fetchCoffeeData();

    expect(result.isLeft(), true);
    result.fold((failure) {
      expect(failure, isA<HttpFailure>());
      expect((failure as HttpFailure).statusCode, 400);
    }, (r) {});

    verify(() => _httpClient.get(url: coffeeApiUrl)).called(1);
    verify(() => _httpClient.get(url: imageUrl)).called(1);
  });

  test('Throws an UnknownFailure when exception is throw', () async {
    when(() => _httpClient.get(url: coffeeApiUrl)).thenThrow(Exception());

    final result = await _repository.fetchCoffeeData();

    expect(result.isLeft(), true);
    result.fold((failure) {
      expect(failure, isA<UnknownFailure>());
    }, (r) {});

    verify(() => _httpClient.get(url: coffeeApiUrl)).called(1);
  });
}
