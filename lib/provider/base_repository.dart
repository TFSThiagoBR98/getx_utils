import 'package:logging/logging.dart';

import 'base_provider.dart';

abstract class BaseRepository<P extends BaseProvider> {
  P provider;
  Logger logger();

  BaseRepository(this.provider);
}
