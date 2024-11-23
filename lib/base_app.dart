import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:portfolio_kha/routes/router.dart';

class _BaseApp extends FlameGame  with SingleGameInstance {
  @override
  FutureOr<void> onLoad() async {
    await add(routerApp);
    return super.onLoad();
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final _BaseApp _baseApp;
  @override
  void initState() {
    _baseApp = _BaseApp();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _baseApp);
  }
}
