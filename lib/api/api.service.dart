part of 'package:useful_utilities/useful_utilities.dart';

class Api {
  String url = '';
  String? body;

  final Map<String, String> headers = {'Content-Type': 'application/json'};

  Future callApi({
    required Function(String body) response,
    required Function(Map<String, String> error) catchError,
    String method = 'GET',
  }) async {
    try {
      final res = await _parseResponse(method.toUpperCase());
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

  Future<Response> _parseResponse(String method) async {
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
