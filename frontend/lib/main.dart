import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sign_up.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Slug Swole',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var selectedIndex = 0;

  void newState(int index){
    selectedIndex = index;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Widget page;
    switch (appState.selectedIndex) {
      case 0:
        page = MyLoginPage();
      case 1:
        page = SignUpPage();
      case 2:
        page = HomePage();
      default:
        throw UnimplementedError("no widget for $appState.selectedIndex");
    }
    return page;
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  late TextEditingController controller;
  late TextEditingController passcontroller;
  late FocusNode _focusNode;
  late FocusNode _passfocusNode;
  String login = '';
  String pass = '';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    passcontroller = TextEditingController();
    _focusNode = FocusNode();
    _passfocusNode = FocusNode();  // Initialize FocusNode
  }

  @override
  void dispose() {
    _focusNode.dispose();  
    _passfocusNode.dispose();// Clean up the FocusNode when the widget is disposed
    controller.dispose();  // Dispose of the TextEditingController
    passcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: theme.primaryColor,
      //   centerTitle: true,
      //   leading: Icon(Icons.account_circle),
      //   title: Text(
      //     "Login",
      //     textAlign: TextAlign.center,
      //     style: theme.textTheme.titleLarge,
      //   ),
      // ),
      backgroundColor: theme.primaryColorDark,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/fitSlug.png",
                  height: 200,
                  scale: 2.5,
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.canvasColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
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
                            login = value;
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
                            pass = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text("Forgot Password?"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print("$login and $pass");
                          appState.newState(2);
                        },
                        child: Text(
                          "Login",
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Or Sign Up Using"
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: (){
                          appState.newState(1);
                        },
                        child: Text("Sign Up"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Add sign up with google later
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
