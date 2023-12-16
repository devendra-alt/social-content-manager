import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_content_manager/home/home.dart';
import 'package:social_content_manager/main.dart';
import 'package:social_content_manager/service/auth/secure.dart';
import 'package:social_content_manager/service/providers/userProvider.dart';
import 'package:social_content_manager/utils/snackBar.dart';

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Key key = GlobalKey();

  String? _authValue;
  String? _passwordValue;
  String? _usernameValue;
  bool _isLoginTab = true;
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final userState = ref.read(userProvider.notifier);
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
          """) : gql("""
            mutation SignUp(\$username:String!,\$email:String!,\$password:String!){
            register(input:{username:\$username,email:\$email,password:\$password}){
              jwt
              user{
                id
                username
                email
              }
            }
          }
          """),
              onError: (error) {
                CustomSnackBar.showSnackBar(context, "Login Error!");
              },
              onCompleted: (dynamic resultData) {
                try {
                  final token = resultData["login"]["jwt"];
                  writeToSecureStorage("token", token);
                  final id = int.parse(resultData["login"]["user"]["id"]);

                  final username = resultData["login"]["user"]["username"];
                  final email = resultData["login"]["user"]["email"];
                  userState.addData(email, username, id);
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
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
                                          return 'Please enter Email';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Email',
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
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isObscured = !_isObscured;
                                            });
                                          },
                                          icon: Icon(
                                            _isObscured
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: _isObscured
                                                ? Colors.grey
                                                : Colors
                                                    .blue, // Change the color based on visibility
                                          ),
                                        ),
                                      ),
                                      obscureText: _isObscured,
                                    ),
                                    SizedBox(height: 24.0),
                                    ElevatedButton(
                                      onPressed: () {
                                        _isLoginTab
                                            ? _loginPressed(
                                                context, runMutation)
                                            : _signUpPressed(
                                                context, runMutation);
                                      },
                                      child: Text(
                                          _isLoginTab ? 'Login' : 'Sign Up'),
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
      },
    );
  }

  void _loginPressed(context, RunMutation runMutation) {
    if (_formKey.currentState!.validate()) {
      if (_authValue != null && _passwordValue != null) {
        try {
          runMutation({'email': _authValue, 'password': _passwordValue});
        } catch (e) {
          CustomSnackBar.showSnackBar(context, 'Login Error!!');
        }
      }
    }
  }

  void _signUpPressed(context, runMutation) {
    if (_formKey.currentState!.validate()) {
      if (_authValue != null &&
          _passwordValue != null &&
          _usernameValue != null) {
        try {
          runMutation({
            'username': _usernameValue,
            'email': _authValue,
            'password': _passwordValue
          });
        } catch (e) {
          CustomSnackBar.showSnackBar(context, 'Login Error!');
        }
      }
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
