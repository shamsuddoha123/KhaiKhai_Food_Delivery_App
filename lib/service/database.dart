import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }
  Future addUserOrderDetails(Map<String, dynamic> userOrderMap, String id, String orderId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id).collection("Orders")
        .doc(orderId)
        .set(userOrderMap);
  }

  Future addAdminOrderDetails(Map<String, dynamic> userOrderMap, String orderId) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(orderId)
        .set(userOrderMap);
  }

  Future updateUserWallet(String id, String amount, {String? name, String? email}) async {
    Map<String, dynamic> updateMap = {"Wallet": amount};
    if (name != null) updateMap["Name"] = name;
    if (email != null) updateMap["Email"] = email;
    updateMap["Id"] = id; // Ensure Id is also present

    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(updateMap, SetOptions(merge: true));
  }

  Future<Stream<QuerySnapshot>> getUserOrders(String id) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Orders")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllOrders() async {
    return FirebaseFirestore.instance.collection("Orders").snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllUsers() async {
    return FirebaseFirestore.instance.collection("users").snapshots();
  }

  Future updateOrderStatus(String orderId, String userId) async {
    // 1. Update Global Orders
    await FirebaseFirestore.instance
        .collection("Orders")
        .doc(orderId)
        .update({"Status": "Delivered"});
    
    // 2. Update User's Personal Order History
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Orders")
        .doc(orderId)
        .update({"Status": "Delivered"});
  }

  Future<DocumentSnapshot> getAdminData(String username) async {
    return await FirebaseFirestore.instance
        .collection("Admin")
        .doc(username)
        .get();
  }
  Future<DocumentSnapshot> getUserData(String id) async {
    return await FirebaseFirestore.instance.collection("users").doc(id).get();
  }

  Future addFakeOrders([String? userId]) async {
    List<Map<String, dynamic>> fakeOrders = [
      {
        "FoodName": "Margherita Pizza",
        "FoodImage": "images/pizza1.png",
        "Quantity": "2",
        "Total": "24",
        "Name": "John Doe",
        "Email": "john@example.com",
        "Address": "123 Main St, New York",
        "Status": "On the way"
      },
      {
        "FoodName": "Beef Burger",
        "FoodImage": "images/burger2.png",
        "Quantity": "1",
        "Total": "12",
        "Name": "Jane Smith",
        "Email": "jane@example.com",
        "Address": "456 Oak Ave, Chicago",
        "Status": "Pending"
      },
      {
        "FoodName": "Veggie Tacos",
        "FoodImage": "images/tacos.png",
        "Quantity": "3",
        "Total": "18",
        "Name": "Mike Ross",
        "Email": "mike@example.com",
        "Address": "789 Pine Rd, Houston",
        "Status": "Pending"
      }
    ];

    for (var order in fakeOrders) {
      String id = "fake_${DateTime.now().millisecondsSinceEpoch}_${order["FoodName"].hashCode}";
      // Add to top-level Orders for Admin
      await FirebaseFirestore.instance.collection("Orders").doc(id).set(order);
      
      // If userId provided, add to user's personal Orders collection
      if (userId != null) {
        await FirebaseFirestore.instance.collection("users").doc(userId).collection("Orders").doc(id).set(order);
      }
    }
  }

  // Method to manually create an admin account for the first time
  Future createAdmin() async {
    return await FirebaseFirestore.instance
        .collection("Admin")
        .doc("admin")
        .set({"username": "admin", "password": "123"});
  }

  // --- NEW METHODS ---

  Future deleteUser(String id) async {
    return await FirebaseFirestore.instance.collection("users").doc(id).delete();
  }

  Future deleteOrder(String orderId) async {
    // 1. Delete Global Order
    await FirebaseFirestore.instance.collection("Orders").doc(orderId).delete();
    
    // Note: Deleting from user's personal collection is harder if we don't have the userId.
    // However, for typical cleanup, deleting the global order is the primary task.
  }

  Future deleteAllUsers() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future deleteAllOrders() async {
    var collection = FirebaseFirestore.instance.collection('Orders');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future addTransaction(String userId, Map<String, dynamic> transactionMap) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Transactions")
        .add(transactionMap);
  }

  Future<Stream<QuerySnapshot>> getTransactions(String userId) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Transactions")
        .orderBy("Date", descending: true)
        .snapshots();
  }
}
