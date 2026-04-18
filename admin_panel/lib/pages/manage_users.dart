import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khaikhai_admin/service/database.dart';
import 'package:khaikhai_admin/service/widget_support.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  Stream? userStream;

  Future<void> onTheLoad() async {
    userStream = await DatabaseMethods().getAllUsers();
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  Widget allUsers() {
    return StreamBuilder(
        stream: userStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.docs.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people_outline, size: 80, color: Colors.grey),
                  const SizedBox(height: 20),
                  Text("No users found", style: AppWidget.boolTextFieldStyle()),
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
                Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
                
                return Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xffef2b39),
                                child: Text(
                                  (data["Name"] ?? "U")[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data["Name"] ?? "No Name",
                                      style: AppWidget.signUpTextFieldStyle(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      data["Email"] ?? "No Email",
                                      style: AppWidget.simpleTextFieldStyle(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Delete User?"),
                                      content: Text("Are you sure you want to delete ${data["Name"] ?? "this user"}?"),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                        TextButton(
                                          onPressed: () async {
                                            await DatabaseMethods().deleteUser(ds.id);
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
                          const Divider(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.wallet, color: Colors.green),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Balance: \$${data["Wallet"] ?? "0"}",
                                    style: AppWidget.boolTextFieldStyle().copyWith(color: Colors.green),
                                  ),
                                ],
                              ),
                              Text(
                                "ID: ${ds.id.substring(0, 8)}...",
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
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
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: const Color(0xffef2b39),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 30.0),
                Text(
                  "Manage Users",
                  style: AppWidget.headlineTextFieldStyle(),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Delete All Users?"),
                        content: const Text("This will permanently remove ALL user data from the database."),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                          TextButton(
                            onPressed: () async {
                              await DatabaseMethods().deleteAllUsers();
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
            const SizedBox(height: 30.0),
            Expanded(child: allUsers()),
          ],
        ),
      ),
    );
  }
}
