import 'package:http/http.dart' as http;

import '../domain/service/i_http_client.dart';

class HttpClient implements IHttpClient {
  final client = http.Client();

  @override
  Future<HttpResponse> get({required String url}) async {
    try {
      final response = await client.get(Uri.parse(url));

      return HttpResponse(
        body: response.body,
        statusCode: response.statusCode,
        bodyBytes: response.bodyBytes,
      );
    } catch (e) {
      throw Exception('An error happened: $e');
    }
  }
}
