import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_content_manager/public/login.dart';
import 'package:social_content_manager/service/auth/secure.dart';

void main() async {
  await initHiveForFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthLink authLink =
        AuthLink(getToken: () async => await readFromSecureStorage("token"));
    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: authLink.concat(HttpLink('https://eksamaj.in/meelangraphql')),
        cache: GraphQLCache(store: HiveStore()),
      ),
    );

    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: '',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Social Content Management!'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Login(key: const Key('Login'));
  }
}
