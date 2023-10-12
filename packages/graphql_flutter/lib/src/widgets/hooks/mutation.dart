// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:graphql/client.dart';
// import 'package:graphql_flutter/src/widgets/hooks/graphql_client.dart';
// import 'package:graphql_flutter/src/widgets/hooks/watch_query.dart';

// typedef RunMutation<TParsed> = MultiSourceResult<TParsed> Function(
//   Map<String, dynamic> variables, {
//   Object? optimisticResult,
// });

// class MutationHookResult<TParsed> {
//   final RunMutation<TParsed> runMutation;
//   final QueryResult<TParsed> result;

//   MutationHookResult({
//     required this.runMutation,
//     required this.result,
//   });
// }

// Future<MutationHookResult<TParsed>> useMutation<TParsed>(
//   MutationOptions<TParsed> options,
// ) async {
//   final client = useGraphQLClient();
//   return await useMutationOnClient(client, options);
// }

// Future<MutationHookResult<TParsed>> useMutationOnClient<TParsed>(
//   GraphQLClient client,
//   MutationOptions<TParsed> options,
// ) async {
//   final watchOptions = useMemoized(
//     () => options.asWatchQueryOptions(),
//     [options],
//   );
//   final query = useWatchMutationOnClient<TParsed>(client, watchOptions);
//   final snapshot = useStream(
//     query.stream,
//     initialData: query.latestResult ?? QueryResult.unexecuted,
//   );
//   final runMutation = useCallback((
//     Map<String, dynamic> variables, {
//     Object? optimisticResult,
//   }) async {
//     final mutationCallbacks = MutationCallbackHandler(
//       cache: client.cache,
//       queryId: query.queryId,
//       options: options,
//     );
//     return await (query
//           ..variables = variables
//           ..optimisticResult = optimisticResult
//           ..onData(mutationCallbacks.callbacks) // add callbacks to observable
//         )
//         .fetchResults();
//   }, [client, query, options]);

//   return MutationHookResult(
//     runMutation: await runMutation,
//     result: snapshot.data!,
//   );
// }
