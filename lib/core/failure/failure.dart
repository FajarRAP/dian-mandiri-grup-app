class Failure {
  const Failure({
    this.statusCode = 500,
    this.message = 'Terjadi kesalahan',
  });

  final int statusCode;
  final String message;
}
