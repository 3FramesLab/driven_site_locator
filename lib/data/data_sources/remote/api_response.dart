import 'package:dio/dio.dart';
import 'package:driven_site_locator/config/globals.dart';
import 'package:driven_site_locator/data/data_sources/remote/decodable.dart';
import 'package:driven_site_locator/new_site_locator/new_site_locator_module.dart';

///A function that creates an object of type [T]

typedef Create<T> = T Function();

///Construct to get object from generic class

abstract class GenericObject<T> {
  Create<Decodable<dynamic>> create;

  GenericObject({required this.create});

  T genericObject(dynamic data) {
    final item = create();
    return item.decode(data);
  }
}

///Construct to wrap response from API.
///
///Used it as return object of APIController to handle any kind of response.

class ResponseWrapper<T> extends GenericObject<T> {
  T? response;

  ResponseWrapper({required Create<Decodable<dynamic>> create})
      : super(create: create);

  factory ResponseWrapper.init(
      {Create<Decodable<dynamic>>? create, dynamic data}) {
    try {
      final wrapper = ResponseWrapper<T>(create: create!);
      wrapper.response = wrapper.genericObject(data);
      return wrapper;
    } catch (error) {
      Globals().dynatrace.logError(
            name: 'Exception at ResponseWrapper init',
            value: error.toString(),
            reason: error.toString(),
          );
      throw ErrorResponse(errorSummary: error.toString());
    }
  }
}

class APIResponse<T> extends GenericObject<T>
    implements Decodable<APIResponse<T>> {
  T? data;

  APIResponse({required Create<Decodable<dynamic>> create})
      : super(create: create);

  @override
  APIResponse<T> decode(dynamic json) {
    data = genericObject(json);
    return this;
  }
}

class APIListResponse<T> extends GenericObject<T>
    implements Decodable<APIListResponse<T>> {
  List<T>? data;

  APIListResponse({required Create<Decodable<dynamic>> create})
      : super(create: create);

  @override
  APIListResponse<T> decode(dynamic json) {
    data = [];
    json.forEach((item) {
      data?.add(genericObject(item));
    });
    return this;
  }
}

class ErrorResponse implements Exception {
  Object? error;
  String? errorCode;
  String? errorSummary;
  String? errorMessage;
  String? errorLink;
  String? errorId;
  int? statusCode;
  String? statusCodeOkta;
  String? responseCode;
  String? statusMessage;
  List<ErrorCauses>? errorCauses;
  Headers? headers;

  ErrorResponse({
    this.error,
    this.errorCode,
    this.errorSummary,
    this.errorMessage,
    this.errorLink,
    this.errorId,
    this.errorCauses,
    this.statusCode,
    this.responseCode,
    this.statusCodeOkta,
    this.statusMessage,
  });

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode = json['errorCode'] != null ? json['errorCode'].toString() : '';
    errorSummary = json['errorSummary'] ??
        json['errorMessage'] ??
        json['message'] ??
        SLViewText.somethingWentWrong;
    errorMessage = json['errorMessage'] ?? SLViewText.somethingWentWrong;
    statusMessage = json['statusMessage'] ?? '';
    errorLink = json['errorLink'] ?? '';
    errorId = json['errorId'] ?? '';
    responseCode = json['responseCode'] ?? '';
    if (json['statusCode'] != null) {
      final statusCodeValue = json['statusCode'];
      if (statusCodeValue is String) {
        statusCodeOkta = statusCodeValue;
      } else if (statusCodeValue is int) {
        statusCode = statusCodeValue;
      }
    }
    if (json['errorCauses'] != null) {
      errorCauses = <ErrorCauses>[];
      json['errorCauses'].forEach((v) {
        errorCauses?.add(ErrorCauses.fromJson(v));
      });
    }
  }
}

class ErrorCauses {
  String? errorSummary;

  ErrorCauses({this.errorSummary});

  ErrorCauses.fromJson(Map<String, dynamic> json) {
    errorSummary = json['errorSummary'] ?? 'Something went wrong.';
  }

  @override
  String toString() {
    return errorSummary ?? 'Failed to convert message to string.';
  }
}
