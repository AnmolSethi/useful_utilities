part of 'package:useful_utilities/useful_utilities.dart';

class Api {
  String? body;

  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  Future callApi(
    String url, {
    required Function(String body) response,
    required Function(Map<String, String> error) catchError,
    String method = 'GET',
    String? token,
    Map<String, String> header = const {},
  }) async {
    final h = {..._headers, ...header};
    if (token != null) {
      h.addAll({'Authorization': 'Bearer $token'});
    }

    try {
      final res = await _parseResponse(url, method.toUpperCase(), h);
      if (res.statusCode == 200) {
        return response(res.body);
      } else {
        return catchError({'error': res.body, ..._parseError(res)});
      }
    } catch (e) {
      e.toString();
      return catchError({'error': e.toString()});
    }
  }

  Future<Response> _parseResponse(
      String url, String method, Map<String, String> headers) async {
    switch (method) {
      case 'GET':
        return get(Uri.parse(url), headers: headers);
      case 'POST':
        return post(Uri.parse(url), headers: headers, body: body);
      case 'PATCH':
        return patch(Uri.parse(url), headers: headers, body: body);
      case 'DELETE':
        return delete(Uri.parse(url), headers: headers);
      default:
        throw Exception('Invalid method');
    }
  }

  Map<String, String> _parseError(Response res) {
    return {
      'statusCode': res.statusCode.toString(),
      'method': res.request!.method,
      'url': res.request!.url.toString(),
    };
  }
}
