part of http;

const String applicationId = 'f8f7c42599af3d0d4f28d08fbb1890d3';
const String restApiKey = 'b59116a9155f554fc096240d6c8c1b6b';

class HeaderInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    options.connectTimeout = 1000 * 15;
    options.receiveTimeout = 10000 * 15;
    options.cancelToken = DioUtils.cancelToken = CancelToken();
    options.headers['X-Bmob-Application-Id'] = applicationId;
    options.headers['X-Bmob-REST-API-Key'] = restApiKey;
    options.headers['content-type'] = 'application/json';
    // TODO
    // if (Global.instance?.userInfo?.sessionToken != null) {
    //   options.headers['X-Bmob-Session-Token'] =
    //       Global.instance.userInfo.sessionToken;
    // }
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    DioUtils.cancelToken = null;
    return super.onResponse(response);
  }
}

class ErrorInterceptor extends InterceptorsWrapper {
  @override
  Future onError(DioError err) {
    switch (err.type) {
      case DioErrorType.RESPONSE:
        String message = '';
        final String content = err.response.data.toString();
        // Log.d(err.response.data.runtimeType);
        // Log.d('$this ------>content---->$content');
        if (content != '') {
          // Log.d('content不为空');
          try {
            // Log.d(err.response.data.toString());
            final Map<String, dynamic> decode =
                err.response.data as Map<String, dynamic>;
            // Log.d('$this-------error---->$decode');
            message = decode['error'] as String;
          } catch (error) {
            message = error.toString();
          }
        }

        // Log.d('$this ---->$message');
        final int status = err.response.statusCode;

        switch (status) {
          case HttpStatus.unauthorized:
            throw AuthorizationException(status: status, message: message);
            break;
          case HttpStatus.unprocessableEntity:
            throw ValidationException(status: status, message: message);
            break;
          default:
            throw StatusException(status: status, message: message);
        }
        break;
      case DioErrorType.CANCEL:
        DioUtils.cancelToken = null;
        throw CancelRequestException(
            status: HttpStatus.clientClosedRequest, message: err.toString());
        break;
      default:
        // Log.d('$this ---->default');
        throw NetworkException(
            status: HttpStatus.networkConnectTimeoutError,
            message: err.message);
    }
  }
}
