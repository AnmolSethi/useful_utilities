part of 'package:useful_utilities/useful_utilities.dart';

class Api {
  String _baseUrl = "";

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  void setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
  }

  Future callApi(
    String apiPath, {
    required Function(String body) response,
    required Function(Map<String, String> error) catchError,
    String method = 'GET',
    String? body,
    String? token,
    Map<String, String> queryParams = const {},
    Map<String, String> extraHeaders = const {},
  }) async {
    assert(_baseUrl.isNotEmpty,
        "Base url is not set. Please set is using [setBaseUrl] method");
    assert((method == 'POST' || method == 'PATCH') && body != null,
        'Body is required for POST and PATCH requests');

    /// Set url for the request. [baseUrl] + [apiPath]
    String url = _baseUrl + apiPath;

    if (queryParams.isNotEmpty) {
      url += '?';
      queryParams.forEach((key, value) {
        url += '$key=$value&';
      });
    }

    /// Add headers to the request.
    _headers.addAll(extraHeaders);
    if (token != null) {
      _headers.addAll({'Authorization': 'Bearer $token'});
    }

    try {
      final res =
          await _parseResponse(url, method.toUpperCase(), _headers, body);
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

  Future<Response> _parseResponse(String url, String method,
      Map<String, String> headers, String? body) async {
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
