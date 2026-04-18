import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khaikhai_admin/pages/home_admin.dart';
import 'package:khaikhai_admin/service/auth.dart';
import 'package:khaikhai_admin/service/biometric_helper.dart';
import 'package:khaikhai_admin/service/shared_pref.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController usernamecontroller = TextEditingController(); // Now used for Email
  TextEditingController passwordcontroller = TextEditingController();
  bool _isLoading = false;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    _biometricAvailable = await BiometricHelper().hasEnrolledBiometrics();
    bool isEnabled = await SharedPreferenceHelper().getBiometricEnabled();
    if (isEnabled && _biometricAvailable) {
      bool authenticated = await BiometricHelper().authenticate();
      if (authenticated) {
        if (FirebaseAuth.instance.currentUser != null) {
          SharedPreferenceHelper().saveAdminLoginState(true);
          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeAdmin()));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFededeb),
      // ignore: avoid_unnecessary_containers
      body: SingleChildScrollView(
        child: Container(
          // Allow height to be at least screen height, but expandable
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
                padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color.fromARGB(255, 53, 51, 51), Colors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height / 2,
                ),
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 60.0),
                child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Text(
                          "Let's start with\nAdmin!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 50.0,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20.0, top: 5.0, bottom: 5.0),
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(255, 160, 160, 147)),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: TextFormField(
                                    controller: usernamecontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Username';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Admin Email",
                                        hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 160, 160, 147))),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20.0, top: 5.0, bottom: 5.0),
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(255, 160, 160, 147)),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: TextFormField(
                                    controller: passwordcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Password';
                                      }
                                      return null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 160, 160, 147))),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  loginAdmin();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showForgotPasswordDialog();
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              const Text("or Log In with"),
                              SizedBox(height: 10.0),
                              GestureDetector(
                                onTap: _isLoading ? null : googleLogin,
                                child: Image.asset(
                                  "images/google.png",
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    ));
  }

  Future<void> loginAdmin() async {
    if (_formkey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernamecontroller.text.trim(),
          password: passwordcontroller.text.trim(),
        );

        // Check if user is actually an admin in the 'Admin' collection
        // Note: For simplicity, we assume anyone who can log in to this app is an admin,
        // but typically you'd check a "role" or a specific collection.
        SharedPreferenceHelper().saveAdminLoginState(true);
        if (!mounted) return;
        await _handlePostLogin();
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed: ${e.message}")));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> googleLogin() async {
    setState(() => _isLoading = true);
    try {
      User? user = await AuthMethods().signInWithGoogle();
      if (user != null) {
        SharedPreferenceHelper().saveAdminLoginState(true);
        if (!mounted) return;
        await _handlePostLogin();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Google Sign-In failed: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showForgotPasswordDialog() {
    TextEditingController resetEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Admin Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter your admin email address to receive a reset link."),
            const SizedBox(height: 20),
            TextField(
              controller: resetEmailController,
              decoration: const InputDecoration(hintText: "Email", border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              if (resetEmailController.text.isNotEmpty) {
                await AuthMethods().resetPassword(resetEmailController.text.trim());
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reset link sent!")));
              }
            },
            child: const Text("Send Link"),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePostLogin() async {
    bool isEnabled = await SharedPreferenceHelper().getBiometricEnabled();
    if (!isEnabled && _biometricAvailable) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Enable Fingerprint?"),
          content: const Text("Would you like to enable fingerprint login for admin access?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (mounted) {
                  Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context) => const HomeAdmin()));
                }
              },
              child: const Text("Later"),
            ),
            TextButton(
              onPressed: () async {
                await SharedPreferenceHelper().saveBiometricEnabled(true);
                if (!context.mounted) return;
                Navigator.pop(context);
                if (!mounted) return;
                Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context) => const HomeAdmin()));
              },
              child: const Text("Enable"),
            ),
          ],
        ),
      );
    } else {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeAdmin()));
      }
    }
  }
}
