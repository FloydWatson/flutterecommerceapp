class HttpException implements Exception { // inheriting exception. this is the default implementation
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
    // return super.toString(); // Instance of HttpException
  }
}