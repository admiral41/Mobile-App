class Failure {
  final String error;
  final String? statusCode;
  final String? message;

  Failure({
    required this.error,
    this.statusCode,
    this.message,
  });
}
