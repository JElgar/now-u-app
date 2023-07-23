import 'package:causeApiClient/causeApiClient.dart';
import 'package:dio/dio.dart';
import 'package:nowu/assets/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nowu/services/auth.dart';
import 'package:nowu/locator.dart';

typedef JsonDeserializer<T> = T Function(Map<String, dynamic> data);

/// Types of http errors
enum ApiExceptionType {
  UNAUTHORIZED,
  INTERNAL,
  REQUEST,
  UNKNOWN,
  TOKEN_EXPIRED
}

/// Exception for failed http requests
class ApiException implements Exception {
  ApiExceptionType type;
  int statusCode;
  String message;

  ApiException(
      {required this.type, required this.statusCode, required this.message});
}

/// Map showing the translation from http response code to an
/// [ApiApiExceptionType]
Map<int, ApiExceptionType> responseCodeExceptionMapping = {
  401: ApiExceptionType.UNAUTHORIZED,
  419: ApiExceptionType.TOKEN_EXPIRED,
  500: ApiExceptionType.INTERNAL,
};

class ApiService {
  final http.Client client;
  ApiService(this.client);

  /// Generate appropriate [ApiException] from http response.
  ApiException getExceptionForResponse(http.Response response) {
    ApiExceptionType exceptionType =
        responseCodeExceptionMapping[response.statusCode] ??
            ApiExceptionType.UNKNOWN;

    print(
        "Request error: Body: ${response.body}, Code: ${response.statusCode}");
    return ApiException(
        type: exceptionType,
        statusCode: response.statusCode,
        message: response.body);
  }

  /// Get headers for standard API request
  ///
  /// If [AuthenticationService] says the user is authenticated the token will
  /// also be added to the headers.
  Map<String, String> getRequestHeaders() {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    // If the user is logged in add their token to the request headers
    final AuthenticationService _authService = locator<AuthenticationService>();
    if (_authService.isAuthenticated) {
      // We know a token must exist as the user is authenticated
      // headers['token'] = _authService.token!;
      headers['Authorization'] = "JWT ${_authService.token!}";
    }
    return headers;
  }

  dynamic formatRequestParameter(dynamic value) {
    if (value is List) {
      return "[" +
          value.map((item) => formatRequestParameter(item)).join(",") +
          "]";
    }
    if (value is Iterable) {
      return value;
    }
    if (value is String) {
      return "\"" + value + "\"";
    }
    // Otherwise cast it to a string
    return value.toString();
  }

  /// Make get request to api
  ///
  /// Returns Map of the response. Throws an [ApiException] if the request is
  /// unsuccessful.
  Future<Map> getRequest(String path, {Map<String, dynamic>? params}) async {
    // Convert param values to strings
    Map<String, dynamic>? stringParams;
    print("Constructing get request to $path");
    if (params != null) {
      // Parse param values
      stringParams = Map.fromIterable(
        params.keys,
        key: (k) => k,
        value: (k) => formatRequestParameter(params[k]),
      );
    }

    final uri = getCausesApiPath(path, stringParams: stringParams);
    print("Making request: ${uri.toString()}, headers: ${getRequestHeaders()}");
    http.Response response = await client.get(
      uri,
      headers: getRequestHeaders(),
    );
    print("RESPONSE");
    print(uri.toString());
    print(response.body);
    print(response.statusCode);

    if (response.statusCode >= 400) {
      throw getExceptionForResponse(response);
    }

    return await json.decode(response.body);
  }

  Future<List<Map<String, dynamic>>> getListRequest(String path,
      {Map<String, dynamic>? params, int? limit = 5}) async {
    if (params == null) {
      params = {};
    }

    if (limit != null) {
      params["limit"] = limit;
    }

    Map response = await getRequest(path, params: params);
    List<Map<String, dynamic>> listData =
        List<Map<String, dynamic>>.from(response["data"]);
    return listData;
  }

  Future<T> getModelRequest<T>(String path, JsonDeserializer<T> deserializer,
      {Map<String, dynamic>? params}) async {
    final response = await getRequest(path, params: params);
    return deserializer(response["data"]);
  }

  Future<List<T>> getModelListRequest<T>(
      String path, JsonDeserializer<T> deserializer,
      {Map<String, dynamic>? params, int? limit = 5}) async {
    final data = await getListRequest(path, params: params);
    return data.map((item) => deserializer(item)).toList();
  }

  /// Make post request to api
  ///
  /// Returns Map of the response. Throws an [ApiException] if the request is
  /// unsuccessful.
  Future<Map<String, dynamic>> postRequest(String path,
      {Map<String, dynamic>? body}) async {
    final uri = getCausesApiPath(path);
    print(
        "Making request: ${uri.toString()}, body: $body, headers: ${getRequestHeaders()}");

    http.Response response = await client.post(
      uri,
      headers: getRequestHeaders(),
      body: json.encode(body),
    );

    print("Response: ${response.statusCode}, ${response.toString()}");

    if (response.statusCode >= 400) {
      throw getExceptionForResponse(response);
    }

    return await json.decode(response.body);
  }

  /// Make put request to api
  ///
  /// Returns Map of the response. Throws an [ApiException] if the request is
  /// unsuccessful.
  Future<Map> putRequest(String path, {Map<String, dynamic>? body}) async {
    final uri = getCausesApiPath(path);
    print(
        "Making request: ${uri.toString()}, body: $body, headers: ${getRequestHeaders()}");
    http.Response response = await client.put(
      uri,
      headers: getRequestHeaders(),
      body: json.encode(body),
    );

    if (response.statusCode >= 400) {
      throw getExceptionForResponse(response);
    }

    return await json.decode(response.body);
  }

  /// Make delete request to api
  ///
  /// Returns Map of the response. Throws an [ApiException] if the request is
  /// unsuccessful.
  Future<Map> deleteRequest(String path) async {
    final uri = getCausesApiPath(path);
    print("Making request: ${uri.toString()}, headers: ${getRequestHeaders()}");
    http.Response response = await client.put(
      uri,
      headers: getRequestHeaders(),
    );

    if (response.statusCode >= 400) {
      throw getExceptionForResponse(response);
    }

    return await json.decode(response.body);
  }
}
