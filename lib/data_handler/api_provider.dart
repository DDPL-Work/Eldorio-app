import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eldoriaCare/data_handler/repository.dart';
import 'package:eldoriaCare/model/result.dart';
import 'package:eldoriaCare/utils/const.dart';
import 'package:eldoriaCare/utils/encryption.dart';
import 'package:eldoriaCare/utils/helper.dart';
import 'package:eldoriaCare/utils/logger.dart';
import 'package:eldoriaCare/utils/preference.dart';
import 'package:eldoriaCare/values/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_keys.dart';

class ApiProvider {
  static late Dio _dio;

  ApiProvider() {
    _dio =
        Dio(
            BaseOptions(
              baseUrl: BaseUrl.baseUrl,
              connectTimeout: const Duration(seconds: 60),
              receiveTimeout: const Duration(seconds: 60),
              sendTimeout: const Duration(seconds: 60),
              followRedirects: false,
              validateStatus: (status) => true,
            ),
          )
          ..interceptors.add(
            PrettyDioLogger(
              requestHeader: true,
              requestBody: true,
              responseHeader: false,
              responseBody: true,
              error: true,
              compact: true,
              maxWidth: 90,
              logPrint: (object) {
                if (kDebugMode) {
                  debugPrint('[API] $object');
                }
              },
            ),
          );

    Logger.m(tag: 'API BASE URL', value: BaseUrl.baseUrl);

    // // if (!BaseUrl.baseUrl.startsWith('https')) {
    //   (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
    //     client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    //     return client;
    //   };
    // // }
  }

  Future<Options> get _options async {
    final token = Preference.isUserAvailable ? Preference.user.token : null;
    final hasValidToken = token != null && token.isNotEmpty && token != 'null';

    return Options(
      headers: {
        'pn': Const.packageName.isNotEmpty
            ? Const.packageName
            : 'com.eldoria.staff',
        'vc': Const.versionCode.isNotEmpty ? Const.versionCode : '1',
        'vn': Const.versionName.isNotEmpty ? Const.versionName : '1.0.0',
        'ot': PlatformType.platformType,
        'Authorization': hasValidToken ? "Bearer $token" : "",
      },
    );
  }

  Future<List<dynamic>> getList(
    String endPoint, {
    bool enableParamsLogs = true,
    bool enableResponseLogs = true,
    Map<String, dynamic>? parameters = const {},
    bool reportError = true,
  }) async {
    if (enableParamsLogs) {
      Logger.m(tag: 'API $endPoint Params', value: parameters);
    }
    if (enableParamsLogs) {
      Logger.m(tag: 'API $endPoint Headers', value: (await _options).headers);
    }

    if (parameters != null &&
        parameters.isNotEmpty &&
        Encryption.publicEncAvailable) {
      parameters = Encryption.instance.encMap(parameters);
    }

    return _dio
        .post(
          endPoint,
          data: FormData.fromMap(parameters ?? {}),
          options: await _options,
        )
        .then((value) {
          if (enableResponseLogs) Logger.r(tag: 'Api $endPoint', value: value);
          if (_isResponseValid(
            response: value,
            endPoint: endPoint,
            reportError: reportError,
          )) {
            // MyAlertDialog()
            //     .setTitle('OK OK')
            //     .setMessage(jsonEncode(value.data))
            //     .setPositiveButton('OK', null)
            //     .setTextSelectable()
            //     .show();
            if (value.data['success'] == true) {
              return value.data['data'] as List;
            }
          }

          return [];
        })
        .catchError((e) {
          Logger.e(
            baseName: runtimeType,
            tag: 'API $endPoint Params',
            value: e,
          );
          if (reportError) reportDioError(endPoint, e);
          return [];
        });
  }

