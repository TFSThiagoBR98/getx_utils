import 'package:logging/logging.dart';
import 'firebase_base_provider.dart';

abstract class FirebaseBaseRepository<P extends FirebaseBaseProvider> {
  P provider;
  abstract final Logger logger;

  FirebaseBaseRepository(this.provider);
}
