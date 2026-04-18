import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:khaikhai/service/constant.dart';
import 'package:khaikhai/service/database.dart';
import 'package:khaikhai/service/shared_pref.dart';
import 'package:khaikhai/service/widget_support.dart';
import 'package:logger/logger.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final logger = Logger();
  String? wallet, id, name, email;
  int? add;
  TextEditingController amountcontroller = TextEditingController();
  Stream? transactionStream;

  Future<void> getTheSharedPref() async {
    wallet = await SharedPreferenceHelper().getUserWallet();
    id = await SharedPreferenceHelper().getUserId();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    
    // Fallback to FirebaseAuth for ID and Email if shared prefs are out of sync
    final user = FirebaseAuth.instance.currentUser;
    if (id == null && user != null) {
      id = user.uid;
      await SharedPreferenceHelper().saveUserId(id!);
    }
    if (email == null && user != null) {
      email = user.email;
      await SharedPreferenceHelper().saveUserEmail(email!);
    }
    
    if (id != null) {
      transactionStream = await DatabaseMethods().getTransactions(id!);
    }
    
    if (mounted) setState(() {});
  }

  Future<void> onTheLoad() async {
    await getTheSharedPref();
    
    // Fetch live balance from Firestore to ensure sync
    if (id != null) {
      try {
        DocumentSnapshot userSnapshot = await DatabaseMethods().getUserData(id!);
        if (userSnapshot.exists) {
          Map<String, dynamic>? data = userSnapshot.data() as Map<String, dynamic>?;
          if (data != null && data.containsKey("Wallet")) {
            wallet = data["Wallet"];
            await SharedPreferenceHelper().saveUserWallet(wallet!);
          }
        }
      } catch (e) {
        logger.e("Error fetching balance from Firestore: $e");
      }
    }
    
    if (wallet == null) {
      wallet = "0";
      await SharedPreferenceHelper().saveUserWallet("0");
    }
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: wallet == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.only(top: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                      elevation: 2.0,
                      child: Container(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Center(
                              child: Text(
                            "Wallet",
                            style: AppWidget.headlineTextFieldStyle(),
                          )))),
                  SizedBox(height: 30.0),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
                    child: Row(
                      children: [
                        Image.asset(
                          "images/wallet.png",
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 40.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Wallet",
                              style: AppWidget.simpleTextFieldStyle(),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "\$${wallet!}",
                              style: AppWidget.boolTextFieldStyle(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Add money",
                      style: AppWidget.boolTextFieldStyle(),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          makePayment('100');
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFE9E2E2)),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "\$100",
                            style: AppWidget.boolTextFieldStyle(),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          makePayment('50');
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFE9E2E2)),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "\$50",
                            style: AppWidget.boolTextFieldStyle(),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          makePayment('200');
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFE9E2E2)),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "\$200",
                            style: AppWidget.boolTextFieldStyle(),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 40.0),
                  GestureDetector(
                    onTap: () {
                      openEdit();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color(0xffef2b39),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          "Add Money",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Your Transactions",
                      style: AppWidget.boolTextFieldStyle(),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Expanded(child: allTransactions()),
                ],
              ),
            ),
    );
  }

  Widget allTransactions() {
    return StreamBuilder(
        stream: transactionStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.docs.length == 0) {
            return Center(
              child: Text("No transactions yet",
                  style: AppWidget.simpleTextFieldStyle()),
            );
          }
          return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
                DateTime date = (data["Date"] as Timestamp).toDate();
                String formattedDate = "${date.day} ${_getMonth(date.month)}";
                
                return Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate,
                        style: AppWidget.headlineTextFieldStyle()
                            .copyWith(fontSize: 20.0),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              data["Description"] ?? "Wallet Update",
                              style: AppWidget.simpleTextFieldStyle()
                                  .copyWith(fontSize: 12.0),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              "\$${data["Amount"]}",
                              style: AppWidget.priceTextFieldStyle()
                                  .copyWith(color: Color(0xffef2b39)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              });
        });
  }

  String _getMonth(int month) {
    List<String> months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'KhaiKhai'));

      ///now finally display payment sheeet
      displayPaymentSheet(amount);
    } catch (e, s) {
      logger.e('exception:$e$s');
    }
  }

  Future<void> displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      
      // Refresh current ID and wallet before update
      await getTheSharedPref();
      
      if (id == null) {
        logger.e("User ID is still null after payment. Database NOT updated.");
        return;
      }

      add = int.parse(wallet ?? "0") + int.parse(amount);
      await SharedPreferenceHelper().saveUserWallet(add.toString());
      await DatabaseMethods().updateUserWallet(id!, add.toString(), name: name, email: email);
      
      // Record transaction
      await DatabaseMethods().addTransaction(id!, {
        "Amount": amount,
        "Date": DateTime.now(),
        "Description": "Amount added to wallet"
      });
      
      logger.i("Firestore wallet updated successfully for user: $id ($email)");
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Money Added to Wallet Successfully",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
      );
      
      await getTheSharedPref();

      paymentIntent = null;
    } on StripeException catch (e) {
      logger.e('Error is:---> $e');
    } catch (e) {
      logger.e('$e');
    }
  }

  Future<dynamic> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretkey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      
      return jsonDecode(response.body);
    } catch (err) {
      logger.e('err charging user: ${err.toString()}');
    }
  }

  String calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  Future openEdit() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              // ignore: avoid_unnecessary_containers
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.cancel)),
                        SizedBox(
                          width: 60.0,
                        ),
                        Center(
                          child: Text(
                            "Add Money",
                            style: TextStyle(
                              color: Color(0xFF008080),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text("Amount"),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38, width: 2.0),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: amountcontroller,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Enter Amount'),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          makePayment(amountcontroller.text);
                        },
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Color(0xFF008080),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text(
                            "Pay",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
}