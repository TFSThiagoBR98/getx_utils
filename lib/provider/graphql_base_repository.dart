import 'package:getx_utils/provider/graphql_server_provider.dart';
import 'package:logging/logging.dart';

abstract class GraphQLBaseRepository<P extends GraphQLServerProvider> {
  P provider;
  abstract final Logger logger;

  GraphQLBaseRepository(this.provider);
}
