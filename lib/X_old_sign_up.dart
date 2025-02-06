//Old firebaseless login page
//!!!!!Unused, do not modify further!!!!!! 

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  late TextEditingController controller;
  late TextEditingController passcontroller;
  late TextEditingController usercontroller;
  late FocusNode _focusNode;
  late FocusNode _passfocusNode;
  late FocusNode _userFocusNode;
  String signUpUser = '';
  String signUpEmail = '';
  String signUpPass = '';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    passcontroller = TextEditingController();
    usercontroller = TextEditingController();
    _focusNode = FocusNode();
    _passfocusNode = FocusNode();  // Initialize FocusNode
    _userFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();  
    _passfocusNode.dispose();// Clean up the FocusNode when the widget is disposed
    _userFocusNode.dispose();
    controller.dispose();  // Dispose of the TextEditingController
    passcontroller.dispose();
    usercontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    return Scaffold(
      backgroundColor: theme.primaryColorDark,
      floatingActionButton: ElevatedButton(
        onPressed: () {
          appState.newState(0);
        },
        child: Icon(Icons.arrow_back),
      ),      
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.canvasColor,
            borderRadius: BorderRadius.circular(10),
          ),
          height: MediaQuery.sizeOf(context).height * 0.8,
          width: MediaQuery.sizeOf(context).width * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                "Sign Up",
                style: theme.textTheme.headlineLarge!.copyWith(
                  fontSize: 50,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Username"),
              ),
              TextField(
                controller: usercontroller,
                focusNode: _userFocusNode,  // Associate the FocusNode
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  icon: Icon(Icons.account_box_rounded),
                  border: UnderlineInputBorder(),
                  labelText: 'Enter Your Username',
                ),
                onChanged: (value) {
                  setState(() {
                    signUpUser = value;
                  });
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Email"),
              ),
              TextField(
                controller: controller,
                focusNode: _focusNode,  // Associate the FocusNode
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  border: UnderlineInputBorder(),
                  labelText: 'Enter Your Email',
                ),
                onChanged: (value) {
                  setState(() {
                    signUpEmail = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Password"),
              ),
              TextField(
                controller: passcontroller,
                focusNode: _passfocusNode,  // Associate the FocusNode
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  icon: Icon(Icons.password),
                  border: UnderlineInputBorder(),
                  labelText: 'Enter Your Password',
                ),
                onChanged: (value) {
                  setState(() {
                    signUpPass = value;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  print("\nUser: $signUpUser \nEmail: $signUpEmail \nPass: $signUpPass");
                },
                child: Text("Submit"),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "or"
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Login with Google NOTE: figure out how to do later"
              ),
            ],
          ),
        ),
      ),
    );
  }
}