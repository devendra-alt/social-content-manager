import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_content_manager/home/home.dart';
import 'package:social_content_manager/public/login.dart';
import 'package:social_content_manager/service/auth/secure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await initHiveForFlutter();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthLink authLink =
        AuthLink(getToken: () async {
          final token = await readFromSecureStorage("token");
          return "Bearer $token";
        });
    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: authLink.concat(HttpLink('https://eksamaj.in/meelangraphql')),
        cache: GraphQLCache(store: HiveStore()),
      ),
    );

    return ProviderScope(
      child: GraphQLProvider(
        client: client,
        child: MaterialApp(
          title: 'social app',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Color.fromARGB(255, 255, 152, 34)),
            useMaterial3: true,
          ),
          home:Home(),
        ),
      ),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: readFromSecureStorage("token"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return Home();
        } else {
          return Login(
            key: key,
          );
        }
      },
    );
  }
}