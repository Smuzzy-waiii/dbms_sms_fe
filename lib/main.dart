import 'package:dbms_sms_fe/api_helper.dart';
import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Landing(),
    );
  }
}

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool isRegister = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Sensor Monitor'),
        actions: [
          TextButton(
            child: Text(
              isRegister ? 'Login' : 'Register',
            ),
            onPressed: () {
              setState(() {
                isRegister = !isRegister;
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'username',
                ),
                controller: usernameController,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'password',
                ),
                controller: passwordController,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                child: Text(isRegister ? 'Register' : 'Login'),
                onPressed: () async {
                  print("PRESSED");
                  if (isRegister) {
                    var resp = await APIHelper.register(
                        usernameController.text, passwordController.text);
                    if (resp["success"]) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen(user_id: resp["user_id"])));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(resp["detail"])));
                    }
                  } else {
                    var resp = await APIHelper.login(
                        usernameController.text, passwordController.text);
                    if (resp["success"]) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen(user_id: resp["user_id"])));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(resp["detail"])));
                    }
                  }
                },
              )
            ]),
      ),
    );
  }
}
