import 'dart:convert';

import 'package:coffee_app_vgv/domain/model/coffee_model.dart';
import 'package:dartz/dartz.dart';

import '../core/exceptions.dart';
import 'repositories/i_coffee_repository.dart';
import 'service/i_http_client.dart';

class CoffeeRepository implements ICoffeeRepository {
  final IHttpClient httpClient;

  CoffeeRepository({required this.httpClient});

  //TODO:Refatorar pra só baixar a imagem na hora de salvar
  @override
  Future<Either<Failure, CoffeeModel>> fetchCoffeeData() async {
    try {
      final response = await httpClient.get(
        url: 'https://coffee.alexflipnote.dev/random.json',
      );

      if (response.statusCode == 200) {
        final coffee = jsonDecode(response.body);
        final model = CoffeeModel.fromJson(coffee);

        final imageResponse = await httpClient.get(url: model.file);

        if (imageResponse.statusCode == 200) {
          final updatedModel = model.copyWith(bytes: imageResponse.bodyBytes);
          return Right(updatedModel);
        } else {
          return Left(HttpFailure(statusCode: imageResponse.statusCode));
        }
      } else {
        return Left(HttpFailure(statusCode: response.statusCode));
      }
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
