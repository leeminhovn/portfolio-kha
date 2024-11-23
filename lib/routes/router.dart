  import 'package:flame/game.dart';
import 'package:portfolio_kha/routes/route_names.dart';
import 'package:portfolio_kha/screens/home_screen.dart';

final RouterComponent routerApp = RouterComponent(
    initialRoute: RouteNames.home,
    routes: {
      RouteNames.home: Route(HomeScreen.new),
    },
  );
