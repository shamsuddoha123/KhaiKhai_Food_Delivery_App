import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khaikhai/service/database.dart';
import 'package:khaikhai/service/shared_pref.dart';
import 'package:khaikhai/service/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id;
  Stream? orderStream;

  Future<void> getTheSharedPref() async {
    id = await SharedPreferenceHelper().getUserId();
    // Fallback to FirebaseAuth UID if shared prefs is null/out of sync
    // ignore: unnecessary_null_comparison
    if (id == null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        id = user.uid;
        // Resave to shared prefs to sync up
        await SharedPreferenceHelper().saveUserId(id!);
      }
    }
    if (mounted) setState(() {});
  }

  Future<void> onTheLoad() async {
    await getTheSharedPref();
    if (id != null) {
      orderStream = await DatabaseMethods().getUserOrders(id!);
    }
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  Widget allOrders() {
    return StreamBuilder(
        stream: orderStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (orderStream == null) {
            return Center(child: Text("Loading your orders...", style: AppWidget.simpleTextFieldStyle()));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.docs.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text("No orders yet!", style: AppWidget.boolTextFieldStyle()),
                ],
              ),
            );
          }
          return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                ds["FoodImage"],
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              )),
                          SizedBox(width: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ds["FoodName"],
                                style: AppWidget.signUpTextFieldStyle(),
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Icon(Icons.list_alt_outlined, color: Colors.redAccent,),
                                  SizedBox(width: 5.0),
                                  Text(
                                    ds["Quantity"],
                                    style: AppWidget.boolTextFieldStyle(),
                                  ),
                                  SizedBox(width: 20.0),
                                  Icon(Icons.monetization_on_outlined, color: Colors.redAccent,),
                                  SizedBox(width: 5.0),
                                  Text(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    "\$" + ds["Total"],
                                    style: AppWidget.boolTextFieldStyle(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                ds["Status"] + "!",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            Center(
                child: Text(
              "Orders",
              style: AppWidget.headlineTextFieldStyle(),
            )),
            SizedBox(height: 30.0),
            Expanded(child: allOrders()),
          ],
        ),
      ),
    );
  }
}