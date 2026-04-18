import 'package:flutter/material.dart';
import 'package:khaikhai_admin/pages/admin_login.dart';
import 'package:khaikhai_admin/service/database.dart';
import 'package:khaikhai_admin/service/shared_pref.dart';
import 'package:khaikhai_admin/service/widget_support.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  String? adminUsername;

  @override
  void initState() {
    // For now, we use the default 'admin' or get from prefs if saved
    // In a real app, you'd save the admin username during login
    adminUsername = "admin"; 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
                  height: MediaQuery.of(context).size.height / 4.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(MediaQuery.of(context).size.width, 105.0),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6.5),
                    child: Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(60),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(
                          "images/delivery-man.png",
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, left: 20),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: const Color(0xffef2b39),
                          borderRadius: BorderRadius.circular(30)),
                      child: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 55.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Admin Profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Text(
              "Administrator",
              style: AppWidget.headlineTextFieldStyle(),
            ),
            const SizedBox(height: 10.0),
            Text(
              adminUsername ?? "admin",
              style: AppWidget.simpleTextFieldStyle(),
            ),
            const SizedBox(height: 30.0),
            _buildProfileOption(
              icon: Icons.logout_outlined,
              title: "Logout",
              onTap: () {
                _confirmLogout();
              },
            ),
            const SizedBox(height: 20.0),
            _buildProfileOption(
              icon: Icons.delete_forever_outlined,
              title: "Delete Admin Account",
              color: Colors.redAccent,
              onTap: () {
                _confirmDelete();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 20.0),
                Text(
                  title,
                  style: AppWidget.boolTextFieldStyle().copyWith(color: color),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_outlined, size: 18, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout from the admin panel?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await SharedPreferenceHelper().saveAdminLoginState(false);
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AdminLogin()),
                (route) => false,
              );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Admin Account"),
        content: const Text(
            "This will permanently delete the admin entry from the database. You will need to click 'Initial Admin Setup' to regain access."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await DatabaseMethods().deleteAdmin(adminUsername!);
              await SharedPreferenceHelper().saveAdminLoginState(false);
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AdminLogin()),
                (route) => false,
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
