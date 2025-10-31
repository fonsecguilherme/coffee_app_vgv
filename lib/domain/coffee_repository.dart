import 'dart:convert';

import 'package:coffee_app_vgv/domain/model/coffee_model.dart';
import 'package:dartz/dartz.dart';

import '../core/exceptions.dart';
import '../core/http_client.dart';

abstract class ICoffeeRepository {
  Future<Either<Failure, CoffeeModel>> fetchCoffeeData();
}

class CoffeeRepository implements ICoffeeRepository {
  final IHttpClient httpClient;

  CoffeeRepository({required this.httpClient});

  @override
  Future<Either<Failure, CoffeeModel>> fetchCoffeeData() async {
    try {
      final response = await httpClient.get(
        url: 'https://coffee.alexflipnote.dev/random.json',
      );

      if (response.statusCode == 200) {
        final coffee = jsonDecode(response.body);
        final model = CoffeeModel.fromJson(coffee);
        return Right(model);
      } else {
        return Left(HttpFailure(statusCode: response.statusCode));
      }
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
