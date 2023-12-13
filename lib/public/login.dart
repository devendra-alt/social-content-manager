import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_content_manager/home/home.dart';
import 'package:social_content_manager/service/auth/secure.dart';
import 'package:social_content_manager/utils/snackBar.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _authValue;
  String? _passwordValue;
  String? _usernameValue;
  bool _isLoginTab = true;

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
          document: _isLoginTab ? gql("""
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
          """) : gql(""""""),
          onError: (error) {
            CustomSnackBar.showSnackBar(context, "Login Error!");
          },
          onCompleted: (dynamic resultData) {
            try {
              print(resultData);
              final token = resultData["login"]["jwt"];
              writeToSecureStorage("token", token);
            } catch (e) {
              CustomSnackBar.showSnackBar(context, "Error in fething data");
            }
          }),
      builder: (
        RunMutation runMutation,
        QueryResult? result,
      ) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
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
                  height: _isLoginTab ? 400 : 500,
                  padding: EdgeInsets.all(20),
                  child: Card(
                    color: Theme.of(context).canvasColor.withOpacity(0.9),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TabBar(
                            tabs: const [
                              Tab(
                                text: 'Login',
                              ),
                              Tab(
                                text: 'Sign Up',
                              ),
                            ],
                            onTap: (index) {
                              setState(() {
                                _isLoginTab = index == 0;
                                _clearFormValues();
                              });
                            },
                          ),
                          SizedBox(height: 20.0),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                if (!_isLoginTab)
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        _usernameValue = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Username';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Username',
                                    ),
                                  ),
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
                                    _isLoginTab
                                        ? _loginPressed(context, runMutation)
                                        : _signUpPressed(context, runMutation);
                                  },
                                  child:
                                      Text(_isLoginTab ? 'Login' : 'Sign Up'),
                                ),
                              ],
                            ),
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

  void _loginPressed(context, RunMutation runMutation) {
    print(_formKey.currentState!.validate());
    if (_formKey.currentState!.validate()) {
      print("$_authValue $_passwordValue");
      if (_authValue != null && _passwordValue != null) {
        try {
          runMutation({'email': _authValue, 'password': _passwordValue});
        } catch (e) {
          CustomSnackBar.showSnackBar(context, 'Login Error!');
        }
      }
    }
  }

  void _signUpPressed(context, runMutation) {
    if (_formKey.currentState!.validate()) {
      if (_authValue != null &&
          _passwordValue != null &&
          _usernameValue != null) {}
    }
  }

  void _clearFormValues() {
    _formKey.currentState!.reset();
    setState(() {
      _authValue = null;
      _passwordValue = null;
      _usernameValue = null;
    });
  }
}
