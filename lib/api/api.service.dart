part of 'package:useful_utilities/useful_utilities.dart';

class Api {
  String _baseUrl = "";

  void setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
  }

  Future callApi(
    String apiPath, {
    required Function(dynamic body) response,
    required Function(Map<String, String> error) catchError,
    String method = 'GET',
    Map<String, dynamic>? body,
    String? token,
    Map<String, String> queryParams = const {},
    Map<String, String> headers = const {},
  }) async {
    assert(_baseUrl.isNotEmpty,
        "Base url is not set. Please set is using [setBaseUrl] method");
    // assert((method == 'POST' || method == 'PATCH') && body != null,
    //     'Body is required for POST and PATCH requests');

    /// Set url for the request. [baseUrl] + [apiPath]
    String url = _baseUrl + apiPath;

    if (queryParams.isNotEmpty) {
      url += '?';
      queryParams.forEach((key, value) {
        url += '$key=$value&';
      });
    }

    /// Add headers to the request.
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    try {
      final Response res =
          await _parseResponse(url, method.toUpperCase(), headers, body);

      if (res.statusCode == 200) {
        return response(res.data);
      } else {
        return catchError({'error': res.data, ..._parseError(res)});
      }
    } catch (e) {
      return catchError({'error': e.toString()});
    }
  }

  Future<Response> _parseResponse(String url, String method,
      Map<String, dynamic> headers, Map<String, dynamic>? body) async {
    final Dio dio = Dio();

    final options = Options(headers: headers);

    switch (method) {
      case 'GET':
        return dio.get(url);
      case 'POST':
        return dio.post(url, data: FormData.fromMap(body!), options: options);
      case 'PATCH':
        return dio.patch(url, data: FormData.fromMap(body!), options: options);
      case 'DELETE':
        return dio.delete(url);
      default:
        throw Exception('Invalid method');
    }
  }

  Map<String, String> _parseError(Response res) {
    return {
      'statusCode': res.statusCode.toString(),
      'method': res.requestOptions.method,
      'baseUrl': res.requestOptions.baseUrl,
      'path': res.requestOptions.path,
      'queryParameters': res.requestOptions.queryParameters.toString(),
    };
  }
}
