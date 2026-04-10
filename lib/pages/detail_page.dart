import 'package:flutter/material.dart';
import 'package:khaikhai/service/widget_support.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  String image, name, price;
  // ignore: use_key_in_widget_constructors
  DetailPage({required this.image, required this.name, required this.price});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;
  double totalprice = 0;

  @override
  void initState() {
    totalprice = double.parse(widget.price.replaceAll("\$", ""));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0),
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
                child: Icon(Icons.arrow_back, size: 30.0, color: Colors.white),
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
            Padding(
              padding: EdgeInsetsGeometry.only(right: 10.0),
              child: Text(
                "This pizza features freshly prepared dough, seasoned tomato sauce, a rich blend of mozzarella cheese, and a touch of herbs, all baked to create a perfectly crispy and cheesy delight.",
              ),
            ),
            SizedBox(height: 30.0),
            Text("Quantity", style: AppWidget.simpleTextFieldStyle()),
            SizedBox(height: 10.0),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    quantity = quantity + 1;
                    totalprice +=
                        double.parse(widget.price.replaceAll("\$", ""));
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
                      child: Icon(Icons.add, color: Colors.white, size: 30.0),
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
                      totalprice -=
                          double.parse(widget.price.replaceAll("\$", ""));
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
                        "\$$totalprice",
                        style: AppWidget.boldwhiteTextFieldStyle(),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 30.0),

                Material(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
