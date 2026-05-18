import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_provider.g.dart';

@Riverpod(keepAlive: true)
class SessionNotifier extends _$SessionNotifier {
  @override
  int build() => 0;

  void triggerUnauthorized() {
    state++;
  }
}
