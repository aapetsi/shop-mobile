import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/screens/home.dart';
import 'dart:convert';
import 'package:mobile/screens/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController(text: 'apetsi@gmail.com');
  final passwordController = TextEditingController(text: 'password');
  String serverResponse = '';
  bool loading = false;

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SizedBox(
                  width: 250,
                  child: Image.asset('assets/images/login_illustration.jpg')),
            ),
            SizedBox(
              width: 350,
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.purple,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Your Email',
                  hintText: 'john@example.com',
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: 350,
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.purple,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Your Password',
                  hintText: 'john@example.com',
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 350,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  final payload = {
                    'email': emailController.text,
                    'password': passwordController.text
                  };
                  var url = Uri.http('127.0.0.1:8000', '/api/login');
                  var response = await http.post(url,
                      body: payload, headers: {"Accept": "application/json"});

                  if (response.statusCode == 200) {
                    // var decoded = jsonDecode(response.body);

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                    );
                  } else {
                    setState(() {
                      loading = false;
                      serverResponse = json.decode(response.body)['message'];
                    });
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    !loading ? const Text('Login') : const Text(''),
                    loading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.inversePrimary))
                        : const Text('')
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              child: const Text('Don\'t Have an account yet? Register!'),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const Register(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
