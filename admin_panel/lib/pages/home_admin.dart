import 'package:flutter/material.dart';
import 'package:khaikhai_admin/pages/admin_orders.dart';
import 'package:khaikhai_admin/pages/admin_profile.dart';
import 'package:khaikhai_admin/pages/manage_users.dart';
import 'package:khaikhai_admin/service/database.dart';
import 'package:khaikhai_admin/service/widget_support.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  bool _isPopulating = false;
  TextEditingController userIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Center(
              child: Text(
                "Home Admin",
                style: AppWidget.headlineTextFieldStyle(),
              ),
            ),
            SizedBox(height: 50.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminOrders()),
                );
              },
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/delivery-man.png",
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 30.0),
                      Expanded(
                        child: Text(
                          "Manage Orders",
                          style: AppWidget.boolTextFieldStyle(),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xffef2b39),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageUsers()),
                );
              },
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/team.png",
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 30.0),
                      Expanded(
                        child: Text(
                          "Manage Users",
                          style: AppWidget.boolTextFieldStyle(),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xffef2b39),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminProfile()),
                );
              },
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.admin_panel_settings_outlined,
                        size: 80,
                        color: Color(0xffef2b39),
                      ),
                      SizedBox(width: 30.0),
                      Expanded(
                        child: Text(
                          "Admin Profile",
                          style: AppWidget.boolTextFieldStyle(),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xffef2b39),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 50.0),
            if (_isPopulating)
              CircularProgressIndicator()
            else
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: userIdController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter User ID (Optional for User Orders)",
                        hintStyle: AppWidget.simpleTextFieldStyle(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () async {
                      setState(() => _isPopulating = true);
                      await DatabaseMethods().addFakeOrders(
                        userIdController.text.trim().isEmpty
                            ? null
                            : userIdController.text.trim(),
                      );
                      setState(() => _isPopulating = false);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Fake data added successfully!"),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.data_saver_on_outlined,
                      color: Colors.orange,
                    ),
                    label: Text(
                      "Populate Fake Data (Dev Tool)",
                      style: TextStyle(color: Colors.orange),
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