  Future<Result> getResult(
    String endPoint, {
    bool enableParamsLogs = true,
    bool enableResponseLogs = true,
    Map<String, dynamic>? parameters = const {},
    bool reportError = true,
  }) async {
    if (enableParamsLogs) {
      Logger.m(tag: 'API $endPoint Params', value: parameters);
    }
    if (enableParamsLogs) {
      Logger.m(tag: 'API $endPoint Headers', value: (await _options).headers);
    }

    if (parameters != null &&
        parameters.isNotEmpty &&
        Encryption.publicEncAvailable) {
      parameters = Encryption.instance.encMap(parameters);
    }

    return _dio
        .post(
          endPoint,
          data: FormData.fromMap(parameters ?? {}),
          options: await _options,
        )
        .then((value) {
          if (enableResponseLogs) Logger.r(tag: 'Api $endPoint', value: value);

          if (_isResponseValid(
            response: value,
            endPoint: endPoint,
            reportError: reportError,
          )) {
            return Result.fromJson(value.data);
          }
          return Result(message: Strings.get('somethingWentWrong'));
        })
        .catchError((e) {
          Logger.e(
            baseName: runtimeType,
            tag: 'API $endPoint Params',
            value: e,
          );
          if (reportError) reportDioError(endPoint, e);
          return Result(message: Strings.get('somethingWentWrong'));
        });
  }

  Future<dynamic> postJson(
    String endPoint, {
    Map<String, dynamic>? parameters = const {},
    bool enableParamsLogs = true,
    bool enableResponseLogs = true,
    bool reportError = true,
  }) async {
    if (enableParamsLogs) {
      Logger.m(tag: 'API $endPoint Params', value: parameters);
      Logger.m(tag: 'API $endPoint Headers', value: (await _options).headers);
    }

    try {
      // Optional: Uncomment encryption if needed
      // if (Encryption.publicEncAvailable) {
      //   parameters = Encryption.instance.encMap(parameters ?? {});
      // }

      final response = await _dio.post(
        endPoint,
        data: parameters,
        options: await _options,
      );

      if (enableResponseLogs) {
        Logger.r(tag: 'Api $endPoint', value: response);
      }

      if (_isResponseValid(
        response: response,
        endPoint: endPoint,
        reportError: reportError,
      )) {
        return response.data;
      }

      return {'success': false, 'message': response.data['message']};
    } catch (e) {
      Logger.e(tag: 'API $endPoint Error', value: e);
      if (reportError) reportDioError(endPoint, e);
      return {'success': false};
    }
  }

  Future<dynamic> postDynamic(
    String endPoint, {
    bool enableParamsLogs = true,
    bool enableResponseLogs = true,
    Map<String, dynamic>? parameters = const {},
    bool reportError = true,
  }) async {
    if (enableParamsLogs) {
      Logger.m(tag: 'API $endPoint Params', value: parameters);
    }
    if (enableParamsLogs) {
      Logger.m(tag: 'API $endPoint Headers', value: (await _options).headers);
    }

    if (parameters != null &&
        parameters.isNotEmpty &&
        Encryption.publicEncAvailable) {
      parameters = Encryption.instance.encMap(parameters);
    }

    return _dio
        .post(
          endPoint,
          data: FormData.fromMap(parameters ?? {}),
          options: await _options,
        )
        .then((value) {
          if (enableResponseLogs) Logger.r(tag: 'Api $endPoint', value: value);
          if (_isResponseValid(
            response: value,
            endPoint: endPoint,
            reportError: reportError,
          )) {
            return {'success': true, 'value': value.data};
          }
          // return {'success': false, 'message': value.data['message'], 'message2': value.data['non_field_errors']};
          final data = value.data ?? {};

          return {
            'success': false,
            'message': data['message'] ?? '',
            'value': data,
          };
        })
        .catchError((e) {
          Logger.e(tag: 'API $endPoint Params', value: e);
          if (reportError) reportDioError(endPoint, e);
          return {'success': false};
        });
  }

  Future<dynamic> deleteDynamic(
    String endPoint, {
    bool enableParamsLogs = true,
    bool enableResponseLogs = true,
    Map<String, dynamic>? parameters = const {},
    bool reportError = true,
  }) async {
    if (enableParamsLogs) {
      Logger.m(tag: 'API $endPoint Params', value: parameters);
    }
    if (enableParamsLogs) {
      Logger.m(tag: 'API $endPoint Headers', value: (await _options).headers);
    }

    if (parameters != null &&
        parameters.isNotEmpty &&
        Encryption.publicEncAvailable) {
      parameters = Encryption.instance.encMap(parameters);
    }

    return _dio
        .delete(endPoint, options: await _options)
        .then((value) {
          if (enableResponseLogs) Logger.r(tag: 'Api $endPoint', value: value);
          if (_isResponseValid(
            response: value,
            endPoint: endPoint,
            reportError: reportError,
          )) {
            return {'success': true, 'value': value.data};
          }
          return {
            'success': false,
            'message': value.data['message'],
            'message2': value.data['detail'],
          };
        })
        .catchError((e) {
          Logger.e(tag: 'API $endPoint Params', value: e);
          if (reportError) reportDioError(endPoint, e);
          return {'success': false};
        });
  }

