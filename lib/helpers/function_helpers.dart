import 'package:flame/flame.dart';
import 'package:portfolio_kha/constanst/app_images.dart';

Future<void> loadAssets() async {
  await Flame.images.loadAll(AppImages.listImagsNeedLoad);
}
