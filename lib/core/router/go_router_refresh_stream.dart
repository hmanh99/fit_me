import 'dart:async';

import 'package:flutter/foundation.dart';

/// [Listenable] for
/// [GoRouter] call back `redirect`
/// khi stream (example: [Bloc.stream]) broad Event.
///
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