  Future<dynamic> putDynamic(
    String endPoint, {
    bool enableParamsLogs = true,
    bool enableResponseLogs = true,
    Map<String, dynamic>? parameters = const {},
    bool reportError = true,
  }) async {
    if (enableParamsLogs) {
      Logger.m(tag: 'API $endPoint Params', value: parameters);
    }
    if (enableParamsLogs) {
      Logger.m(tag: 'API $endPoint Headers', value: (await _options).headers);
    }

    if (parameters != null &&
        parameters.isNotEmpty &&
        Encryption.publicEncAvailable) {
      parameters = Encryption.instance.encMap(parameters);
    }

    return _dio
        .put(
          endPoint,
          data: FormData.fromMap(parameters ?? {}),
          options: await _options,
        )
        .then((value) {
          if (enableResponseLogs) Logger.r(tag: 'Api $endPoint', value: value);
          if (_isResponseValid(
            response: value,
            endPoint: endPoint,
            reportError: reportError,
          )) {
            return {'success': true, 'value': value.data};
          }
          return {
            'success': false,
            'message': value.data['message'],
            'message2': value.data['detail'],
          };
        })
        .catchError((e) {
          Logger.e(tag: 'API $endPoint Params', value: e);
          if (reportError) reportDioError(endPoint, e);
          return {'success': false};
        });
  }

  Future<dynamic> patchDynamic(
    String endPoint, {
    Map<String, dynamic>? parameters = const {},
    bool enableParamsLogs = true,
    bool enableResponseLogs = true,
    bool reportError = true,
  }) async {
    if (enableParamsLogs) {
      Logger.m(tag: 'API $endPoint Params', value: parameters);
      Logger.m(tag: 'API $endPoint Headers', value: (await _options).headers);
    }

    try {
      // Optional: Uncomment encryption if needed
      // if (Encryption.publicEncAvailable) {
      //   parameters = Encryption.instance.encMap(parameters ?? {});
      // }

      final response = await _dio.patch(
        endPoint,
        data: parameters,
        options: await _options,
      );

      if (enableResponseLogs) {
        Logger.r(tag: 'Api $endPoint', value: response);
      }

      if (_isResponseValid(
        response: response,
        endPoint: endPoint,
        reportError: reportError,
      )) {
        return response.data;
      }

      return {'success': false, 'message': response.data['message']};
    } catch (e) {
      Logger.e(tag: 'API $endPoint Error', value: e);
      if (reportError) reportDioError(endPoint, e);
      return {'success': false};
    }
  }

  Future<dynamic> getDynamic(
    String endPoint, {
    bool enableParamsLogs = true,
    bool enableResponseLogs = true,
    Map<String, dynamic>? parameters = const {},
    bool reportError = true,
  }) async {
    if (enableParamsLogs) {
      Logger.m(tag: 'API $endPoint Params', value: parameters);
    }
    if (enableParamsLogs) {
      Logger.m(tag: 'API $endPoint Headers', value: (await _options).headers);
    }

    if (parameters != null &&
        parameters.isNotEmpty &&
        Encryption.publicEncAvailable) {
      parameters = Encryption.instance.encMap(parameters);
    }

    return _dio
        .get(
          endPoint,
          queryParameters: parameters ?? {},
          options: await _options,
        )
        .then((value) {
          if (enableResponseLogs) {
            Logger.r(tag: 'Api ${BaseUrl.baseUrl}$endPoint', value: value);
          }
          if (_isResponseValid(
            response: value,
            endPoint: endPoint,
            reportError: reportError,
          )) {
            return value.data;
          }
          return {'success': false};
        })
        .catchError((e) {
          Logger.e(tag: 'API $endPoint Params', value: e);
          if (reportError) reportDioError(endPoint, e);
          return {'success': false};
        });
  }

