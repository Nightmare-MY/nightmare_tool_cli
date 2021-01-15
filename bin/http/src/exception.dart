part of http;

class StatusException implements Exception {
  StatusException({this.status, this.message});

  final int status;
  final String message;

  @override
  String toString() {
    return 'http request exception [$status]: $message';
  }
}

class AuthorizationException extends StatusException {
  AuthorizationException({int status, String message})
      : super(status: status, message: message);
}

class ValidationException extends StatusException {
  ValidationException({int status, String message})
      : super(status: status, message: message);
}

class NetworkException extends StatusException {
  NetworkException({int status, String message})
      : super(status: status, message: message);
}

class CancelRequestException extends StatusException {
  CancelRequestException({int status, String message})
      : super(status: status, message: message);
}
