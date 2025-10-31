sealed class Failure {
  final String message;
  const Failure(this.message);
}

class HttpFailure extends Failure {
  final int? statusCode;
  const HttpFailure({this.statusCode})
    : super('Erro HTTP: ${statusCode ?? 'Unknown'}');
}
class UnknownFailure extends Failure {
  const UnknownFailure() : super('Unknown error occurred');
}