import 'package:dartz/dartz.dart';

import '../../core/exceptions.dart';
import '../model/coffee_model.dart';

abstract class ICoffeeRepository {
  Future<Either<Failure, CoffeeModel>> fetchCoffeeData();
}