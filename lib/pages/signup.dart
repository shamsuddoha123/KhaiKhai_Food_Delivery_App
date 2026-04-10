import 'package:flutter/material.dart';
import 'package:khaikhai/service/widget_support.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              padding: EdgeInsets.only(top: 30.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xffffefbf),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    "images/pan.png",
                    height: 180,
                    fit: BoxFit.fill,
                    width: 240,
                  ),
                  Image.asset(
                    "images/logo.png",
                    width: 150,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 3.2,
                left: 20.0,
                right: 20.0,
              ),

              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  height: MediaQuery.of(context).size.height / 1.65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Sign Up",
                          style: AppWidget.headlineTextFieldStyle(),
                        ),
                      ),

                      SizedBox(height: 30),

                      Text("Name", style: AppWidget.signUpTextFieldStyle()),

                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xffececf8),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Your Name",
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text("Email", style: AppWidget.signUpTextFieldStyle()),

                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xffececf8),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Your Email",
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text("Password", style: AppWidget.signUpTextFieldStyle()),

                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xffececf8),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Your Password",
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                      ),
                        SizedBox(height: 30,),
                      Center(
                        child: Container(
                        
                          width: 200,
                        height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xffef2b39), borderRadius: BorderRadius.circular(30)
                          ),
                        
                          child: Center(child: Text("Sign Up", style: AppWidget.boldwhiteTextFieldStyle(),)),
                        ),
                      ), 
                      SizedBox(height: 30.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text("Already have an account? ", style: AppWidget.simpleTextFieldStyle()),
                        SizedBox(width: 10,),
                        
                        Text("LogIn", style: AppWidget.boolTextFieldStyle()),
                      ],)



                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
