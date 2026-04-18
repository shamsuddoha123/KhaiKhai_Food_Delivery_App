import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:khaikhai/service/database.dart';
import 'package:khaikhai/service/shared_pref.dart';
import 'package:khaikhai/service/constant.dart';
import 'package:khaikhai/service/widget_support.dart';
import 'package:logger/logger.dart';
import 'package:random_string/random_string.dart';

class DetailPage extends StatefulWidget {
  final String image, name, price;

  const DetailPage({
    super.key,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final logger = Logger();
  Map<String, dynamic>? paymentIntent;
  String? name, id, email;
  int quantity = 1;
  double totalprice = 0;

  Future<void> getTheSharedPref() async {
    name = await SharedPreferenceHelper().getUserName();
    id = await SharedPreferenceHelper().getUserId();
    email = await SharedPreferenceHelper().getUserEmail();

    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    totalprice = double.parse(widget.price.replaceAll("\$", ""));
    getTheSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xffef2b39),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child:
                      Icon(Icons.arrow_back, size: 30.0, color: Colors.white),
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: Image.asset(
                  widget.image,
                  height: MediaQuery.of(context).size.height / 3,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 20.0),
              Text(widget.name, style: AppWidget.headlineTextFieldStyle()),
              Text(widget.price, style: AppWidget.priceTextFieldStyle()),
              SizedBox(height: 30.0),
              Text(
                "This pizza features freshly prepared dough, seasoned tomato sauce, a rich blend of mozzarella cheese, and a touch of herbs, all baked to create a perfectly crispy and cheesy delight.",
              ),
              SizedBox(height: 30.0),
              Text("Quantity", style: AppWidget.simpleTextFieldStyle()),
              SizedBox(height: 10.0),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      quantity = quantity + 1;
                      totalprice += double.parse(
                        widget.price.replaceAll("\$", ""),
                      );
                      setState(() {});
                    },
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xffef2b39),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            Icon(Icons.add, color: Colors.white, size: 30.0),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    quantity.toString(),
                    style: AppWidget.headlineTextFieldStyle(),
                  ),
                  SizedBox(width: 20.0),
                  GestureDetector(
                    onTap: () {
                      if (quantity > 1) {
                        quantity = quantity - 1;
                        totalprice -= double.parse(
                          widget.price.replaceAll("\$", ""),
                        );
                        setState(() {});
                      }
                    },
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xffef2b39),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 60,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Color(0xffef2b39),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "\$${totalprice.toStringAsFixed(2)}",
                          style: AppWidget.boldwhiteTextFieldStyle(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30.0),
                  GestureDetector(
                    onTap: () {
                      makePayment(totalprice.toStringAsFixed(2));
                    },
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 70,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "ORDER NOW",
                            style: AppWidget.whiteTextFieldStyle(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent?['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'KhaiKhai',
        ),
      );

      displayPaymentSheet(amount);
    } catch (e, s) {
      logger.e('Error is : ---> $e $s');
    }
  }

  Future<void> displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      
      // Fetch fresh data immediately after success to ensure IDs are not null
      name ??= await SharedPreferenceHelper().getUserName();
      id ??= await SharedPreferenceHelper().getUserId();
      email ??= await SharedPreferenceHelper().getUserEmail();

      if (!mounted) return;

      String orderId = randomAlphaNumeric(10);

      Map<String, dynamic> userOrderMap = {
        "Name": name,
        "ID": id,
        "Quantity": quantity.toString(),
        "Total": totalprice.toStringAsFixed(2),
        "Email": email,
        "FoodName": widget.name,
        "FoodImage": widget.image,
        "OrderId": orderId,
        "Status": "Pending",
      };

      if (id != null) {
        await DatabaseMethods().addUserOrderDetails(userOrderMap, id!, orderId);
        await DatabaseMethods().addAdminOrderDetails(userOrderMap, orderId);
      } else {
        logger.e("User ID is still null after payment. Order NOT saved.");
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Order Placed Successfully",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
      );

      paymentIntent = null;
    } on StripeException catch (e) {
      logger.e('Stripe error: $e');
    } catch (e) {
      logger.e('General error: $e');
    }
  }

  Future<dynamic> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretkey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      return jsonDecode(response.body);
    } catch (err) {
      logger.e('err charging user: ${err.toString()}');
    }
  }

  String calculateAmount(String amount) {
    // Parse as double first, multiply by 100, then round to int
    final calculatedAmount = (double.parse(amount) * 100).round();
    return calculatedAmount.toString();
  }
}
