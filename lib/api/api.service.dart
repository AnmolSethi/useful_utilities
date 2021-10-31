part of 'package:useful_utilities/useful_utilities.dart';

class Api {
  String _baseUrl = "";

  /// Set the base url for the api
  /// Call this method after initializing the class
  ///
  /// https://example.com/api/
  void setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
  }

  /// [apiPath] is the path of the api
  /// [baseUrl] + [apiPath] = https://example.com/api/apiPath
  Future callApi(
    String apiPath, {
    required Function(dynamic body) response,
    required Function(Map<String, String> error) catchError,
    String method = 'GET',
    Map<String, dynamic>? body,
    BodyType bodyType = BodyType.json,
    String? token,
    Map<String, String> queryParams = const {},
    Map<String, String> headers = const {},
    TokenType tokenType = TokenType.bearer,
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
      final Response res = await _parseResponse(
          url, method.toUpperCase(), headers, body, bodyType);

      if (res.statusCode == 200) {
        return response(res.data);
      } else {
        return catchError({'error': res.data, ..._parseError(res)});
      }
    } catch (e) {
      return catchError({'error': e.toString()});
    }
  }

  Future<Response> _parseResponse(
      String url,
      String method,
      Map<String, dynamic> headers,
      Map<String, dynamic>? body,
      BodyType bodyType) async {
    final Dio dio = Dio();
    final options = Options(headers: headers);

    final bodyToSend = (bodyType == BodyType.json)
        ? json.encode(body)
        : (bodyType == BodyType.formData)
            ? FormData.fromMap(body!)
            : null;

    try {
      switch (method) {
        case 'GET':
          return await dio.get(url);
        case 'POST':
          return await dio.post(url, data: bodyToSend, options: options);
        case 'PATCH':
          return await dio.patch(url, data: bodyToSend, options: options);
        case 'DELETE':
          return await dio.delete(url);
        default:
          throw Exception('Invalid method');
      }
    } catch (e, s) {
      print('DioError: $e, $s');
      rethrow;
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

enum TokenType { bearer, basic }

enum BodyType { json, formData }
