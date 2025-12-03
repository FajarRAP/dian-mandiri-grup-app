import 'dart:async';

class AuthStatusStream {
  final _controller = StreamController<bool>.broadcast();

  Stream<bool> get stream => _controller.stream;

  void setAuthenticated() => _controller.add(true);

  void setUnauthenticated() => _controller.add(false);

  void dispose() => _controller.close();
}
