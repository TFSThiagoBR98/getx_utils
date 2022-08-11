import 'package:ferry/ferry.dart';
import 'package:gql_dio_link/gql_dio_link.dart';

import '../exceptions/graphql_error_exception.dart';
import 'base_server_provider.dart';

abstract class GraphQLServerProvider extends BaseServerProvider {
  Future<OperationResponse<TData, TVars>> fetchFromGraphQl<TData, TVars>(OperationRequest<TData, TVars> request) async {
    var resp = await (await graphQlClient()).request(request).first;

    if (resp.hasErrors) {
      throw GraphQLErrorException(errors: resp.graphqlErrors, linkException: resp.linkException);
    }

    return resp;
  }

  Future<Client> graphQlClient({String entrypoint = '/graphql'}) async {
    return Client(link: DioLink(entrypoint, client: await dio()));
  }
}
