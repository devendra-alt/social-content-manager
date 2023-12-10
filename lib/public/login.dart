import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_content_manager/home/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _authValue;
  String? _passwordValue;

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        document: gql('''
          mutation Login(\$email: String!, \$password: String!) {
            login(input: { identifier: \$email, password: \$password }) {
              jwt
              user {
                id
                username
                email
              }
            }
          }
        '''),
        onCompleted: (dynamic resultData) {
          print('Mutation completed: $resultData');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(key: Key('Home')),
            ),
          );
        },
        onError: (error) {
          print("Mutation Error: $error");
        },
      ),
      builder: (
          RunMutation runMutation,
          QueryResult? result,
          ) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/temple.avif"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Container(
                width: 356,
                height: 400,
                padding: EdgeInsets.all(20),
                child: Card(
                  color: Theme.of(context).canvasColor.withOpacity(0.9),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                _authValue = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Username or Email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Username or Email',
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                _passwordValue = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 24.0),
                          ElevatedButton(
                            onPressed: () {
                              _loginPressed(runMutation);
                            },
                            child: Text('Login'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _loginPressed(RunMutation runMutation) {
    if (_formKey.currentState!.validate()) {
      if (_authValue != null && _passwordValue != null) {
        runMutation({
          'email': _authValue,
          'password': _passwordValue,
        });
      }
    }
  }
}