  Future<Map<String, dynamic>> getMultiPart(
    String endPoint, {
    Map<String, dynamic>? parameters,
    String method = "POST",
    bool enableParamsLogs = true,
    bool enableResponseLogs = true,
    bool reportError = true,
  }) async {
    try {
      final Map<String, dynamic> processedParams = {};

      if (parameters != null) {
        for (var entry in parameters.entries) {
          final key = entry.key;
          final value = entry.value;

          if (value == null) continue;

          /// FILE
          if (value is File) {
            processedParams[key] = await MultipartFile.fromFile(
              value.path,
              filename: value.path.split('/').last,
            );
          }
          /// LIST OF FILES
          else if (value is List<File>) {
            processedParams[key] = await Future.wait(
              value.map(
                (file) => MultipartFile.fromFile(
                  file.path,
                  filename: file.path.split('/').last,
                ),
              ),
            );
          }
          /// JSON TYPES
          else if (value is List || value is Map) {
            processedParams[key] = jsonEncode(value);
          }
          /// NORMAL
          else {
            processedParams[key] = value;
          }
        }
      }

      final requestData = FormData.fromMap(processedParams);

      if (enableParamsLogs) {
        Logger.m(tag: 'API $endPoint Params', value: processedParams);
        Logger.m(tag: 'API $endPoint Headers', value: (await _options).headers);
      }

      Response response;

      if (method == "PUT") {
        response = await _dio.put(
          endPoint,
          data: requestData,
          options: await _options,
        );
      } else {
        response = await _dio.post(
          endPoint,
          data: requestData,
          options: await _options,
        );
      }

      if (enableResponseLogs) {
        Logger.r(tag: 'Api $endPoint', value: response.data);
      }

      if (_isResponseValid(
        response: response,
        endPoint: endPoint,
        reportError: reportError,
      )) {
        return {'success': true, 'value': response.data};
      } else {
        return {'success': false, 'value': response.data};
      }
    } catch (e) {
      Logger.e(tag: 'API $endPoint Error', value: e);
      if (reportError) reportDioError(endPoint, e);
      return {'success': false, 'value': null};
    }
  }

  Future<int> getInt(
    String endPoint, {
    bool enableParamsLogs = true,
    bool enableResponseLogs = true,
    Map<String, dynamic>? parameters = const {},
    bool reportError = true,
  }) async {
    if (enableParamsLogs) {
      Logger.m(tag: 'API $endPoint Params', value: parameters);
    }
    if (enableParamsLogs) {
      Logger.m(tag: 'API $endPoint Headers', value: (await _options).headers);
    }

    if (parameters != null &&
        parameters.isNotEmpty &&
        Encryption.publicEncAvailable) {
      parameters = Encryption.instance.encMap(parameters);
    }

    return _dio
        .post(
          endPoint,
          data: FormData.fromMap(parameters ?? {}),
          options: await _options,
        )
        .then((value) {
          if (enableResponseLogs) Logger.r(tag: 'Api $endPoint', value: value);
          if (_isResponseValid(
            response: value,
            endPoint: endPoint,
            reportError: reportError,
          )) {
            return Helper.parseInt(value.data);
          }
          return 0;
        })
        .catchError((e) {
          Logger.e(tag: 'API $endPoint Params', value: e);
          if (reportError) reportDioError(endPoint, e);
          return 0;
        });
  }

  Future<List<int>?> hitUrl(String url) async {
    return _dio
        .get<List<int>>(url, options: Options(responseType: ResponseType.bytes))
        .then((value) => value.data)
        .catchError((e) => <int>[]);
  }

  void reportDioError(String endPoint, dynamic e) {
    if (e is DioException) {
      Repository.instance.reportError(
        tag: endPoint,
        value: e.message.nullSafe,
        context: 'Api Provider',
        stack: e.stackTrace.toString(),
      );
    } else {
      Repository.instance.reportError(
        tag: endPoint,
        value: e.toString(),
        context: 'Api Provider',
      );
    }
  }
}

bool _isResponseValid({
  required Response response,
  required String endPoint,
  bool reportError = true,
}) {
  if ([200, 201, 202, 204].contains(response.statusCode)) {
    return true;
  }

  if (response.statusCode == 401) {
    Logger.e(
      tag: "$endPoint => !!!!!! STATUS MESSAGE !!!!!!",
      value: '${response.statusCode} :: ${response.statusMessage ?? ''}',
    );
    // if (Preference.isLogin) {
    //   Helper.logOutWithoutAlert();
    // }
  }

  if (reportError) {
    // Repository.instance.reportError(
    //   tag: 'Api $endPoint Error',
    //   value:
    //       '[${response.statusCode.toString()}] ${response.statusMessage ?? ''}',
    //   context: endPoint,
    //   stack: response.data.toString(),
    // );
  }

  return false;
}
