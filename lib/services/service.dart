import 'package:graphql_flutter/graphql_flutter.dart';
class Service
{
  final HttpLink httpLink=HttpLink("http://192.168.1.204:3000/graph");
  late GraphQLClient client;
  Service()
  {
    client=GraphQLClient
    (
      link: httpLink,
      cache: GraphQLCache(store:null)
    );
  }
  Future<dynamic> getToken(password, email) async
  {
    final QueryOptions options=QueryOptions
    (
      document: gql("""
      mutation{
        getAuth(
          input:{
            password:"$password",email:"$email"
          }
        )
      }
      """),
      fetchPolicy: FetchPolicy.networkOnly
    );
    final QueryResult result=await client.query(options);
    if(result.hasException)
    {
      throw result.exception!;
    }
    return result.data;
  }
  Future<dynamic> getTareas(String tokenId) async
  {
    final QueryOptions options=QueryOptions(document:gql("""
    {
      getTasks(_id:"$tokenId"),{descripcion, fechaVencimiento, titulo, _id}
    }
    """), fetchPolicy: FetchPolicy.networkOnly);
    final QueryResult result=await client.query(options);
    if(result.hasException)
    {
      throw result.exception!;
    }
    return result.data;
  }
  Future<dynamic> createTarea(tokenId, titulo, desc, fecha)async
  {
    final QueryOptions options=QueryOptions(document:gql("""
    {
      createTask(input:{idUsuario:"$tokenId", titulo:"$titulo", descripcion:"$desc", fechaVencimiento:"$fecha"})
    }
    """));
    final QueryResult result=await client.query(options);
    if(result.hasException)
    {
      throw result.exception!;
    }
    return result.data;
  }
  Future<dynamic> deleteTarea(tokenId, id) async
  {
    final QueryOptions options=QueryOptions(document:gql("""
    {
      deleteTask(input:{idUsuario:"$tokenId", _id:"$id"})
    }
    """));
    final QueryResult result=await client.query(options);
    if(result.hasException)
    {
      throw result.exception!;
    }
    return result.data;
  }
  Future<dynamic> signUpUsuario(nombre, email, password) async
  {
    final QueryOptions options=QueryOptions
    (
      document: gql("""
        mutation{
          createUser(input:{email:"$email", password:"$password", nombre:"$nombre"})
        }
      """),fetchPolicy: FetchPolicy.networkOnly
    );
    final QueryResult result=await client.query(options);
    if(result.hasException)
    {
      throw result.exception!;
    }
    return result.data;
  }
  Future<dynamic> getTaskInfo(id) async
  {
    final QueryOptions options=QueryOptions
    (
      document: gql("""
      {
        getTaskInfo(_id:"$id"),{descripcion, fechaVencimiento, titulo, _id, estado}
      }
      """),fetchPolicy: FetchPolicy.networkOnly
    );
    final QueryResult result=await client.query(options);
    if(result.hasException)
    {
      throw result.exception!;
    }
    return result.data;
  }
  Future<dynamic> actualizarTask(user, desc, date, titulo, id) async
  {
    final QueryOptions options=QueryOptions
    (
      document: gql("""
      mutation{
        updateTask(input:{idUsuario:"$user", descripcion:"$desc", fechaVencimiento:"$date", titulo:"$titulo", _id:"$id"})
      }
      """),fetchPolicy: FetchPolicy.networkOnly
    );
    final QueryResult result=await client.query(options);
    if(result.hasException)
    {
      throw result.exception!;
    }
    return result.data;
  }
}