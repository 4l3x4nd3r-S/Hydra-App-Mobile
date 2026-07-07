import 'dart:async';

class SessionEventBus {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  Stream<void> get onSessionExpired => _controller.stream;

  void notifySessionExpired() {
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}
