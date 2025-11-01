import 'dart:typed_data';

abstract class IHttpClient {
  Future<HttpResponse> get({required String url});
}

class HttpResponse {
  final String body;
  final int statusCode;
  final Uint8List bodyBytes;

  const HttpResponse({
    required this.body,
    required this.statusCode,
    required this.bodyBytes,
  });
}