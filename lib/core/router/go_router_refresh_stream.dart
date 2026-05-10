import 'dart:async';

import 'package:flutter/foundation.dart';

/// [Listenable] để [GoRouter] gọi lại `redirect` khi stream (vd. [Bloc.stream]) phát sự kiện.
///
/// Pattern chính thức: https://pub.dev/documentation/go_router/latest/topics/Redirection-topic.html
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
