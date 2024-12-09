class Failure {
  const Failure({
    this.statusCode = 500,
    this.message = 'Ada Sesuatu Yang Salah',
  });

  final int statusCode;
  final String message;
}
