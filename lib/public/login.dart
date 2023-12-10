import 'package:flutter/material.dart';
import 'package:social_content_manager/home/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

   Map<String,String> fieldData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/temple.avif"),
                fit: BoxFit.cover)
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: <Widget>[
                     TextField(
                      onChanged: (value){
                        setState(() {
                          fieldData["auth"] = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Username or Email',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      onChanged: (value){
                        setState(() {
                          fieldData["password"] = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(key: Key('Home')
                                )
                            )
                        );
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
    );
  }
}
