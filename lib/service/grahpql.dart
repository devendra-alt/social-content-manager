import 'package:graphql_flutter/graphql_flutter.dart';

import '../service/auth/Secure.dart';

void main() async{
  await initHiveForFlutter();
  final HttpLink httpLink  = HttpLink(
    'https://eksamaj.in/lmsgraphql'
  );
  final AuthLink authLink = AuthLink(getToken:() async => readFromSecureStorage("JWT"));
}


