import 'package:flutter/material.dart';
import 'package:mobile/screens/home.dart';
import 'package:mobile/screens/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  String serverResponse = '';

  register() async {
    setState(() {
      loading = true;
    });

    final payload = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text
    };

    var url = Uri.http('127.0.0.1:8000', '/api/register');
    var response = await http
        .post(url, body: payload, headers: {"Accept": "application/json"});

    if (response.statusCode == 201) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Home(),
      ));
    } else {
      setState(() {
        loading = false;
        serverResponse = json.decode(response.body)['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
                controller: nameController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
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
                    labelText: 'Your Name',
                    hintText: 'John Doe'),
              ),
            ),
            const SizedBox(height: 25),
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
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Your Email',
                  hintText: 'john.doe@example.com',
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
                  prefixIcon: Icon(Icons.password),
                  labelText: 'Your Password',
                  hintText: '****************',
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
                ),
                onPressed: () async {
                  await register();
                },
                child: const Text('Sign up'),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
                child: const Text('Already have an account? Login!'))
          ],
        ),
      ),
    );
  }
}
