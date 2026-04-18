import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khaikhai_admin/service/database.dart';
import 'package:khaikhai_admin/service/widget_support.dart';

class AdminOrders extends StatefulWidget {
  const AdminOrders({super.key});

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  Stream? orderStream;

  Future<void> onTheLoad() async {
    orderStream = await DatabaseMethods().getAllOrders();
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
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
                    
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, color: Colors.redAccent,),
                                  SizedBox(width: 5.0),
                                  Expanded(
                                    child: Text(
                                      data["Address"] ?? "Main Market",
                                      style: AppWidget.signUpTextFieldStyle(),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text("Delete Order?"),
                                          content: const Text("Are you sure you want to delete this order?"),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                            TextButton(
                                              onPressed: () async {
                                                await DatabaseMethods().deleteOrder(ds.id);
                                                if (context.mounted) Navigator.pop(context);
                                              },
                                              child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: const Icon(Icons.delete_outline, color: Colors.grey),
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        data["FoodImage"] ?? "images/pizza.png",
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      )),
                                  SizedBox(width: 20.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data["FoodName"] ?? "Food Item",
                                          style:
                                              AppWidget.signUpTextFieldStyle(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        SizedBox(height: 5.0),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.list_alt_outlined,
                                              color: Colors.redAccent,
                                            ),
                                            SizedBox(width: 5.0),
                                            Text(
                                              data["Quantity"] ?? "1",
                                              style: AppWidget
                                                  .boolTextFieldStyle(),
                                            ),
                                            SizedBox(width: 20.0),
                                            Icon(
                                              Icons.monetization_on_outlined,
                                              color: Colors.redAccent,
                                            ),
                                            SizedBox(width: 5.0),
                                            Text(
                                              // ignore: prefer_interpolation_to_compose_strings
                                              "\$" + (data["Total"] ?? "0"),
                                              style: AppWidget
                                                  .boolTextFieldStyle(),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5.0),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person_outline,
                                              color: Colors.redAccent,
                                            ),
                                            SizedBox(width: 5.0),
                                            Expanded(
                                              child: Text(
                                                data["Name"] ?? "User",
                                                style: AppWidget
                                                    .simpleTextFieldStyle(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.email_outlined,
                                              color: Colors.redAccent,
                                            ),
                                            SizedBox(width: 5.0),
                                            Expanded(
                                              child: Text(
                                                data["Email"] ?? "Email",
                                                style: AppWidget
                                                    .simpleTextFieldStyle(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5.0),
                                        Text(
                                          (data["Status"] ?? "Pending") + "!",
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10.0),
                                        GestureDetector(
                                          onTap: () async {
                                            if (data["ID"] != null) {
                                              await DatabaseMethods()
                                                  .updateOrderStatus(
                                                      ds.id, data["ID"]);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "User ID missing from this order record.")),
                                              );
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text(
                                              "Delivered",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0xffef2b39),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white,),
                  ),
                ),
                SizedBox(width: 30.0),
                Text(
                  "All Orders",
                  style: AppWidget.headlineTextFieldStyle(),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Delete All Orders?"),
                        content: const Text("This will permanently remove ALL global order records."),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                          TextButton(
                            onPressed: () async {
                              await DatabaseMethods().deleteAllOrders();
                              if (context.mounted) Navigator.pop(context);
                            },
                            child: const Text("Delete All", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.delete_sweep, color: Colors.red),
                  ),
                )
              ],
            ),
            SizedBox(height: 30.0),
            Expanded(child: allOrders()),
          ],
        ),
      ),
    );
  }
}
